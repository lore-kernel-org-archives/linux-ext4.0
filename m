From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v4 4/4] ext4: Add 64-bit inode number support
Date: Sat, 17 Feb 2018 21:18:13 -0500
Message-ID: <20180218021812.GA20751@thunk.org>
References: <20180202094136.13032-1-artem.blagodarenko@gmail.com>
 <20180202094136.13032-5-artem.blagodarenko@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca
To: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:54912 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751258AbeBRCSR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 17 Feb 2018 21:18:17 -0500
Content-Disposition: inline
In-Reply-To: <20180202094136.13032-5-artem.blagodarenko@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Artem,

I was debugging another problem and it caused me to ask myself, "Huh.
I wonder how the 64-bit inode number support deals with the orphaned
inode list ---- since we use the dtime field in the inode as part of a
linked list with the 32-bit s_orphan_inum has the head of that linked list."

So I took a quick look at your patch, and noted that in the v3 version
Andreas had asked you what about adding support for the 32-bito
s_last_orphan field, so you have added support for s_last_orphan_hi.
But it doesn't appear that you are *using* that field for anything.
Also, although you have made ino_next in ext4_orphan_add() a 64-bit
field, it doesn't appear that you changed how the linked list of the
orphaned inode list is stored.

BTW, I also don't see any places where s_first_error_ino_hi and
s_last_error_ino_hi are used.

This brings up a question --- how much testing have you done with your
patch, and how are you testing it?  It's pretty clear that if you had
tried a test where inodes with bits set in the 32-bits of the inode
number, codepaths which depend on the orphan inode handling would have
blown up.  You might want to consider a debugging mode where the inode
allocator preferentially tries to use inode numbers that start at
(2**32) + 1 and then try running xfstests on it.

Another debugging mode that would be useful is one which doesn't
require really big file systems, so it can be used by kvm-xfstest and
gce-xfstest.  You might do this forces the high 32-bits of the inode
to be (17 << 32), and changes ext4_get_inode_loc() so that it returns
an error if the high bits are not (17 << 32).  (Similar adjustments
would be needed for access to the inode allocation bitmap.)

Cheers,

						- Ted
