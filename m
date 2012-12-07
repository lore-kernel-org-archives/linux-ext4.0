From: Ashish Sangwan <ashishsangwan2@gmail.com>
Subject: Re: [PATCH] ext4: fix extent tree corruption that incurred by hole punch
Date: Fri, 7 Dec 2012 11:23:12 +0530
Message-ID: <CAOiN93kvSdzsJXqbabuLDcOh2me9wzLUPBsr2UY5BgHFXrhcnA@mail.gmail.com>
References: <1354623069-8124-1-git-send-email-forrestl@synology.com>
	<50C0BDA2.4090203@redhat.com>
	<50C0BE40.5060003@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Forrest Liu <forrestl@synology.com>,
	"Theodore Ts'o" <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:43757 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265Ab2LGFxN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Dec 2012 00:53:13 -0500
Received: by mail-vc0-f174.google.com with SMTP id d16so115096vcd.19
        for <linux-ext4@vger.kernel.org>; Thu, 06 Dec 2012 21:53:12 -0800 (PST)
In-Reply-To: <50C0BE40.5060003@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 6, 2012 at 9:18 PM, Eric Sandeen <sandeen@redhat.com> wrote:
> On 12/6/12 9:45 AM, Eric Sandeen wrote:
>> On 12/4/12 6:11 AM, Forrest Liu wrote:
>>> Extent indexes didn't update correctly in ext4_ext_rm_idx, when depth
>>> of extent tree is greater than 1.
>>
>> This is interesting; we had 2 reports of similar corruption on the
>> list, I wonder if the application in question was doing hole punching.
>> I didn't expect that they were, so TBH I was pretty much ignoring
>> the hole-punch cases for parent index updates.  Hm.  I'll have
>> to look into that.
>>
>> Could you turn your testcase into an xfstest regression test?
>
> Also, please note that I sent an e2fsck patch to try to fix this
> problem after the fact; it'd be great if in your testing, you could
> also confirm that e2fsck w/ my patch fixes it correctly.
>
I checked you patch.
This was the extent tree situation after removing 1st extent index:
debugfs:  ex abc
Level Entries       Logical        Physical Length Flags
 0/ 2   1/  1     0 -  8399  32857            8400
 1/ 2   1/  4  2048 -  4081   4138            2034
 2/ 2   1/339  2048 -  2053  69632 -  69637      6
 2/ 2   2/339  2054 -  2059  69656 -  69661      6

E2fsck's output with your patch=>
Linux#> /dtv/usb/sdb1/e2fsck /dev/sda1 -f
e2fsck 1.42.6.1 (06-DEC-2012)
Pass 1: Checking inodes, blocks, and sizes
Interior extent node level 0 of inode 31:
Logical start 0 does not match logical start 2048 at next level.  Fix<y>? yes
Inode 31, i_blocks is 50856, should be 16280.  Fix<y>? yes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Block bitmap differences:  -4138 -(73712--73717) -73728
-(98342--98347) -(98354--98359) -(98366--98371) -(98378--98383)
-(98390--98395) -(98402--98407)
< Similarly this was huge list of around 50-60 lines, so I skip to last >
910--106915) -(106922--106927) -(106934--106939) -(106946--106951)
-(106958--106963) -(122872--122879)
Fix<y>? yes
Free blocks count wrong for group #0 (14308, counted=14309).
Fix<y>? yes
Free blocks count wrong for group #2 (12297, counted=12304).
Fix<y>? yes
Free blocks count wrong for group #3 (9770, counted=14084).
Fix<y>? yes
Free blocks count wrong (52407, counted=56729).
Fix<y>? yes
/dev/sda1: ***** FILE SYSTEM WAS MODIFIED *****
/dev/sda1: 9872/126592 files (0.1% non-contiguous), 69775/126504 blocks
Linux#>

> Thanks,
> -Eric
>
>> -Eric
>>
>>> Signed-off-by: Forrest Liu <forrestl@synology.com>
>>> ---
>>>  fs/ext4/extents.c |   24 ++++++++++++++++++++----
>>>  1 files changed, 20 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
>>> index d3dd618..b10b8c0 100644
>>> --- a/fs/ext4/extents.c
>>> +++ b/fs/ext4/extents.c
>>> @@ -2190,13 +2190,15 @@ errout:
>>>   * removes index from the index block.
>>>   */
>>>  static int ext4_ext_rm_idx(handle_t *handle, struct inode *inode,
>>> -                    struct ext4_ext_path *path)
>>> +                    struct ext4_ext_path *path, int depth)
>>>  {
>>>      int err;
>>>      ext4_fsblk_t leaf;
>>> +    __le32 border;
>>>
>>>      /* free index block */
>>> -    path--;
>>> +    depth--;
>>> +    path = path + depth;
>>>      leaf = ext4_idx_pblock(path->p_idx);
>>>      if (unlikely(path->p_hdr->eh_entries == 0)) {
>>>              EXT4_ERROR_INODE(inode, "path->p_hdr->eh_entries == 0");
>>> @@ -2221,6 +2223,20 @@ static int ext4_ext_rm_idx(handle_t *handle, struct inode *inode,
>>>
>>>      ext4_free_blocks(handle, inode, NULL, leaf, 1,
>>>                       EXT4_FREE_BLOCKS_METADATA | EXT4_FREE_BLOCKS_FORGET);
>>> +
>>> +    border = path->p_idx->ei_block;
>>> +    while (--depth >= 0) {
>>> +            if (path->p_idx != EXT_FIRST_INDEX(path->p_hdr))
>>> +                    break;
>>> +            path--;
>>> +            err = ext4_ext_get_access(handle, inode, path);
>>> +            if (err)
>>> +                    break;
>>> +            path->p_idx->ei_block = border;
>>> +            err = ext4_ext_dirty(handle, inode, path);
>>> +            if (err)
>>> +                    break;
>>> +    }
>>>      return err;
>>>  }
>>>
>>> @@ -2557,7 +2573,7 @@ ext4_ext_rm_leaf(handle_t *handle, struct inode *inode,
>>>      /* if this leaf is free, then we should
>>>       * remove it from index block above */
>>>      if (err == 0 && eh->eh_entries == 0 && path[depth].p_bh != NULL)
>>> -            err = ext4_ext_rm_idx(handle, inode, path + depth);
>>> +            err = ext4_ext_rm_idx(handle, inode, path, depth);
>>>
>>>  out:
>>>      return err;
>>> @@ -2760,7 +2776,7 @@ again:
>>>                              /* index is empty, remove it;
>>>                               * handle must be already prepared by the
>>>                               * truncatei_leaf() */
>>> -                            err = ext4_ext_rm_idx(handle, inode, path + i);
>>> +                            err = ext4_ext_rm_idx(handle, inode, path, i);
>>>                      }
>>>                      /* root level has p_bh == NULL, brelse() eats this */
>>>                      brelse(path[i].p_bh);
>>>
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
