From: Robert Yang <liezhi.yang@windriver.com>
Subject: [RFC] e2fsprogs/mke2fs: add an option  "-d root-directory"
Date: Mon, 5 Aug 2013 16:40:31 +0800
Message-ID: <51FF64FF.5090309@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Darren Hart <dvhart@linux.intel.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.windriver.com ([147.11.1.11]:55590 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754371Ab3HEIkh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 5 Aug 2013 04:40:37 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Hello folks,

I'd like to add an "-d root-directory" option for mke2fs, which is used
for adding files from the "root-directory" to the filesystem after the
formatting, it is similar to genext2fs, but which only supports ext2 AFAIK.
it's usage example would be:

$ mke2fs -t extX -d <dir> <device>

I've done a few work on it, we can re-use the code from debugfs/debugfs.c,
here are the draft implementation thoughts:

Move a part of the code from debugfs/debugfs.c to misc/util.c, for example,
we will change the function do_write() in debugfs.c to:

void do_write(int argc, char *argv[])
{
	[snip];
	retval = do_write_internal();
         [snip];
}

The do_write_internal() will be defined in misc/util.c, then both debugfs.c
and mke2fs.c can use it. We will do the similar thing to do_mkdir(),
do_symlink() and so on.

My questions are:
1) Is the "-d root-directory" option acceptable ?
2) Is the implementation idea OK ?

Please feel free to give your comments, and I will send the patches later
if this is fine.

-- 
Thanks

Robert
