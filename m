From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 3/4] e2fsprogs: Fix write size in ext2fs_mmp_write
Date: Thu, 10 Nov 2011 17:00:12 -0600
Message-ID: <4EBC577C.9010607@redhat.com>
References: <4EBC5524.3000105@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4966 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753251Ab1KJXAO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 Nov 2011 18:00:14 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pAAN0Equ021613
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Thu, 10 Nov 2011 18:00:14 -0500
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id pAAN0CRj012017
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 10 Nov 2011 18:00:13 -0500
In-Reply-To: <4EBC5524.3000105@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Without this change, we will write data past the end of the
mmp buf.  Valgrind catches this:

==6373== Syscall param write(buf) points to unaddressable byte(s)
==6373==    at 0x362260E470: __write_nocancel (in /lib64/libpthread-2.12.2.so)
==6373==    by 0x41CF83: raw_write_blk (unix_io.c:255)
==6373==    by 0x41D2BC: unix_write_blk64 (unix_io.c:757)
==6373==    by 0x41A05D: ext2fs_mmp_write (mmp.c:130)
==6373==    by 0x40B0C9: do_set_mmp_value (set_fields.c:806)
==6373==    by 0x421B61: really_execute_command (execute_cmd.c:108)
==6373==    by 0x421C54: ss_execute_line (execute_cmd.c:234)
==6373==    by 0x403743: main (debugfs.c:2339)
==6373==  Address 0x63f000 is not stack'd, malloc'd or (recently) free'd

and in my testing it led to silent failures while writing the mmp
block in debugfs:

write(3, "xV4\22PMM\342\325V\274N\0\0\0\0host.name."..., 4096) = -1 EFAULT (Bad address)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

p.s. I could do with a comment about what a negative "count" means...?

diff --git a/lib/ext2fs/mmp.c b/lib/ext2fs/mmp.c
index 91f4fb2..b27d9a4 100644
--- a/lib/ext2fs/mmp.c
+++ b/lib/ext2fs/mmp.c
@@ -127,7 +127,7 @@ errcode_t ext2fs_mmp_write(ext2_filsys fs, blk64_t mmp_blk, void *buf)
 
 	/* I was tempted to make this use O_DIRECT and the mmp_fd, but
 	 * this caused no end of grief, while leaving it as-is works. */
-	retval = io_channel_write_blk64(fs->io, mmp_blk, -fs->blocksize, buf);
+	retval = io_channel_write_blk64(fs->io, mmp_blk, -(int)sizeof(struct mmp_struct), buf);
 
 #ifdef WORDS_BIGENDIAN
 	ext2fs_swap_mmp(mmp_s);


