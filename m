From: Forrest Liu <forrestl@synology.com>
Subject: Re: [PATCH] ext4: fix extent tree corruption that incurred by hole punch
Date: Wed, 5 Dec 2012 14:13:09 +0800
Message-ID: <CAJSVwFNbvUO_i8CY-g8xb1fWHgAmKgGHYx2hnJqW_TKVHSWtHA@mail.gmail.com>
References: <1354623069-8124-1-git-send-email-forrestl@synology.com>
	<CAJSVwFMGZrOncF1s8xwZdDDVfYwtz_OBsKhHMGhMNZ98pQM06Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: "Theodore Ts'o" <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:42388 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576Ab2LEGNO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 5 Dec 2012 01:13:14 -0500
Received: by mail-ie0-f174.google.com with SMTP id c11so7554043ieb.19
        for <linux-ext4@vger.kernel.org>; Tue, 04 Dec 2012 22:13:12 -0800 (PST)
In-Reply-To: <CAJSVwFMGZrOncF1s8xwZdDDVfYwtz_OBsKhHMGhMNZ98pQM06Q@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2012/12/4 forrest <forrestl@synology.com>:
> This problem is easily to reproduce
>
> Create a file with size larger than 1GB.
>
> dd if=/dev/zero of=/test_file bs=1M count=1024
>
> Punch every even block in test_file, and then use debugfs to dump
> extents,  followings is dumped result
>
>  2/ 2 339/340 231197 - 231197   3917597 -   3917597      1
>  2/ 2 340/340 231199 - 231199   3917599 -   3917599      1
>  0/ 2   2/  2 231201 - 262143   3901486              30943
>  1/ 2   1/ 46 231201 - 231880   3901488                680
>  2/ 2   1/340 231201 - 231201   3917601 -   3917601      1
>  2/ 2   2/340 231203 - 231203   3917603 -   3917603      1
>
> Punch blocks #231779 ~#231201 , to remove extent index, and then use
> debugfs to dump extents,  followings is dumped result
>
> 2/ 2 340/340 231199 - 231199   3917599 -   3917599      1
>  0/ 2   2/  2 231201 - 262143   3901486              30943
> -------> logical block index didn't update when remove extent index
>  1/ 2   1/ 45 231881 - 232560   3901490                680
>  2/ 2   1/340 231881 - 231881   3918281 -   3918281      1
>  2/ 2   2/340 231883 - 231883   3918283 -   3918283      1

After blocks #231202~#231880 had been punch out, theses blocks can't map again.
If we do map a block in #231202~#231880, we will get error messages
like followings.

EXT4-fs error (device md2): ext4_ext_search_left:1239: inode #13: comm
flush-9:2: ix (231201) != EXT_FIRST_INDEX (1) (depth 0)!
EXT4-fs (md2): delayed block allocation failed for inode 13 at logical
offset 231203 with max blocks 1 with error -5
EXT4-fs (md2): This should not happen!! Data will be lost

Regards,
Forrest

>
> 2012/12/4 Forrest Liu <forrestl@synology.com>:
>> Extent indexes didn't update correctly in ext4_ext_rm_idx, when depth
>> of extent tree is greater than 1.
>>
>> Signed-off-by: Forrest Liu <forrestl@synology.com>
>> ---
>>  fs/ext4/extents.c |   24 ++++++++++++++++++++----
>>  1 files changed, 20 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
>> index d3dd618..b10b8c0 100644
>> --- a/fs/ext4/extents.c
>> +++ b/fs/ext4/extents.c
>> @@ -2190,13 +2190,15 @@ errout:
>>   * removes index from the index block.
>>   */
>>  static int ext4_ext_rm_idx(handle_t *handle, struct inode *inode,
>> -                       struct ext4_ext_path *path)
>> +                       struct ext4_ext_path *path, int depth)
>>  {
>>         int err;
>>         ext4_fsblk_t leaf;
>> +       __le32 border;
>>
>>         /* free index block */
>> -       path--;
>> +       depth--;
>> +       path = path + depth;
>>         leaf = ext4_idx_pblock(path->p_idx);
>>         if (unlikely(path->p_hdr->eh_entries == 0)) {
>>                 EXT4_ERROR_INODE(inode, "path->p_hdr->eh_entries == 0");
>> @@ -2221,6 +2223,20 @@ static int ext4_ext_rm_idx(handle_t *handle, struct inode *inode,
>>
>>         ext4_free_blocks(handle, inode, NULL, leaf, 1,
>>                          EXT4_FREE_BLOCKS_METADATA | EXT4_FREE_BLOCKS_FORGET);
>> +
>> +       border = path->p_idx->ei_block;
>> +       while (--depth >= 0) {
>> +               if (path->p_idx != EXT_FIRST_INDEX(path->p_hdr))
>> +                       break;
>> +               path--;
>> +               err = ext4_ext_get_access(handle, inode, path);
>> +               if (err)
>> +                       break;
>> +               path->p_idx->ei_block = border;
>> +               err = ext4_ext_dirty(handle, inode, path);
>> +               if (err)
>> +                       break;
>> +       }
>>         return err;
>>  }
>>
>> @@ -2557,7 +2573,7 @@ ext4_ext_rm_leaf(handle_t *handle, struct inode *inode,
>>         /* if this leaf is free, then we should
>>          * remove it from index block above */
>>         if (err == 0 && eh->eh_entries == 0 && path[depth].p_bh != NULL)
>> -               err = ext4_ext_rm_idx(handle, inode, path + depth);
>> +               err = ext4_ext_rm_idx(handle, inode, path, depth);
>>
>>  out:
>>         return err;
>> @@ -2760,7 +2776,7 @@ again:
>>                                 /* index is empty, remove it;
>>                                  * handle must be already prepared by the
>>                                  * truncatei_leaf() */
>> -                               err = ext4_ext_rm_idx(handle, inode, path + i);
>> +                               err = ext4_ext_rm_idx(handle, inode, path, i);
>>                         }
>>                         /* root level has p_bh == NULL, brelse() eats this */
>>                         brelse(path[i].p_bh);
>> --
>> 1.7.5.4
>>
