From: Boxi Liu <boxi10liu@gmail.com>
Subject: fix the ext4_read_inline_dir return value
Date: Tue, 17 Sep 2013 23:08:51 +0800
Message-ID: <CAAFszuWi7u_-eYFBB=hvWqfZBcZBhneVK8m6JZhzd9Hakh8oiA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Theodore Tso <tytso@mit.edu>, Robin Dong <sanbai@taobao.com>,
	"tm@tao.ma" <tm@tao.ma>, "lewis.liulei" <lewis.liulei@huawei.com>,
	pamirs <pamirs@163.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ie0-f170.google.com ([209.85.223.170]:55099 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627Ab3IQPIv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 17 Sep 2013 11:08:51 -0400
Received: by mail-ie0-f170.google.com with SMTP id x13so10533893ief.15
        for <linux-ext4@vger.kernel.org>; Tue, 17 Sep 2013 08:08:51 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

hi=A3=AC
there may be a bug in ext4_read_inline_dir() function with inline_data =
feature.
when I recursion call a sys_old_readdir to read a direntry's
sub_dentry,I find that the ext4_read_inline_dir return the len of the
inline_data ,but in the no inline_data case,it will return 0.It is
inconsistent.
So I try to make a patch to fix it.

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index d9ecbf1..3ea39cd 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1441,7 +1441,7 @@ int ext4_read_inline_dir(struct file *file,
  up_read(&EXT4_I(inode)->xattr_sem);
  if (ret < 0)
  goto out;
