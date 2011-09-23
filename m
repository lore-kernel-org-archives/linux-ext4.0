From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH] Add better example about how to compress e2image raw image
Date: Fri, 23 Sep 2011 15:47:52 -0300
Message-ID: <1316803672-25550-1-git-send-email-cmaiolino@redhat.com>
Cc: Carlos Maiolino <cmaiolino@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from [187.60.101.4] ([187.60.101.4]:46991 "EHLO
	andromeda.usersys.redhat.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751578Ab1IWS4r (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 23 Sep 2011 14:56:47 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The current example in the man page uses bzip2 to compress
the raw image file created by the e2image, but, bzip2 does
not honors sparse files, which causes the image to have the
same size of the filesystem.
Using tar together with bzip2 will make the compressed file
to honor the sparsed file, which makes it more transportable
than the current one if the filesystem is large.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 misc/e2image.8.in |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/misc/e2image.8.in b/misc/e2image.8.in
index 74d2a0b..fcf3d20 100644
--- a/misc/e2image.8.in
+++ b/misc/e2image.8.in
@@ -115,7 +115,7 @@ as part of bug reports to e2fsprogs.  When used in this capacity, the
 recommended command is as follows (replace hda1 with the appropriate device):
 .PP
 .br
-\	\fBe2image \-r /dev/hda1 \- | bzip2 > hda1.e2i.bz2\fR
+\	\fBe2image \-r /dev/hda1 hda1.e2i && tar Sjcvf e2i.tar.bz2 hda1.e2i\fR
 .PP
 This will only send the metadata information, without any data blocks.  
 However, the filenames in the directory blocks can still reveal
-- 
1.7.5.2

