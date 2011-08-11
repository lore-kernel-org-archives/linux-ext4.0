From: Andreas Dilger <aedilger@gmail.com>
Subject: Re: [PATCH] ext4: Always verify extent tree blocks
Date: Thu, 11 Aug 2011 16:30:15 -0600
Message-ID: <831137FE-3D60-44B0-9A89-2678C70C08FF@gmail.com>
References: <20110811211348.GK20655@tux1.beaverton.ibm.com> <68C5518D-9B6A-4C63-A044-0248736708FB@dilger.ca> <20110811221428.GM20655@tux1.beaverton.ibm.com>
Mime-Version: 1.0 (iPhone Mail 8L1)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Andreas Dilger <adilger@dilger.ca>, Theodore Ts'o <tytso@mit.edu>,
	linux-ext4 List <linux-ext4@vger.kernel.org>
To: "djwong@us.ibm.com" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:56105 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753536Ab1HKW3q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Aug 2011 18:29:46 -0400
Received: by qyk38 with SMTP id 38so30152qyk.19
        for <linux-ext4@vger.kernel.org>; Thu, 11 Aug 2011 15:29:46 -0700 (PDT)
In-Reply-To: <20110811221428.GM20655@tux1.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-08-11, at 4:14 PM, "Darrick J. Wong" <djwong@us.ibm.com> wrote:
> On Thu, Aug 11, 2011 at 03:33:38PM -0600, Andreas Dilger wrote:
>> On 2011-08-11, at 3:13 PM, Darrick J. Wong wrote:
>>> It turns out that ext4_ext_check only verifies the validity of the extent block
>>> it's processing if the block has to be read in from the disk.  Unfortunately,
>>> this means that the check is NOT done if the block is already in memory, which
>>> means that if a file has a corrupted extent block, then the first IO peformed
>>> on the file will find the corrupt block and fail, but a second IO will see that
>>> the extent block is in memory, bypass the corruption check, and use garbage
>>> data as if they were extent data.
>> 
>> It looks like ext4_ext_check() is fairly heavyweight, so calling it on every
>> extent access may affect performance.  What about marking the extent or buffer
> 
> <shrug> I didn't think the simple header check was too terribly heavy...

My quick reading of this function showed that it was checking all of the extents in the block. 

> ... but it'll get more heavyweight when you add in metadata checksumming. :)

Agreed. 

>> bad in some way so that it always gets checked?  In the ext2 directory code
>> it marks a directory page with PG_checked to indicate that it was validated
>> on read, but there could be a number of different mechanisms to do this
>> (including setting a bit in the magic so that ext4_ext_check() is aborted
>> very quickly, possibly without any additional error on the console since
>> one would already have been printed).
> 
> Ok, I guess I could add a BH_Checked = BH_JBDPrivateStart

Make sure this does not conflict with some other ext4 private flag. 

> flag to ext4 and use
> that to bypass the header check (and especially the checksum check) if it's
> set.  Yes, I like that idea more... :)
> 
> Come to think of it I could probably reuse this in other places like the
> directory handling code.  Okay, I'll roll that in.

Once you start checksumming all the blocks it makes sense to track them all similarly. We burn a lot of cycles in the directory code doing checks like this. 

That said, memory corruption happens to, so it may make sense to probabilistically recheck blocks even with this flag set (e.g. if jiffies & mask == 0, with mask being 1/probability of the check).

>> 
>>> A simple testcase is to allocate a file with enough extents to overflow the
>>> inode i_block, umount, overwrite the extent block magic with garbage, then
>>> mount the filesystem and try to access the file.  The first access causes the
>>> kernel to spit out an error, but subsequent accesses seem to succeed.
>>> 
>>> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
>>> ---
>>> 
>>> fs/ext4/extents.c |    6 +-----
>>> 1 files changed, 1 insertions(+), 5 deletions(-)
>>> 
>>> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
>>> index ee4b391..bb07b79 100644
>>> --- a/fs/ext4/extents.c
>>> +++ b/fs/ext4/extents.c
>>> @@ -744,8 +744,6 @@ ext4_ext_find_extent(struct inode *inode, ext4_lblk_t block,
>>>    i = depth;
>>>    /* walk through the tree */
>>>    while (i) {
>>> -        int need_to_validate = 0;
>>> -
>>>        ext_debug("depth %d: num %d, max %d\n",
>>>              ppos, le16_to_cpu(eh->eh_entries), le16_to_cpu(eh->eh_max));
>>> 
>>> @@ -764,8 +762,6 @@ ext4_ext_find_extent(struct inode *inode, ext4_lblk_t block,
>>>                put_bh(bh);
>>>                goto err;
>>>            }
>>> -            /* validate the extent entries */
>>> -            need_to_validate = 1;
>>>        }
>>>        eh = ext_block_hdr(bh);
>>>        ppos++;
>>> @@ -779,7 +775,7 @@ ext4_ext_find_extent(struct inode *inode, ext4_lblk_t block,
>>>        path[ppos].p_hdr = eh;
>>>        i--;
>>> 
>>> -        if (need_to_validate && ext4_ext_check(inode, eh, i))
>>> +        if (ext4_ext_check(inode, eh, i))
>>>            goto err;
>>>    }
>>> 
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> 
>> 
>> Cheers, Andreas
>> 
>> 
>> 
>> 
>> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
