From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: random ext3 image bugs
Date: Tue, 10 Jul 2007 13:43:51 +0200
Message-ID: <469370F7.5000809@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from hu-out-0506.google.com ([72.14.214.228]:20803 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754519AbXGJLo3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Jul 2007 07:44:29 -0400
Received: by hu-out-0506.google.com with SMTP id 19so719479hue
        for <linux-ext4@vger.kernel.org>; Tue, 10 Jul 2007 04:44:27 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi all,

My insane file system test triggered a few bugs in ext3 image. Anyone interested?

[40859.103232] SELinux: initialized (dev loop7, type ext3), uses xattr
[40859.119575] EXT3-fs error (device loop7): ext3_xattr_block_get: inode 757: bad block 4829
[40859.129837] inode_doinit_with_dentry:  getxattr returned 5 for dev=loop7 ino=757
[40859.139840] EXT3-fs error (device loop7): ext3_xattr_block_get: inode 8381: bad block 4829
[40859.149436] inode_doinit_with_dentry:  getxattr returned 5 for dev=loop7 ino=8381
[40859.164064] EXT3-fs error (device loop7): ext3_xattr_block_get: inode 4314: bad block 4829
[40859.172919] inode_doinit_with_dentry:  getxattr returned 5 for dev=loop7 ino=4314
[40859.183789] EXT3-fs error (device loop7): ext3_xattr_block_get: inode 760: bad block 4829
[40859.192601] inode_doinit_with_dentry:  getxattr returned 5 for dev=loop7 ino=760
[40859.209274] EXT3-fs error (device loop7): ext3_xattr_block_get: inode 6390: bad block 4829
[40859.218258] inode_doinit_with_dentry:  getxattr returned 5 for dev=loop7 ino=6390
[40859.256550] EXT3-fs error (device loop7): ext3_xattr_block_get: inode 14610: bad block 4829
[40859.266803] inode_doinit_with_dentry:  getxattr returned 5 for dev=loop7 ino=14610
[40859.284814] EXT3-fs error (device loop7): ext3_xattr_block_get: inode 764: bad block 4829
[40859.293644] inode_doinit_with_dentry:  getxattr returned 5 for dev=loop7 ino=764
[..]

[40861.091690] EXT3-fs error (device loop2): ext3_readdir: bad entry in directory #11: rec_len % 4 != 0 - offset=0, inode=3925999616, rec_len=1023, name_len=0
[40862.667815] EXT3-fs error (device loop2): ext3_readdir: bad entry in directory #11: rec_len % 4 != 0 - offset=0, inode=3925999616, rec_len=1023, name_len=0

[..]

25999616, rec_len=1023, name_len=0
[40870.459390] EXT3-fs error (device loop2): htree_dirblock_to_tree: bad entry in directory #6301: rec_len is smaller than minimal - offset=0, inode=0, rec_len=0, name_len=0
[40870.478123] EXT3-fs error (device loop2): htree_dirblock_to_tree: bad entry in directory #4168: rec_len is smaller than minimal - offset=0, inode=0, rec_len=0, name_len=0
[40870.514409] EXT3-fs error (device loop2): htree_dirblock_to_tree: bad entry in directory #10426: rec_len is smaller than minimal - offset=0, inode=0, rec_len=0, name_len=0
[40870.557496] EXT3-fs error (device loop2): htree_dirblock_to_tree: bad entry in directory #12477: rec_len is smaller than minimal - offset=0, inode=0, rec_len=0, name_len=0
[40870.575138] EXT3-fs error (device loop2): htree_dirblock_to_tree: bad entry in directory #12471: rec_len is smaller than minimal - offset=0, inode=0, rec_len=0, name_len=0
[40870.607312] EXT3-fs error (device loop2): htree_dirblock_to_tree: bad entry in directory #6301: rec_len is smaller than minimal - offset=0, inode=0, rec_len=0, name_len=0
[40870.624644] EXT3-fs error (device loop2): htree_dirblock_to_tree: bad entry in directory #4168: rec_len is smaller than minimal - offset=0, inode=0, rec_len=0, name_len=0
[40870.664405] EXT3-fs error (device loop2): htree_dirblock_to_tree: bad entry in directory #6301: rec_len is smaller than minimal - offset=0, inode=0, rec_len=0, name_len=0
[40870.681864] EXT3-fs error (device loop2): htree_dirblock_to_tree: bad entry in directory #4168: rec_len is smaller than minimal - offset=0, inode=0, rec_len=0, name_len=0
[40870.707222] EXT3-fs error (device loop2): htree_dirblock_to_tree: bad entry in directory #10431: rec_len is smaller than minimal - offset=0, inode=0, rec_len=0, name_len=0
[40870.736133] EXT3-fs error (device loop2): htree_dirblock_to_tree: bad entry in directory #6225: rec_len is smaller than minimal - offset=0, inode=0, rec_len=0, name_len=0
[40870.754564] EXT3-fs error (device loop2): htree_dirblock_to_tree: bad entry in directory #12466: rec_len is smaller than minimal - offset=0, inode=0, rec_len=0, name_len=0
[40870.775175] EXT3-fs error (device loop2): htree_dirblock_to_tree: bad entry in directory #6266: rec_len is smaller than minimal - offset=0, inode=0, rec_len=0, name_len=0
[40870.800203] EXT3-fs error (device loop2): htree_dirblock_to_tree: bad entry in directory #6301: rec_len is smaller than minimal - offset=0, inode=0, rec_len=0, name_len=0
[40870.818098] EXT3-fs error (device loop2): htree_dirblock_to_tree: bad entry in directory #4168: rec_len is smaller than minimal - offset=0, inode=0, rec_len=0, name_len=0
[40870.838409] EXT3-fs error (device loop2): htree_dirblock_to_tree: bad entry in directory #14524: rec_len is smaller than minimal - offset=0, inode=0, rec_len=0, name_len=0
[40870.860820] EXT3-fs error (device loop2): htree_dirblock_to_tree: bad entry in directory #6301: rec_len is smaller than minimal - offset=0, inode=0, rec_len=0, name_len=0
[40870.879037] EXT3-fs error (device loop2): htree_dirblock_to_tree: bad entry in directory #4168: rec_len is smaller than minimal - offset=0, inode=0, rec_len=0, name_len=0
[40870.899012] EXT3-fs error (device loop2): htree_dirblock_to_tree: bad entry in directory #12483: rec_len is smaller than minimal - offset=0, inode=0, rec_len=0, name_len=0
[40870.918856] EXT3-fs error (device loop2): htree_dirblock_to_tree: bad entry in directory #2205: rec_len is smaller than minimal - offset=0, inode=0, rec_len=0, name_len=0
[40881.007567] EXT3-fs error (device loop2): ext3_readdir: bad entry in directory #11: rec_len % 4 != 0 - offset=0, inode=3925999616, rec_len=1023, name_len=0
[40881.079469] EXT3-fs error (device loop2): htree_dirblock_to_tree: bad entry in directory #10426: rec_len is smaller than minimal - offset=0, inode=0, rec_len=0, name_len=0
[40881.133465] EXT3-fs error (device loop2): htree_dirblock_to_tree: bad entry in directory #12477: rec_len is smaller than minimal - offset=0, inode=0, rec_len=0, name_len=0
[40881.168670] EXT3-fs error (device loop2): htree_dirblock_to_tree: bad entry in directory #6301: rec_len is smaller than minimal - offset=0, inode=0, rec_len=0, name_len=0
[40881.209803] EXT3-fs error (device loop2): htree_dirblock_to_tree: bad entry in directory #4168: rec_len is smaller than minimal - offset=0, inode=0, rec_len=0, name_len=0

http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/ext3/ext3.img.bz2

fs test (not finished yet - a few ideas from racer and fsfuzzer) http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/ext3/nokturn.tar.bz2

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
