From: Forrest Liu <forrestl@synology.com>
Subject: Re: [PATCH] ext4: fix extent tree corruption that incurred by hole punch
Date: Thu, 6 Dec 2012 22:36:33 +0800
Message-ID: <CAJSVwFNPpsEPohbg_E-+brmR+ivO8Zfrd4LiNoY1nqOPkx_t+w@mail.gmail.com>
References: <1354623069-8124-1-git-send-email-forrestl@synology.com>
	<CAJSVwFMGZrOncF1s8xwZdDDVfYwtz_OBsKhHMGhMNZ98pQM06Q@mail.gmail.com>
	<CAJSVwFNbvUO_i8CY-g8xb1fWHgAmKgGHYx2hnJqW_TKVHSWtHA@mail.gmail.com>
	<CAOiN93kGE_mFGg+BLNYBLbeggnk-9nr5k0BDUTTq+81P9k3tWA@mail.gmail.com>
	<CAOiN93m+GQW3k41U6Nsnj6z7ez8nq113Wn_PFzYLzo4ahX734g@mail.gmail.com>
	<CAJSVwFNQUpVd0Kcua+VWx16RR9BsYnQyZYdVCWB6tVgcYA6LUQ@mail.gmail.com>
	<CAOiN93mbVSvANaUH3S-Y8mfa4uvYcc=iRO3vd4BUpAWgJMJdyA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Ashish Sangwan <ashishsangwan2@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ie0-f170.google.com ([209.85.223.170]:56251 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423553Ab2LFOoq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Dec 2012 09:44:46 -0500
Received: by mail-ie0-f170.google.com with SMTP id k10so17816960iea.1
        for <linux-ext4@vger.kernel.org>; Thu, 06 Dec 2012 06:44:46 -0800 (PST)
In-Reply-To: <CAOiN93mbVSvANaUH3S-Y8mfa4uvYcc=iRO3vd4BUpAWgJMJdyA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ashish,

   There have a chance to do  a trivial update, and this case will be
covered in ext4_ext_remove_space.

+       if (err == 0 && eh->eh_entries == 0 && path[depth].p_bh != NULL) {
                 err = ext4_ext_rm_idx(handle, inode, path + depth);
+               /* If this was the first extent index in node,
+                * propagates the ei_block updation info to top */
+               if(!err) {
+                       --depth;
+                       path = path + depth;
+                       while (--depth >= 0) {
+                               if (path->p_idx != EXT_FIRST_INDEX(path->p_hdr))
+                                       break;
+                               path--;
+                               err = ext4_ext_get_access(handle, inode, path);
+                               if (err)
+                                       break;

        trivial update, when (path + 1)->p_idx->eh_entries == 0

+                               path->p_idx->ei_block =(path +
1)->p_idx->ei_block ;
+                               err = ext4_ext_dirty(handle, inode, path);
+                               if (err)
+                                       break;
+                       }
+               }
+       }
+

   I will trying to reproduce the problem tomorrow.

Thanks,
Forrest

2012/12/6 Ashish Sangwan <ashishsangwan2@gmail.com>:
> On Thu, Dec 6, 2012 at 5:05 PM, Forrest Liu <forrestl@synology.com> wrote:
>> Hi Ashish,
>>    Thanks for your review and fixed hole punch bugs.
>>
>> We can't propogate ei_block only in ext4_ext_rm_leave.
>>
>> There have two cases to call ext4_ext_rm_idx
>> 1) extent block has no entry, ext4_ext_rm_leave calls
>> ext4_ext_rm_idx to release extent block.
>>
>
> 1.1)  And when the extent block is removed, the corresponding index
> entry has also to be removed. And if this was the first index entry,
> all the other index entries, are also updated. This updation will
> continue till we reach the root of extent tree OR the currently
> updated index entry is not the first entry in the node.
>
>> 2) extent index block has no entry, ext4_ext_remove_space
>> calls ext4_ext_rm_idx to release extent index block.
>>
>> Consider remove third level of extent index block that indexed by
>> second level of extent index, and the extent index in second level
>> is first entry in block.
>>
> So, I think the above case would be handled by point (1.1) i.e. the
> earlier index updation done from within ext4_ext_rm_leaf.
> The earlier ei_block updation will reach to the top of tree.
>
>> In this case, ei_block will not propogate to top level correctly,
>> if we only do propogation in ext4_ext_rm_leave.
>
> And thanks for pointing the problem. Can you reproduce it with my code
> suggesstion even with depth 3?
> If no, than please resend the patch with suggested changes.
> The intent here is to solve the problem without changing any function
> signature and with minimal changes.
>
> Regards,
> Ashish
>>
>> Regards,
>> Forrest
>>
>> 2012/12/5 Ashish Sangwan <ashishsangwan2@gmail.com>:
>>> Sorry 1 typo.
>>> It should be
>>> + path->p_idx->ei_block =(path + 1)->p_idx->ei_block ;
>>> instead of
>>> + path->p_idx->ei_block = border;
>>>
>>> On Wed, Dec 5, 2012 at 1:23 PM, Ashish Sangwan <ashishsangwan2@gmail.com> wrote:
>>>> I have tested it and the problem is real.
>>>> It happens when depth => 2 and punch hole completely removes any of
>>>> the first extent indexes at depth 1.
>>>> The change in ei_block is not propagated backwards to index at depth 0.
>>>>
>>>> However, AFAICS, the problematic call to ext4_ext_rm_idx is from
>>>> ext4_ext_rm_leaf and there is no need to change in
>>>> ext4_ext_remove_space or in ext4_ext_rm_idx.
>>>>
>>>> Forrest, what do you think about below change ?
>>>> basically its your code, but its been added to ext4_ext_rm_leaf after
>>>> removing index.
>>>>
>>>> @@ -2448,8 +2464,28 @@ ext4_ext_rm_leaf(handle_t *handle, struct inode *inode,
>>>>
>>>>         /* if this leaf is free, then we should
>>>>          * remove it from index block above */
>>>> -       if (err == 0 && eh->eh_entries == 0 && path[depth].p_bh != NULL)
>>>> +       if (err == 0 && eh->eh_entries == 0 && path[depth].p_bh != NULL) {
>>>>                 err = ext4_ext_rm_idx(handle, inode, path + depth);
>>>> +               /* If this was the first extent index in node,
>>>> +                * propagates the ei_block updation info to top */
>>>> +               if(!err) {
>>>> +                       --depth;
>>>> +                       path = path + depth;
>>>> +                       while (--depth >= 0) {
>>>> +                               if (path->p_idx != EXT_FIRST_INDEX(path->p_hdr))
>>>> +                                       break;
>>>> +                               path--;
>>>> +                               err = ext4_ext_get_access(handle, inode, path);
>>>> +                               if (err)
>>>> +                                       break;
>>>> +                               path->p_idx->ei_block = border;
>>>> +                               err = ext4_ext_dirty(handle, inode, path);
>>>> +                               if (err)
>>>> +                                       break;
>>>> +                       }
>>>> +               }
>>>> +       }
>>>> +
>>>>
>>>> On Wed, Dec 5, 2012 at 11:43 AM, Forrest Liu <forrestl@synology.com> wrote:
>>>>> 2012/12/4 forrest <forrestl@synology.com>:
>>>>>> This problem is easily to reproduce
>>>>>>
>>>>>> Create a file with size larger than 1GB.
>>>>>>
>>>>>> dd if=/dev/zero of=/test_file bs=1M count=1024
>>>>>>
>>>>>> Punch every even block in test_file, and then use debugfs to dump
>>>>>> extents,  followings is dumped result
>>>>>>
>>>>>>  2/ 2 339/340 231197 - 231197   3917597 -   3917597      1
>>>>>>  2/ 2 340/340 231199 - 231199   3917599 -   3917599      1
>>>>>>  0/ 2   2/  2 231201 - 262143   3901486              30943
>>>>>>  1/ 2   1/ 46 231201 - 231880   3901488                680
>>>>>>  2/ 2   1/340 231201 - 231201   3917601 -   3917601      1
>>>>>>  2/ 2   2/340 231203 - 231203   3917603 -   3917603      1
>>>>>>
>>>>>> Punch blocks #231779 ~#231201 , to remove extent index, and then use
>>>>>> debugfs to dump extents,  followings is dumped result
>>>>>>
>>>>>> 2/ 2 340/340 231199 - 231199   3917599 -   3917599      1
>>>>>>  0/ 2   2/  2 231201 - 262143   3901486              30943
>>>>>> -------> logical block index didn't update when remove extent index
>>>>>>  1/ 2   1/ 45 231881 - 232560   3901490                680
>>>>>>  2/ 2   1/340 231881 - 231881   3918281 -   3918281      1
>>>>>>  2/ 2   2/340 231883 - 231883   3918283 -   3918283      1
>>>>>
>>>>> After blocks #231202~#231880 had been punch out, theses blocks can't map again.
>>>>> If we do map a block in #231202~#231880, we will get error messages
>>>>> like followings.
>>>>>
>>>>> EXT4-fs error (device md2): ext4_ext_search_left:1239: inode #13: comm
>>>>> flush-9:2: ix (231201) != EXT_FIRST_INDEX (1) (depth 0)!
>>>>> EXT4-fs (md2): delayed block allocation failed for inode 13 at logical
>>>>> offset 231203 with max blocks 1 with error -5
>>>>> EXT4-fs (md2): This should not happen!! Data will be lost
>>>>>
>>>>> Regards,
>>>>> Forrest
>>>>>
>>>>>>
>>>>>> 2012/12/4 Forrest Liu <forrestl@synology.com>:
>>>>>>> Extent indexes didn't update correctly in ext4_ext_rm_idx, when depth
>>>>>>> of extent tree is greater than 1.
>>>>>>>
>>>>>>> Signed-off-by: Forrest Liu <forrestl@synology.com>
>>>>>>> ---
>>>>>>>  fs/ext4/extents.c |   24 ++++++++++++++++++++----
>>>>>>>  1 files changed, 20 insertions(+), 4 deletions(-)
>>>>>>>
>>>>>>> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
>>>>>>> index d3dd618..b10b8c0 100644
>>>>>>> --- a/fs/ext4/extents.c
>>>>>>> +++ b/fs/ext4/extents.c
>>>>>>> @@ -2190,13 +2190,15 @@ errout:
>>>>>>>   * removes index from the index block.
>>>>>>>   */
>>>>>>>  static int ext4_ext_rm_idx(handle_t *handle, struct inode *inode,
>>>>>>> -                       struct ext4_ext_path *path)
>>>>>>> +                       struct ext4_ext_path *path, int depth)
>>>>>>>  {
>>>>>>>         int err;
>>>>>>>         ext4_fsblk_t leaf;
>>>>>>> +       __le32 border;
>>>>>>>
>>>>>>>         /* free index block */
>>>>>>> -       path--;
>>>>>>> +       depth--;
>>>>>>> +       path = path + depth;
>>>>>>>         leaf = ext4_idx_pblock(path->p_idx);
>>>>>>>         if (unlikely(path->p_hdr->eh_entries == 0)) {
>>>>>>>                 EXT4_ERROR_INODE(inode, "path->p_hdr->eh_entries == 0");
>>>>>>> @@ -2221,6 +2223,20 @@ static int ext4_ext_rm_idx(handle_t *handle, struct inode *inode,
>>>>>>>
>>>>>>>         ext4_free_blocks(handle, inode, NULL, leaf, 1,
>>>>>>>                          EXT4_FREE_BLOCKS_METADATA | EXT4_FREE_BLOCKS_FORGET);
>>>>>>> +
>>>>>>> +       border = path->p_idx->ei_block;
>>>>>>> +       while (--depth >= 0) {
>>>>>>> +               if (path->p_idx != EXT_FIRST_INDEX(path->p_hdr))
>>>>>>> +                       break;
>>>>>>> +               path--;
>>>>>>> +               err = ext4_ext_get_access(handle, inode, path);
>>>>>>> +               if (err)
>>>>>>> +                       break;
>>>>>>> +               path->p_idx->ei_block = border;
>>>>>>> +               err = ext4_ext_dirty(handle, inode, path);
>>>>>>> +               if (err)
>>>>>>> +                       break;
>>>>>>> +       }
>>>>>>>         return err;
>>>>>>>  }
>>>>>>>
>>>>>>> @@ -2557,7 +2573,7 @@ ext4_ext_rm_leaf(handle_t *handle, struct inode *inode,
>>>>>>>         /* if this leaf is free, then we should
>>>>>>>          * remove it from index block above */
>>>>>>>         if (err == 0 && eh->eh_entries == 0 && path[depth].p_bh != NULL)
>>>>>>> -               err = ext4_ext_rm_idx(handle, inode, path + depth);
>>>>>>> +               err = ext4_ext_rm_idx(handle, inode, path, depth);
>>>>>>>
>>>>>>>  out:
>>>>>>>         return err;
>>>>>>> @@ -2760,7 +2776,7 @@ again:
>>>>>>>                                 /* index is empty, remove it;
>>>>>>>                                  * handle must be already prepared by the
>>>>>>>                                  * truncatei_leaf() */
>>>>>>> -                               err = ext4_ext_rm_idx(handle, inode, path + i);
>>>>>>> +                               err = ext4_ext_rm_idx(handle, inode, path, i);
>>>>>>>                         }
>>>>>>>                         /* root level has p_bh == NULL, brelse() eats this */
>>>>>>>                         brelse(path[i].p_bh);
>>>>>>> --
>>>>>>> 1.7.5.4
>>>>>>>
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>>>>> the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
