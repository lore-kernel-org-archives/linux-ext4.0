From: Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH]: ext4: fix big endian  (was: not enough memory for 522250 flex groups)
Date: Thu, 6 Nov 2008 16:51:49 +0100
Message-ID: <200811061651.49602.borntraeger@de.ibm.com>
References: <200811061600.54264.borntraeger@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:38457 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134AbYKFPyA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Nov 2008 10:54:00 -0500
In-Reply-To: <200811061600.54264.borntraeger@de.ibm.com>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ok, I think I found it:

On big endianess plattforms newly created ext4 file systems cannot be mounted
and show messages like:
[6923911.715968] EXT4-fs: not enough memory for 522250 flex groups
[6923911.715973] EXT4-fs: unable to initialize flex_bg meta info!

We have to access s_reserved_gdb_blocks with le16_to_cpu.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 fs/ext4/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: kvm/fs/ext4/super.c
===================================================================
--- kvm.orig/fs/ext4/super.c
+++ kvm/fs/ext4/super.c
@@ -1455,7 +1455,7 @@ static int ext4_fill_flex_info(struct su
 
 	/* We allocate both existing and potentially added groups */
 	flex_group_count = ((sbi->s_groups_count + groups_per_flex - 1) +
-			    ((sbi->s_es->s_reserved_gdt_blocks +1 ) <<
+			    (le16_to_cpu(sbi->s_es->s_reserved_gdt_blocks + 1) <<
 			      EXT4_DESC_PER_BLOCK_BITS(sb))) /
 			   groups_per_flex;
 	sbi->s_flex_groups = kzalloc(flex_group_count *
