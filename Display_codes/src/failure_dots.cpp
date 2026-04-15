#include "failure_dots.h"

#include <cmath>

namespace failure_dots {

namespace {

constexpr uint8_t kSeverityHighThreshold = 70;
constexpr uint8_t kDotPersistenceRevs = 3;
constexpr uint16_t kMaxFailureDots = 96;
constexpr int16_t kArcDotInset = 10;

struct FailureDot {
  lv_obj_t* obj = nullptr;
  uint32_t rev = 0;
  bool active = false;
};

FailureDot dots[kMaxFailureDots];
uint16_t dot_next = 0;
lv_obj_t* dot_screen = nullptr;
lv_obj_t* dot_arc = nullptr;

void get_arc_ring_geometry(int16_t* center_x, int16_t* center_y, int16_t* radius) {
  lv_area_t area;
  lv_obj_get_coords(dot_arc, &area);

  const int16_t width = static_cast<int16_t>(area.x2 - area.x1 + 1);
  const int16_t height = static_cast<int16_t>(area.y2 - area.y1 + 1);

  *center_x = static_cast<int16_t>((area.x1 + area.x2) / 2);
  *center_y = static_cast<int16_t>((area.y1 + area.y2) / 2);

  const int16_t min_dim = (width < height) ? width : height;
  *radius = static_cast<int16_t>((min_dim / 2) - kArcDotInset);
  if (*radius < 0) {
    *radius = 0;
  }
}

void position_dot_for_second(lv_obj_t* dot, uint16_t sec_mod) {
  int16_t center_x = 0;
  int16_t center_y = 0;
  int16_t radius = 0;
  get_arc_ring_geometry(&center_x, &center_y, &radius);

  const float angle_deg = static_cast<float>(sec_mod) - 90.0f;
  const float angle_rad = angle_deg * 3.1415926f / 180.0f;
  const int16_t x = static_cast<int16_t>(center_x + std::cos(angle_rad) * radius);
  const int16_t y = static_cast<int16_t>(center_y + std::sin(angle_rad) * radius);
  const int16_t w = static_cast<int16_t>(lv_obj_get_width(dot));
  const int16_t h = static_cast<int16_t>(lv_obj_get_height(dot));

  lv_obj_set_pos(dot, static_cast<int32_t>(x - (w / 2)), static_cast<int32_t>(y - (h / 2)));
}

}  // namespace

void initialize(lv_obj_t* screen, lv_obj_t* arc) {
  dot_screen = screen;
  dot_arc = arc;
  dot_next = 0;

  for (uint16_t i = 0; i < kMaxFailureDots; i++) {
    dots[i].active = false;
    dots[i].rev = 0;
    if (dots[i].obj != nullptr) {
      lv_obj_add_flag(dots[i].obj, LV_OBJ_FLAG_HIDDEN);
    }
  }
}

void refresh(uint32_t total_sec) {
  const uint32_t now_rev = total_sec / 360U;

  for (uint16_t i = 0; i < kMaxFailureDots; i++) {
    if (!dots[i].active || dots[i].obj == nullptr) {
      continue;
    }

    const uint32_t age_revs = now_rev - dots[i].rev;
    if (age_revs >= kDotPersistenceRevs) {
      dots[i].active = false;
      lv_obj_add_flag(dots[i].obj, LV_OBJ_FLAG_HIDDEN);
      continue;
    }

    lv_opa_t opa = LV_OPA_100;
    if (age_revs == 1U) {
      opa = LV_OPA_70;
    } else if (age_revs == 2U) {
      opa = LV_OPA_40;
    }
    lv_obj_set_style_bg_opa(dots[i].obj, opa, LV_PART_MAIN | LV_STATE_DEFAULT);
  }
}

void add_dot(uint32_t total_sec, uint8_t severity) {
  if (dot_screen == nullptr || dot_arc == nullptr) {
    return;
  }

  FailureDot& dot = dots[dot_next];
  dot_next = static_cast<uint16_t>((dot_next + 1U) % kMaxFailureDots);

  if (dot.obj == nullptr) {
    dot.obj = lv_obj_create(dot_screen);
    lv_obj_remove_style_all(dot.obj);
    lv_obj_remove_flag(dot.obj, LV_OBJ_FLAG_CLICKABLE);
    lv_obj_set_style_border_width(dot.obj, 0, LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_radius(dot.obj, LV_RADIUS_CIRCLE, LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_move_foreground(dot.obj);
  }

  dot.rev = total_sec / 360U;
  dot.active = true;

  const int16_t size = (severity >= kSeverityHighThreshold) ? 8 : 5;
  lv_obj_set_size(dot.obj, size, size);
  lv_obj_set_style_bg_color(
      dot.obj,
      (severity >= kSeverityHighThreshold) ? lv_color_hex(0xFF3A3A) : lv_color_hex(0xC81010),
      LV_PART_MAIN | LV_STATE_DEFAULT);
  lv_obj_clear_flag(dot.obj, LV_OBJ_FLAG_HIDDEN);

  position_dot_for_second(dot.obj, static_cast<uint16_t>(total_sec % 360U));
  refresh(total_sec);
}

}  // namespace failure_dots
