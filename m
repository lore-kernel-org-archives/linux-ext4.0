From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 74171] Attempting to build recent version of e2fsprogs from git
 repo gives config.h missing
Date: Thu, 17 Apr 2014 21:31:04 +0000
Message-ID: <bug-74171-13602-MhTvgGy52V@https.bugzilla.kernel.org/>
References: <bug-74171-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:40113 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750874AbaDQVbH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Apr 2014 17:31:07 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 7AC3B20306
	for <linux-ext4@vger.kernel.org>; Thu, 17 Apr 2014 21:31:06 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id AC904202EC
	for <linux-ext4@vger.kernel.org>; Thu, 17 Apr 2014 21:31:04 +0000 (UTC)
In-Reply-To: <bug-74171-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=3D74171

--- Comment #4 from Theodore Tso <tytso@mit.edu> ---

> gcc: error: unrecognized command line option =E2=80=98-checker=E2=80=99

See: http://www.gnu.org/software/checker/   for an explanation.  It's s=
omething
the gcc folks stopped supporting, and I never got around to getting rid=
 of the
configure option.

As far as the missing "crc32c_table.h", that looks like "make depend" i=
s not
working on your setup.   I'd recommend getting the original Makefile.in=
 files
from upstream, and not trying to run "make depend".   I run it before I=
 do a
release, but it's never something I've tried to make to be fully portab=
le and
bulletproof for every single possible VPATH setting, etc.   It's intend=
ed for
use by developers, and not for random users who are trying to build e2f=
sprogs.

=46or similar reasons, that's why I also ship a generated configure scr=
ipt ---
because I got tired of random breakages caused by people happening to u=
se a
different version of autoconf than what I happened to be developing aga=
inst.=20
autoconf, automake, etc., are inherently fragile solutions.  You really=
 should
be using the version of configure and the Makefile.in files that I ship=
ped.  If
you try to regenerate them, you're just asking for trouble.

Why don't you follow the INSTALL directions exactly.  That will work.  =
Other
things, well, feel free to send me patches.  :-)

--=20
You are receiving this mail because:
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
