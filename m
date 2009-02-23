From: Karel Zak <kzak@redhat.com>
Subject: uti-linux-ng libblkid
Date: Mon, 23 Feb 2009 18:38:51 +0100
Message-ID: <1235410733-4193-1-git-send-email-kzak@redhat.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:32955 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751610AbZBWRji (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Feb 2009 12:39:38 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

here are two patches that allow to link utils from e2fsprogs with
external libblkid (e.g. the version from util-linux-ng).

Note that the patches don't include *generated* stuff from the configure
script.

Changes:
	- add --disable-libblkid
	- don't build & install blkid(8) and findfs(8)

Note that I'm not sure of your opinion about "#include blkid.h". The
code in e2fsprogs mix "blkid/blkid.h" and "blkid.h" (and somewhere it
depends on #ifdef :-). I think the best would be to remove the directory
and use "-Ilib/blkid" (for private libblkid) or CFLAGS from pkg-config
(for external libblkid). Anyway the code compiles with the current
"#include" directives, so I didn't touch this stuff.

  Karel


