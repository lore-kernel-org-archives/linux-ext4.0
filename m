From: "Dilger, Andreas" <andreas.dilger@intel.com>
Subject: Unable to build e2fsprogs 1.42.11 on RHEL 5
Date: Thu, 24 Jul 2014 22:04:53 +0000
Message-ID: <CFF6DF2A.B393D%andreas.dilger@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:32701 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164AbaGXWFL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Jul 2014 18:05:11 -0400
Content-Language: en-US
Content-ID: <C60D0EA9801B724B8672FB878EA446D1@intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I'm unable to build the latest e2fsprogs on RHEL 5, since it returns an
error running autoconf:

  autoconf
  aclocal.m4:3095: error: Autoconf version 2.60 or higher is required
  aclocal.m4:3095: the top level


The "2.60" version is explicitly checked in aclocal.m4, and changing it
to "2.59" (as is shipped with RHEL5) results in more errors:

  autoconf
  configure.in:903: warning: AC_PROG_MKDIR_P is m4_require'd but is not
m4_defun'd
  configure.in:903: AC_PROG_MKDIR_P is required by...
  aclocal.m4:3292: AM_PO_SUBDIRS is expanded from...
  configure.in:903: AM_PO_SUBDIRS is required by...
  aclocal.m4:626: AM_GNU_GETTEXT is expanded from...
  configure.in:903: the top level
  [etc]

It looks like this was added in commit 93613951 "aclocal.m4: update to
newer
versions of autoconf macros".  Was there a particular reason for that
change
(there is no explanation given in the commit message)?  I tried reverting
that patch to build on RHEL5 again, and it also appears to work on RHEL6,
but
there may be issues with newer autoconf versions...

Cheers, Andreas
-- 
Andreas Dilger

Lustre Software Architect
Intel High Performance Data Division


