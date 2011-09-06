From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 10/37] mke2fs: Allow metadata checksums to be turned on at mkfs time
Date: Mon, 5 Sep 2011 19:54:32 -0600
Message-ID: <47443446-99CA-43EE-89EC-7A5B6A9F8A0E@dilger.ca>
References: <20110901003509.1176.51159.stgit@elm3c44.beaverton.ibm.com> <20110901003615.1176.76957.stgit@elm3c44.beaverton.ibm.com> <4764BABB-0FFB-4AE5-B6A3-EF804AA59FC8@dilger.ca> <20110905192027.GU12086@tux1.beaverton.ibm.com>
Mime-Version: 1.0 (iPhone Mail 8L1)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Andreas Dilger <adilger@dilger.ca>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Theodore Tso <tytso@mit.edu>,
	Sunil Mushran <sunil.mushran@oracle.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Coly Li <colyli@gmail.com>
To: "djwong@us.ibm.com" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from shawmail.shawcable.com ([64.59.128.220]:3065 "EHLO
	mail.shawcable.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031Ab1IFBxv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 5 Sep 2011 21:53:51 -0400
In-Reply-To: <20110905192027.GU12086@tux1.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-09-05, at 1:20 PM, "Darrick J. Wong" <djwong@us.ibm.com> wrote:
> On Sun, Sep 04, 2011 at 12:28:24PM -0600, Andreas Dilger wrote:
>> On 2011-08-31, at 6:36 PM, "Darrick J. Wong" <djwong@us.ibm.com> wrote:
>>> Write out checksummed inodes even when writing out a zeroed table.
>>> 
>>> +        if (fs->super->s_creator_os == EXT2_OS_LINUX &&
>>> +            fs->super->s_feature_ro_compat &
>>> +            EXT4_FEATURE_RO_COMPAT_METADATA_CSUM) {
>> 
>> Somehow it doesn't look like this is skipping the zeroing of the inode table
>> blocks if lazy itable zeroing is set. 
>> 
>> Any measurements on how much this slows down inode table writing (which is
>> already the slowest part of mke2fs)?
> 
> Quite a lot, actually.  Trouble is, if you're going to write zeroes to the
> inode table (without using uninit) then I think you need the checksums to
> match.  Maybe the solution is to modify the kernel/e2fsck to ignore the
> checksum if the inode bitmap says the inode isn't in use?

The kernel is already aware of which inodes are not in use if the uninit_bg feature is enabled. Even without uninit_bg, the kernel will not read itable blocks from disk if none of the inodes in that block are used. 

Also, if the lazy_itable_init is passed to mke2fs it isn't supposed to initialize the inode table at all, and the kernel should do it instead. 

> A better solution is to zero the buffer, stuff in all the checksums in the
> correct places, and then write the block out.

Rather, the kernel should do it in the background. 

>>> +            bzero(&inode, sizeof(inode));
>>> +            for (ino = fs->super->s_inodes_per_group * i;
>>> +                 ino < fs->super->s_inodes_per_group * (i + 1);
>>> +                 ino++) {
>> 
>> Why recompute "ino" each time through this loop?  It should be enough to
>> simply initialize it at 1 and then increment it for each inode written. 
> 
> Agreed.
> 
> --D
>>> +                if (!ino)
>>> +                    continue;
>>> +                retval = ext2fs_write_inode(fs, ino, &inode);
>>> +                if (retval) {
>>> +                    com_err("inode_init", retval,
>>> +                        "while writing inode %d\n",
>>> +                        ino);
>>> +                    exit(1);
>>> +                }
>>> +            }
>>> +        } else {
>>> +            retval = ext2fs_zero_blocks2(fs, blk, num, &blk, &num);
>>> +            if (retval) {
>>> +                fprintf(stderr, _("\nCould not write %d "
>>> +                    "blocks in inode table starting "
>>> +                    "at %llu: %s\n"),
>>> +                    num, blk, error_message(retval));
>>> +                exit(1);
>>> +            }
>>>       }
>>>       if (sync_kludge) {
>>>           if (sync_kludge == 1)
>>> @@ -829,7 +851,8 @@ static __u32 ok_features[3] = {
>>>       EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE|
>>>       EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER|
>>>       EXT4_FEATURE_RO_COMPAT_GDT_CSUM|
>>> -        EXT4_FEATURE_RO_COMPAT_BIGALLOC
>>> +        EXT4_FEATURE_RO_COMPAT_BIGALLOC|
>>> +        EXT4_FEATURE_RO_COMPAT_METADATA_CSUM
>>> };
>>> 
>>> 
>>> 
