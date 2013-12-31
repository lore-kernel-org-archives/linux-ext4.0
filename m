From: jon ernst <jonernst07@gmail.com>
Subject: [PATCH 1/1] e2image: mark strings for internationalization
Date: Tue, 31 Dec 2013 01:50:31 -0500
Message-ID: <CAGW2f1HVxJ0HoLpGobRTut2kD=Zsao3qFcfjmm6Qr2Ux48UfAw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: "linux-ext4@vger.kernel.org List" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qe0-f45.google.com ([209.85.128.45]:58674 "EHLO
	mail-qe0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099Ab3LaGuc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 31 Dec 2013 01:50:32 -0500
Received: by mail-qe0-f45.google.com with SMTP id 6so12066494qea.4
        for <linux-ext4@vger.kernel.org>; Mon, 30 Dec 2013 22:50:31 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Subject: [PATCH 1/1] e2image: mark strings  for internationalization

Signed-off-by: Jon Ernst <jonernst07@gmail.com>
---
 misc/e2image.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/misc/e2image.c b/misc/e2image.c
index c134ba2..74515c8 100644
--- a/misc/e2image.c
+++ b/misc/e2image.c
@@ -1408,7 +1408,7 @@ static void install_image(char *device, char
*image_fn, int type)

  retval = ext2fs_image_inode_read(fs, fd, 0);
  if (retval) {
- com_err(image_fn, 0, "while restoring the image table");
+ com_err(image_fn, 0, _("while restoring the image table"));
  exit(1);
  }

@@ -1595,7 +1595,7 @@ skip_device:
  }
  if (fd != 1) {
  if (fstat(fd, &st)) {
- com_err(program_name, 0, "Can not stat output\n");
+ com_err(program_name, 0, _("Can not stat output\n"));
  exit(1);
  }
  if (S_ISBLK(st.st_mode))
-- 
1.8.3.2
