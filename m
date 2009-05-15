From: Alex Tomas <bzzz@sun.com>
Subject: Re: More ext4 acl/xattr corruption - 4th occurence now
Date: Fri, 15 May 2009 07:57:14 +0400
Message-ID: <4A0CE81A.1060006@sun.com>
References: <20090513062634.GE4972@kulgan> <20090514044011.GC11352@mit.edu>
 <20090514110659.GA5146@kulgan> <20090514132506.GD5146@kulgan>
 <20090514140732.GI11352@mit.edu> <20090514143014.GH5146@kulgan>
 <20090514161254.GJ11352@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII; format=flowed
Content-Transfer-Encoding: 7BIT
Cc: Kevin Shanahan <kmshanah@ucwb.org.au>,
	Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gmp-eb-inf-2.sun.com ([192.18.6.24]:39764 "EHLO
	gmp-eb-inf-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754384AbZEOEIH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 15 May 2009 00:08:07 -0400
Received: from fe-emea-09.sun.com (gmp-eb-lb-2-fe3.eu.sun.com [192.18.6.12])
	by gmp-eb-inf-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n4F3vlp4002124
	for <linux-ext4@vger.kernel.org>; Fri, 15 May 2009 03:58:02 GMT
Received: from conversion-daemon.fe-emea-09.sun.com by fe-emea-09.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.02 64bit (built Apr 16 2009))
 id <0KJO00L002PBAZ00@fe-emea-09.sun.com> for linux-ext4@vger.kernel.org; Fri,
 15 May 2009 04:57:47 +0100 (BST)
In-reply-to: <20090514161254.GJ11352@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

when cache was introduced single exclusive spinlock protect
whole ext3_ext_get_blocks and there was no concurrency at all.
so I guess your theory is correct.

thanks, Alex

Theodore Tso wrote:
> On Fri, May 15, 2009 at 12:00:15AM +0930, Kevin Shanahan wrote:
>>> debugfs: stat <759>
>> hermes:~# debugfs /dev/dm-0
>> debugfs 1.41.3 (12-Oct-2008)
>> debugfs:  stat <759>
>>
>> Inode: 759   Type: regular    Mode:  0660   Flags: 0x80000
>> Generation: 3979120103    Version: 0x00000000:00000001
>> User:     0   Group: 10140   Size: 14615630848
>> File ACL: 0    Directory ACL: 0
>> Links: 1   Blockcount: 28546168
>> Fragment:  Address: 0    Number: 0    Size: 0
>>  ctime: 0x4a0acdb5:2a88cbec -- Wed May 13 23:10:05 2009
>>  atime: 0x4a0ac45b:10899618 -- Wed May 13 22:30:11 2009
>>  mtime: 0x4a0acdb5:2a88cbec -- Wed May 13 23:10:05 2009
>> crtime: 0x4a0ac45b:10899618 -- Wed May 13 22:30:11 2009
> 
>> Inode   Pathname
>> 759     /local/dumps/exchange/exchange-2000-UCWB-KVM-18.bkfB-KVM-18.bkf
> 
> Do you know how the system was likely writing into
> /local/dumps/exhcnag/eexchange-2000-UCWB-KVM-18.bkf?  What this a
> backup via rsync or tar?  Was this some application writing into a
> pre-existing file via NFS, or via local disk access?
> 
> Given the ctime/atime fields, I'm inclined to guess the latter, but it
> would be good to know.
> 
> The stat dump for the inode 759 does *not* show logical block 1741329
> getting mapped to physical block 529.  So the question is how did that
> happen?
> 
> I've started looking, and one thing popped up at me.  I need to check
> in with the Lustre folks who originally donated the code, but I don't
> see any spinlock or mutexes protecting the inode's extent cache.  So
> if you are on an SMP machine, this could potentially have caused the
> problem.  How many CPU's or cores do you have?  What does
> /proc/cpuinfo report?  Also, would it be correct to assume this file
> is getting served up via Samba.  My theory is that we might be running
> into problems when two threads are simultaneously trying read and
> write to a single file at the same time.
> 
> Hmm, what is accessing your files on this system?  Are you just doing
> backups?  Is it just a backup server?  Or are you serving up files
> using Samba and there are clients which are accessing those files?
> 
> So if this the problem the following experiment should be able to
> confirm whether it's the problem, by seeing if the problem goes away
> if we short-circuit the inode's extent cache.  In fs/ext4/extents.c,
> try inserting a "return" statement to in ext4_ext_put_in_cache():
> 
> static void
> ext4_ext_put_in_cache(struct inode *inode, ext4_lblk_t block,
> 			__u32 len, ext4_fsblk_t start, int type)
> {
> 	struct ext4_ext_cache *cex;
> 
> 	return;		      <---- insert this line
> 	BUG_ON(len == 0);
> 	cex = &EXT4_I(inode)->i_cached_extent;
> 	cex->ec_type = type;
> 	cex->ec_block = block;
> 	cex->ec_len = len;
> 	cex->ec_start = start;
> }
> 
> This should short circuit the i_cached_extent cache, and this may be
> enough to make your problem go away.  (If this theory is correct,
> using mount -o nodelalloc probably won't make a difference, although
> it might change the timing enough to make the bug harder to see.)
> 
> If that solves the problem, the right long-term fix will be to drop bin
> a spinlock to protect i_cached_extent.
> 
> 						- Ted

