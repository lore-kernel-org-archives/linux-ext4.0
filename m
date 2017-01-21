From: "George Spelvin" <linux@sciencehorizons.net>
Subject: Re: ext4_iget:4740: inode #%ld: block 48: comm find: invalid block
Date: 21 Jan 2017 11:45:12 -0500
Message-ID: <20170121164512.11458.qmail@ns.sciencehorizons.net>
References: <20170121133049.bsrp55gi4x5x5wcv@thunk.org>
Cc: jack@suse.cz, linux-ext4@vger.kernel.org
To: linux@sciencehorizons.net, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ns.sciencehorizons.net ([71.41.210.147]:27757 "HELO
        ns.sciencehorizons.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1750770AbdAUQpO (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 21 Jan 2017 11:45:14 -0500
In-Reply-To: <20170121133049.bsrp55gi4x5x5wcv@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ted Ts'o wrote:
On Fri, Jan 20, 2017 at 12:57:23PM -0500, George Spelvin wrote:
>> So I'm guessing the problem is that the required empty system.data
>> attribute is missing (due to the preceding extra_isize changing mess),
>> and if I just created it, everything would magically come back to life
>> 
>> Something like ea_set <inode> system.data ""

> Well, it would still a corrupted, innconsistent inode, in that there
> would still be a block attached to the inode, and i_size would be
> different from the size of the data xattr used by inline_data.  So you
> might as well just clri the inode and rerun fsck, or clri the inode
> and then unlink the directory entry in lost+found.

Er, huh?  I was referring to the following error, which is one of a
dozen inodes I have with this problem (sorry all the Subject: lines have
gotten tangled):

>> Subject: ext4_iget:4740: inode #%ld: block 48: comm find: invalid block
>>
>> debugfs:  stat <1171779>
>> Inode: 1171779   Type: directory    Mode:  0775   Flags: 0x10000000
>> Generation: 2016668288    Version: 0x00000000:00000007
>> User:  1000   Group:   161   Project:     0   Size: 60
>> File ACL: 0    Directory ACL: 0
>> Links: 2   Blockcount: 0
>> Fragment:  Address: 0    Number: 0    Size: 0
>>  ctime: 0x587eff35:6e19953c -- Wed Jan 18 00:37:57 2017
>>  atime: 0x56d5943f:bb6e1344 -- Tue Mar  1 08:08:15 2016
>>  mtime: 0x587eff35:6e19953c -- Wed Jan 18 00:37:57 2017
>> crtime: 0x56d388b6:533e9e7c -- Sun Feb 28 18:54:30 2016
>> Size of extra inode fields: 32
>> Inode checksum: 0x82a01dca
>> Size of inline data: 60
>> 
>> debugfs:  ls <1171779>
>>  1171779  (12) .    1171778  (12) ..    1171954  (12) 0    1171955  (12) 1   
>>  1171956  (12) 2    1171957  (20) 3   

Zero blocks, data apparently safe and sound in the i_blocks field, just
missing (due to getting trashed by buggy i_extra_size changing code)
the system.data ea, and thus i_inline_off == 0 which upsets the kernel.

> You might get it to a state where the kernel isn't explicitly
> complaining any more, but you might end up unmasking other bugs where
> the kernel is further failing to handle an inconsistent inode relating
> to inline_data.

I just want to get it to a state where I can mv the contents into a
replacement directly and then rmdir this one, rather than having to
make a note of the name & inode number of each of the contained files
and then recreate it from the contents of lost+found (which is already
a bit of a swamp I'm wading through).
