From: Ernesto =?utf-8?Q?A=2E_Fern=C3=A1ndez?=
        <ernesto.mnd.fernandez@gmail.com>
Subject: [PATCH] ext4: correct documentation for grpid mount option
Date: Sun, 3 Dec 2017 00:56:50 -0300
Message-ID: <20171203035647.GA6841@debian.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Ernesto =?utf-8?Q?A=2E_Fern=C3=A1ndez?=
        <ernesto.mnd.fernandez@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:40556 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751851AbdLCD4z (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 2 Dec 2017 22:56:55 -0500
Received: by mail-qk0-f196.google.com with SMTP id b123so17760079qkg.7
        for <linux-ext4@vger.kernel.org>; Sat, 02 Dec 2017 19:56:55 -0800 (PST)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The grpid option is currently described as being the same as nogrpid.

Signed-off-by: Ernesto A. Fernández <ernesto.mnd.fernandez@gmail.com>
---
 Documentation/filesystems/ext4.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/filesystems/ext4.txt b/Documentation/filesystems/ext4.txt
index 75236c0..d081ce0 100644
--- a/Documentation/filesystems/ext4.txt
+++ b/Documentation/filesystems/ext4.txt
@@ -233,7 +233,7 @@ data_err=ignore(*)	Just print an error message if an error occurs
 data_err=abort		Abort the journal if an error occurs in a file
 			data buffer in ordered mode.
 
-grpid			Give objects the same group ID as their creator.
+grpid			New objects have the group ID of their parent.
 bsdgroups
 
 nogrpid		(*)	New objects have the group ID of their creator.
-- 
2.1.4
