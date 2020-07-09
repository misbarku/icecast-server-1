dnl with_pkg.m4 - Macros to ease the usage of pkg-config.    -*- Autoconf -*-
dnl
dnl Copyright © 2008 Luca Barbato <lu_zero@gentoo.org>,
dnl                  Diego Pettenò <flameeyes@gentoo.org>
dnl                  Jean-Baptiste Kempf
dnl
dnl This program is free software; you can redistribute it and/or modify
dnl it under the terms of the GNU General Public License as published by
dnl the Free Software Foundation; either version 2 of the License, or
dnl (at your option) any later version.
dnl
dnl This program is distributed in the hope that it will be useful, but
dnl WITHOUT ANY WARRANTY; without even the implied warranty of
dnl MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
dnl General Public License for more details.
dnl
dnl You should have received a copy of the GNU General Public License
dnl along with this program; if not, write to the Free Software
dnl Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
dnl
dnl As a special exception to the GNU General Public License, if you
dnl distribute this file as part of a program that contains a
dnl configuration script generated by Autoconf, you may include it under
dnl the same distribution terms that you use for the rest of that program.

dnl PKG_WITH_MODULES(VARIABLE-PREFIX, MODULES,
dnl                  [ACTION-IF-FOUND],[ACTION-IF-NOT-FOUND],
dnl                  [DESCRIPTION])
dnl
dnl Prepare a --with-variable-prefix triggered check for module,
dnl disable by default.
dnl

AC_DEFUN([PKG_WITH_MODULES],
[
AC_REQUIRE([PKG_PROG_PKG_CONFIG])
m4_pushdef([with_arg], m4_tolower([$1]))

m4_pushdef([description],
           [m4_default([$5], [Ignore presence of ]with_arg[ and disable it])])

m4_pushdef([def_action_if_found], [AS_TR_SH([have_]with_arg)=yes])
m4_pushdef([def_action_if_not_found], [AS_TR_SH([have_]with_arg)=no])

AC_ARG_WITH(with_arg,
    AS_HELP_STRING([--without-]with_arg, description))

AS_IF([test "$AS_TR_SH([with_]with_arg)" != "no"],
    [
        PKG_CHECK_MODULES([$1],[$2],
            [m4_n([def_action_if_found]) $3],
            [m4_n([def_action_if_not_found]) $4])
    ], [m4_n([def_action_if_not_found])])

m4_popdef([with_arg])
m4_popdef([description])

]) dnl PKG_WITH_MODULES

dnl PKG_HAVE_WITH_MODULES(VARIABLE-PREFIX, MODULES,
dnl                       [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND])
dnl

AC_DEFUN([PKG_HAVE_WITH_MODULES],
[
PKG_WITH_MODULES([$1],[$2],[$3],[$4])

m4_pushdef([with_arg], m4_tolower([$1]))

AS_IF([test "$AS_TR_SH([have_]with_arg)" != "yes"],
    [
        AS_IF([test "$AS_TR_SH([with_]with_arg)" = "yes"],
            [AC_MSG_ERROR(AS_TR_SH(with_arg)[ requested but not found. (${]AS_TR_SH([$1][_PKG_ERRORS])[})])])
    ], [
        AC_DEFINE([HAVE_][$1], 1, [Define if the ]with_arg[ library is available])
    ])

AM_CONDITIONAL([HAVE_][$1],
               [test "$AS_TR_SH([have_]with_arg)" = "yes"])

m4_popdef([with_arg])
])
