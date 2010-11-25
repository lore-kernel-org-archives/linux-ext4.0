From: Andreas Dilger <adilger.kernel@dilger.ca>
Subject: [PATCH] fix debugfs output for flex_bg bitmap offsets
Date: Thu, 25 Nov 2010 02:57:34 -0700
Message-ID: <BFE21949-F817-40EF-8A9C-8B30E0530D4A@dilger.ca>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:55228 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645Ab0KYJ5f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Nov 2010 04:57:35 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When running debugfs on a filesystem formatted with flex_bg, it prints out the relative offsets for the bitmaps and inode table badly on 64-bit systems, because the offset is computed as a large positive number instead of being a negative numer (which will not be printed at all):

Group 1: (Blocks 0x8000-0xffff) [INODE_UNINIT, ITABLE_ZEROED]
 Block bitmap at 0x0102 (+4294934786), Inode bitmap at 0x0202 (+4294935042)
 Inode table at 0x037e-0x03fa (+4294935422)

The attached patch prints out the relative offsets for flex_bg groups as the offset within the reported group.  This makes it more clear where the metadata is located, rather than simply printing some large negative number.

Group 1: (Blocks 0x8000-0xffff) [INODE_UNINIT, ITABLE_ZEROED]
 Block bitmap at 0x0102 (group 0 +258), Inode bitmap at 0x0202 (group 0 +514)
 Inode table at 0x037e-0x03fa (group 0 +894)

Signed-off-by: Andreas Dilger <adilger@dilger.ca>
--


Cheers, Andreas




