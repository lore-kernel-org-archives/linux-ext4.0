From: Michael Shields <mshields@google.com>
Subject: [PATCH] Doc fix: ext2 can only have 32,000 subdirs, not 32,768.
Date: Mon, 18 May 2009 12:13:51 -0700
Message-ID: <63a2e74f0905181213r54a2d8b2tb7dcecd177d474c2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
To: rdunlap@xenotime.net, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:39197 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260AbZERTNy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 18 May 2009 15:13:54 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext2.txt says that dirs can have 32,768 subdirs, but the actual value
of EXT2_LINK_MAX is 32000.
ext3 is the same, but the doc does not mention it. =C2=A0One of ext4's
features is to "fix 32000 subdirectory limit".

--- linux-2.6.29.3/Documentation/filesystems/ext2.txt.orig 2009-05-08
15:47:21.000000000 -0700
+++ linux-2.6.29.3/Documentation/filesystems/ext2.txt 2009-05-18
12:03:58.000000000 -0700
@@ -322,7 +322,7 @@ an upper limit on the block size imposed
=C2=A0so 8kB blocks are only allowed on Alpha systems (and other archit=
ectures
=C2=A0which support larger pages).

-There is an upper limit of 32768 subdirectories in a single directory.
+There is an upper limit of 32000 subdirectories in a single directory.

=C2=A0There is a "soft" upper limit of about 10-15k files in a single d=
irectory
=C2=A0with the current linear linked-list directory implementation. =C2=
=A0This limit
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
