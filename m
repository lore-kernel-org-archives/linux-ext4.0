From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: ext4_ext_check_inode: bad header/extent in inode
Date: Fri, 24 Apr 2009 15:34:12 -0500
Message-ID: <49F22244.5040407@redhat.com>
References: <alpine.DEB.2.01.0904191934320.6162@bogon.housecafe.de> <49F0642A.4000704@redhat.com> <alpine.DEB.2.01.0904231156460.6162@bogon.housecafe.de> <20090423204059.GM2723@mit.edu> <alpine.DEB.2.01.0904231442350.6162@bogon.housecafe.de> <20090424032028.GB7949@mit.edu> <alpine.DEB.2.01.0904240153310.6162@bogon.housecafe.de> <alpine.DEB.2.01.0904240235020.6162@bogon.housecafe.de> <20090424120004.GD7949@mit.edu> <49F1B24B.7080308@redhat.com> <alpine.DEB.2.01.0904241318460.6162@bogon.housecafe.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Christian Kujau <lists@nerdbynature.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:37107 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212AbZDXUeV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 24 Apr 2009 16:34:21 -0400
In-Reply-To: <alpine.DEB.2.01.0904241318460.6162@bogon.housecafe.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Christian Kujau wrote:
> On Fri, 24 Apr 2009, Eric Sandeen wrote:
>> Christian, is there anything in dmesg along with it this time?
> 
> Yes, as soon as the input/output errors occur, I get:
> 
> [34989.160273] EXT4-fs error (device md0): ext4_ext_check_inode: bad header/extent in inode #12042: invalid magic - magic 800, entries 8192, max 5696(0), depth 6144(6144)
> [34989.162491] EXT4-fs error (device md0): ext4_ext_check_inode: bad header/extent in inode #12207: invalid magic - magic 42fc, entries 17104, max 62268(0), depth 1283(1283)
> [34989.166784] EXT4-fs error (device md0): ext4_ext_check_inode: bad header/extent in inode #12249: invalid magic - magic 42fc, entries 17104, max 62268(0), depth 1283(1283)

Oh, duh, of course.  Now that I'm thinking about it right ...

So these are funny inodes:

# file mnt/lost+found/*
mnt/lost+found/#12042: setuid setgid character special
mnt/lost+found/#12207: setgid socket
mnt/lost+found/#12249: setgid socket

by virtue of the corruption.

They don't actually have any blocks,

debugfs:  stat <12042>
Inode: 12042   Type: character special    Mode:  0012   Flags: 0xe0406
Generation: 1123828476    Version: 0x21204098
User: -62782456   Group: -62766025   Size: 0
File ACL: 0    Directory ACL: 0
Links: 1   Blockcount: 0
Fragment:  Address: 0    Number: 0    Size: 0
ctime: 0x00063400 -- Mon Jan  5 10:55:28 1970
atime: 0x01380030 -- Tue Aug 25 10:48:00 1970
mtime: 0x00103001 -- Tue Jan 13 00:41:05 1970
Size of extra inode fields: 4
Device major/minor number: 08:00 (hex 08:00)

so we shouldn't be checking the extent header, I think.

        if (ei->i_flags & EXT4_EXTENTS_FL) {
                /* Validate extent which is part of inode */
                ret = ext4_ext_check_inode(inode);
        } else if ...

Or maybe fsck should be clearing the extents flag on inodes like this?

-Eric
