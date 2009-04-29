From: Theodore Tso <tytso@mit.edu>
Subject: Re: Question on block group allocation
Date: Wed, 29 Apr 2009 17:50:32 -0400
Message-ID: <20090429215032.GC24749@mit.edu>
References: <20090423190817.GN3209@webber.adilger.int> <6601abe90904231502y393155dbrf8913b728c704320@mail.gmail.com> <20090427021411.GA9059@mit.edu> <6601abe90904262229w602e17d8s51ceae05c2895ce5@mail.gmail.com> <20090427224052.GC22104@mit.edu> <20090429191646.GF14264@mit.edu> <6601abe90904291138r6e24c04dj4b2efcdba22bf84@mail.gmail.com> <20090429193744.GA17797@mit.edu> <6601abe90904291321u3f13d8b0p88b9a9eba5bc03a1@mail.gmail.com> <20090429212043.GB24749@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@sun.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:41228 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752280AbZD2Vuh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 29 Apr 2009 17:50:37 -0400
Content-Disposition: inline
In-Reply-To: <20090429212043.GB24749@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Oh --- one more question.  You did these tests on your 2.6.26-based
kernel with ext4 backports, right?  Not 2.6.30 mainline kernel?  Did
you backport the changes to the block and inode allocators?  i.e.,
this patch (plus a 1 or 2 subsequent bug fixes)?


commit a4912123b688e057084e6557cef8924f7ae5bbde
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Thu Mar 12 12:18:34 2009 -0400

    ext4: New inode/block allocation algorithms for flex_bg filesystems
    
    The find_group_flex() inode allocator is now only used if the
    filesystem is mounted using the "oldalloc" mount option.  It is
    replaced with the original Orlov allocator that has been updated for
    flex_bg filesystems (it should behave the same way if flex_bg is
    disabled).  The inode allocator now functions by taking into account
    each flex_bg group, instead of each block group, when deciding whether
    or not it's time to allocate a new directory into a fresh flex_bg.
    
    The block allocator has also been changed so that the first block
    group in each flex_bg is preferred for use for storing directory
    blocks.  This keeps directory blocks close together, which is good for
    speeding up e2fsck since large directories are more likely to look
    like this:
    
    debugfs:  stat /home/tytso/Maildir/cur
    Inode: 1844562   Type: directory    Mode:  0700   Flags: 0x81000
    Generation: 1132745781    Version: 0x00000000:0000ad71
    User: 15806   Group: 15806   Size: 1060864
    File ACL: 0    Directory ACL: 0
    Links: 2   Blockcount: 2072
    Fragment:  Address: 0    Number: 0    Size: 0
     ctime: 0x499c0ff4:164961f4 -- Wed Feb 18 08:41:08 2009
     atime: 0x499c0ff4:00000000 -- Wed Feb 18 08:41:08 2009
     mtime: 0x49957f51:00000000 -- Fri Feb 13 09:10:25 2009
    crtime: 0x499c0f57:00d51440 -- Wed Feb 18 08:38:31 2009
    Size of extra inode fields: 28
    BLOCKS:
    (0):7348651, (1-258):7348654-7348911
    TOTAL: 259
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

						- Ted
