From: Tao Ma <tm@tao.ma>
Subject: Re: [PATCH 09/12] ext4: simplify journal handling in ext4_setup_new_group_blocks
Date: Mon, 18 Jul 2011 11:40:23 +0800
Message-ID: <4E23AB27.7010207@tao.ma>
References: <1310957555-15617-1-git-send-email-xiaoqiangnk@gmail.com>	<1310957555-15617-10-git-send-email-xiaoqiangnk@gmail.com>	<4E23A3DB.9020906@tao.ma> <CAGBYx2Z7hrOZXr98B_fBQ=YDBMgKAbPERYNDrKKsWwxqV8fSqg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:55060 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752272Ab1GRDk3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 17 Jul 2011 23:40:29 -0400
In-Reply-To: <CAGBYx2Z7hrOZXr98B_fBQ=YDBMgKAbPERYNDrKKsWwxqV8fSqg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 07/18/2011 11:21 AM, Yongqiang Yang wrote:
> On Mon, Jul 18, 2011 at 11:09 AM, Tao Ma <tm@tao.ma> wrote:
>> On 07/18/2011 10:52 AM, Yongqiang Yang wrote:
>>> This patch simplifies journal handling in ext4_setup_new_group_blocks().
>>>
>>>
>>> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
>>> ---
>>>  fs/ext4/resize.c |   39 ++++++++++++++++++++-------------------
>>>  1 files changed, 20 insertions(+), 19 deletions(-)
>>>
>>> diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
>>> index c91653c..ac5b63d 100644
>>> --- a/fs/ext4/resize.c
>>> +++ b/fs/ext4/resize.c
>>> @@ -171,8 +171,7 @@ static struct buffer_head *bclean(handle_t *handle, struct super_block *sb,
>>>   * If that fails, restart the transaction & regain write access for the
>>>   * buffer head which is used for block_bitmap modifications.
>>>   */
>>> -static int extend_or_restart_transaction(handle_t *handle, int thresh,
>>> -                                      struct buffer_head *bh)
>>> +static int extend_or_restart_transaction(handle_t *handle, int thresh)
>>>  {
>>>       int err;
>>>
>>> @@ -183,9 +182,8 @@ static int extend_or_restart_transaction(handle_t *handle, int thresh,
>>>       if (err < 0)
>>>               return err;
>>>       if (err) {
>>> -             if ((err = ext4_journal_restart(handle, EXT4_MAX_TRANS_DATA)))
>>> -                     return err;
>>> -             if ((err = ext4_journal_get_write_access(handle, bh)))
>>> +             err = ext4_journal_restart(handle, EXT4_MAX_TRANS_DATA);
>>> +             if (err)
>>>                       return err;
>> you removed an ext4_journal_get_write_access here, and I didn't see you
>> add it back anywhere.
> This get_write_access() was used to guarantee modification on the
> block bitmap is in the new handle in previous code.  In previous code,
> bitmap is modified everywhere in setup_group_blocks(),  actually, this
> makes things complicated, in this patch, the modifications on block
> bitmap are batched and are done by ext4_set_bits() after
> extend_or_restart_transaction(), so it is ok.
oh, I see. You moved the initialization of bh after the extension of
journal. OK, but please do describe all your changes in more detail in
the commit log.

Thanks
Tao
> 
> Thanks,
> Yongqiang.
>>
>> Thanks
>> Tao
>>>       }
>>>
>>> @@ -222,29 +220,24 @@ static int setup_new_group_blocks(struct super_block *sb,
>>>
>>>       BUG_ON(input->group != sbi->s_groups_count);
>>>
>>> -     if (IS_ERR(bh = bclean(handle, sb, input->block_bitmap))) {
>>> -             err = PTR_ERR(bh);
>>> -             goto exit_journal;
>>> -     }
>>> -
>>>       /* Copy all of the GDT blocks into the backup in this group */
>>>       for (i = 0, bit = 1, block = start + 1;
>>>            i < gdblocks; i++, block++, bit++) {
>>>               struct buffer_head *gdb;
>>>
>>>               ext4_debug("update backup group %#04llx (+%d)\n", block, bit);
>>> -
>>> -             if ((err = extend_or_restart_transaction(handle, 1, bh)))
>>> -                     goto exit_bh;
>>> +             err = extend_or_restart_transaction(handle, 1);
>>> +             if (err)
>>> +                     goto exit_journal;
>>>
>>>               gdb = sb_getblk(sb, block);
>>>               if (!gdb) {
>>>                       err = -EIO;
>>> -                     goto exit_bh;
>>> +                     goto exit_journal;
>>>               }
>>>               if ((err = ext4_journal_get_write_access(handle, gdb))) {
>>>                       brelse(gdb);
>>> -                     goto exit_bh;
>>> +                     goto exit_journal;
>>>               }
>>>               lock_buffer(gdb);
>>>               memcpy(gdb->b_data, sbi->s_group_desc[i]->b_data, gdb->b_size);
>>> @@ -253,7 +246,7 @@ static int setup_new_group_blocks(struct super_block *sb,
>>>               err = ext4_handle_dirty_metadata(handle, NULL, gdb);
>>>               if (unlikely(err)) {
>>>                       brelse(gdb);
>>> -                     goto exit_bh;
>>> +                     goto exit_journal;
>>>               }
>>>               brelse(gdb);
>>>       }
>>> @@ -264,7 +257,17 @@ static int setup_new_group_blocks(struct super_block *sb,
>>>       err = sb_issue_zeroout(sb, gdblocks + start + 1, reserved_gdb,
>>>                              GFP_NOFS);
>>>       if (err)
>>> -             goto exit_bh;
>>> +             goto exit_journal;
>>> +
>>> +     err = extend_or_restart_transaction(handle, 2);
>>> +     if (err)
>>> +             goto exit_journal;
>>> +
>>> +     bh = bclean(handle, sb, input->block_bitmap);
>>> +     if (IS_ERR(bh)) {
>>> +             err = PTR_ERR(bh);
>>> +             goto exit_journal;
>>> +     }
>>>
>>>       if (ext4_bg_has_super(sb, input->group)) {
>>>               ext4_debug("mark backup group tables %#04llx (+0)\n", start);
>>> @@ -288,8 +291,6 @@ static int setup_new_group_blocks(struct super_block *sb,
>>>       ext4_set_bits(bh->b_data, input->inode_table - start,
>>>                     sbi->s_itb_per_group);
>>>
>>> -     if ((err = extend_or_restart_transaction(handle, 2, bh)))
>>> -             goto exit_bh;
>>>
>>>       ext4_mark_bitmap_end(input->blocks_count, sb->s_blocksize * 8,
>>>                            bh->b_data);
>>
>>
> 
> 
> 

