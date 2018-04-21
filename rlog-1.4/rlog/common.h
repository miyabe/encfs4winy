/*****************************************************************************
 * Author:   Valient Gough <vgough@pobox.com>
 *
 *****************************************************************************
 * Copyright (c) 2002-2004, Valient Gough
 * Copyright (c) 2004, Vadim Zeitlin
 *
 * This library is free software; you can distribute it and/or modify it under
 * the terms of the GNU Lesser General Public License (LGPL), as published by
 * the Free Software Foundation; either version 2.1 of the License, or (at your
 * option) any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the LGPL in the file COPYING for more
 * details.
 *
 */

#ifndef _rlogconfig_incl_
#define _rlogconfig_incl_

// we don't have GNU printf style attributes
#define HAVE_PRINTF_ATTR 0
#define HAVE_PRINTF_FP 0
# define RLOG_SECTION 

/* Defined by configure if our compiler understands VARIADAC macros.  */
#define C99_VARIADAC_MACROS 1
#define PREC99_VARIADAC_MACROS 0

#define RLOG_TIME_TSC 0

# define PRINTF(FMT,X)
# define PRINTF_FP(FMT,X)
# define   likely(x)  (x)
# define unlikely(x)  (x)

/*! @def RLOG_COMPONENT
    @brief Specifies build-time component, eg -DRLOG_COMPONENT="component-name"

    Define RLOG_COMPONENT as the name of the component being built.
    For example, as a compile flag,  -DRLOG_COMPONENT="component-name"

    If RLOG_COMPONENT is not specified, then it will be defined as "[unknown]"
*/
#ifndef RLOG_COMPONENT
#  pragma message("rlog/common.h: RLOG_COMPONENT not defined - setting to UNKNOWN")
#define RLOG_COMPONENT "[unknown]"
#endif // RLOG_COMPONENT not defined

// Use somewhat unique names (doesn't matter if they aren't as they are used in
// a private context, so the compiler will make them unique if it must)
#  define LOGID CONCAT(_rL_, __LINE__)

/*! @def RLOG_DECL
    @brief Macro used for declaring C++ clsas and functions to export from a
    shared library on Windows.
*/
#ifdef _WIN32
#  ifdef RLOG_EXPORTS
#    define RLOG_DECL __declspec(dllexport)
#  else
#    define RLOG_DECL __declspec(dllimport)
#  endif // building/using DLL
#else // !_WIN32
#  define RLOG_DECL
#endif

#ifdef _MSC_VER
/* Visual Studio 2008 have it's own definition */
#  if _MSC_VER < 1500
#    define vsnprintf _vsnprintf
#  endif /* _MSC_VER */

    // suppress annoying warnings about using STL templates in DLL-exported
    // classes
#   pragma warning(disable:4251)
#   pragma warning(disable:4275)
#endif /* _MSC_VER */

#endif // _rlogconfig_incl_

