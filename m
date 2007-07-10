From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: random ext3 image bugs
Date: Tue, 10 Jul 2007 10:44:02 -0500
Message-ID: <4693A942.9000900@redhat.com>
References: <469370F7.5000809@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:55890 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754516AbXGJPrx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Jul 2007 11:47:53 -0400
In-Reply-To: <469370F7.5000809@googlemail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Michal Piotrowski wrote:
> Hi all,
> 
> My insane file system test triggered a few bugs in ext3 image. Anyone interested?

Not yet; all the errors below are ext3 properly coping with the
corrupted image, no?  But if you can make it oops, that's more
interesting.  :)

-Eric

> [40859.103232] SELinux: initialized (dev loop7, type ext3), uses xattr
> [40859.119575] EXT3-fs error (device loop7): ext3_xattr_block_get: inode 757: bad block 4829
> [40859.129837] inode_doinit_with_dentry:  getxattr returned 5 for dev=loop7 ino=757
> [40859.139840] EXT3-fs error (device loop7): ext3_xattr_block_get: inode 8381: bad block 4829
> [40859.149436] inode_doinit_with_dentry:  getxattr returned 5 for dev=loop7 ino=8381
> [40859.164064] EXT3-fs error (device loop7): ext3_xattr_block_get: inode 4314: bad block 4829
> [40859.172919] inode_doinit_with_dentry:  getxattr returned 5 for dev=loop7 ino=4314
> [40859.183789] EXT3-fs error (device loop7): ext3_xattr_block_get: inode 760: bad block 4829
> [40859.192601] inode_doinit_with_dentry:  getxattr returned 5 for dev=loop7 ino=760
> [40859.209274] EXT3-fs error (device loop7): ext3_xattr_block_get: inode 6390: bad block 4829
> [40859.218258] inode_doinit_with_dentry:  getxattr returned 5 for dev=loop7 ino=6390
> [40859.256550] EXT3-fs error (device loop7): ext3_xattr_block_get: inode 14610: bad block 4829
> [40859.266803] inode_doinit_with_dentry:  getxattr returned 5 for dev=loop7 ino=14610
> [40859.284814] EXT3-fs error (device loop7): ext3_xattr_block_get: inode 764: bad block 4829
> [40859.293644] inode_doinit_with_dentry:  getxattr returned 5 for dev=loop7 ino=764
> [..]
