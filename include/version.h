/// \file version.h

#pragma once

/// major verion
#define CPP_TEMPLATE_VER_MAJOR 1
/// minor version
#define CPP_TEMPLATE_VER_MINOR 0
/// patch version
#define CPP_TEMPLATE_VER_PATCH 3

/// version
#define CPP_TEMPLATE_VERSION                                       \
  (CPP_TEMPLATE_VER_MAJOR * 10000 + CPP_TEMPLATE_VER_MINOR * 100 + \
   CPP_TEMPLATE_VER_PATCH)
