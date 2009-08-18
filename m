From: "Theodore Ts'o" <tytso@mit.edu>
Subject: Rare xfsqa test failure
Date: Tue, 18 Aug 2009 07:57:42 -0400
Message-ID: <E1MdNJu-0006uc-GX@closure.thunk.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:52337 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751385AbZHRL5p (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 18 Aug 2009 07:57:45 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


As a heads up, I'm seeing a rare xfsqa test failure with the stable
portion of the ext4 patch queue; it doesn't hit all the time, but when
it does, i_size is corrupted:

Inode 22047, i_size is 922788, should be 942080.  Fix?

922788/4096 is 225 plus a fraction, while 942080/4096 is 230.  The
debugfs information is as follows:

debugfs:  stat <22047>
Inode: 22047   Type: regular    Mode:  0666   Flags: 0x80000
Generation: 3536075281    Version: 0x00000000:00000001
User:     0   Group:     0   Size: 922788
File ACL: 0    Directory ACL: 0
Links: 1   Blockcount: 1320
Fragment:  Address: 0    Number: 0    Size: 0
 ctime: 0x4a8a953b:546bc3d4 -- Tue Aug 18 07:49:15 2009
 atime: 0x4a8a953b:29927210 -- Tue Aug 18 07:49:15 2009
 mtime: 0x4a8a953b:546bc3d4 -- Tue Aug 18 07:49:15 2009
crtime: 0x4a8a951c:5ac789dc -- Tue Aug 18 07:48:44 2009
Size of extra inode fields: 28
EXTENTS:
(65-80): 60720-60735, (81-222 [uninit]): 1181574-1181715, (223-229): 1181716-118
1722
debugfs:  

So it looks like there's a race which can cause ext4 to somehow miss an
i_size update.

						- Ted

