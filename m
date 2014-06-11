From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: [PATCH 1/3] mke2fs: set upper limit to flex_bg count
Date: Wed, 11 Jun 2014 08:37:22 +0000
Message-ID: <28989C0C9F1C0A428470D967B5FCED372A7E6D@BPXM22GP.gisp.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO200.gate.nec.co.jp ([210.143.35.50]:44697 "EHLO
	tyo200.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219AbaFKJCs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 11 Jun 2014 05:02:48 -0400
Received: from tyo201.gate.nec.co.jp ([10.7.69.201])
	by tyo200.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id s5B8fw3r015954
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 11 Jun 2014 17:41:59 +0900 (JST)
Content-Language: ja-JP
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

mke2fs -G option allows root user to set flex_bg count (power of 2).
However ext4 has bad metadata layout if we specify more than or equal to
2^32 to mke2fs -G, because of the 32bit shift operation
in ext2fs_allocate_group_table().
And the maximum block group count of ext4 is 2^32 -1 (ext4_group_t s_groups_count), 
so diallow more than 2^32 flex_bg count.

Steps to reproduce:

# mke2fs -t ext4 -G 4294967296 DEV

# dumpe2fs DEV
<snip>
Flex block group size:    1          <----- flex_bg is 1!
<snip>
Group 0: (Blocks 0-32767)
  Checksum 0x4afd, unused inodes 7541
  Primary superblock at 0, Group descriptors at 1-1
  Reserved GDT blocks at 2-59
  Block bitmap at 60 (+60), Inode bitmap at 61 (+61)
  Inode table at 62-533 (+62)
  32228 free blocks, 7541 free inodes, 2 directories, 7541 unused inodes
  Free blocks: 540-32767
  Free inodes: 12-7552
Group 1: (Blocks 32768-65535) [INODE_UNINIT]
  Checksum 0xc890, unused inodes 7552
  Backup superblock at 32768, Group descriptors at 32769-32769
  Reserved GDT blocks at 32770-32827
  Block bitmap at 32828 (+60), Inode bitmap at 32829 (+61)
  Inode table at 32830-33301 (+62)
  32234 free blocks, 7552 free inodes, 0 directories, 7552 unused inodes
  Free blocks: 33302-65535
  Free inodes: 7553-15104
<snip>

Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
---
misc/mke2fs.c |    6 ++++++
 1 file changed, 6 insertions(+)
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index b451cc3..b9145d1 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -1605,6 +1605,12 @@ profile_error:
 					_("flex_bg size must be a power of 2"));
 				exit(1);
 			}
+			if (flex_bg_size > MAX_32_NUM) {
+				com_err(program_name, 0,
+				_("flex_bg size (%lu) must be less than"
+				" or equal to 2^31"), flex_bg_size);
+				exit(1);
+			}
 			break;
 		case 'i':
 			inode_ratio = strtoul(optarg, &tmp, 0);

