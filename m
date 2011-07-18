From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH 09/12] ext4: simplify journal handling in ext4_setup_new_group_blocks
Date: Mon, 18 Jul 2011 11:46:25 +0800
Message-ID: <CAGBYx2YDQ+S7-ez6rfU410ca7f4BEk=g+Z19zP=ANvPJZcA5sQ@mail.gmail.com>
References: <1310957555-15617-1-git-send-email-xiaoqiangnk@gmail.com>
	<1310957555-15617-10-git-send-email-xiaoqiangnk@gmail.com>
	<4E23A3DB.9020906@tao.ma>
	<CAGBYx2Z7hrOZXr98B_fBQ=YDBMgKAbPERYNDrKKsWwxqV8fSqg@mail.gmail.com>
	<4E23AB27.7010207@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:47958 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755140Ab1GRDq0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 17 Jul 2011 23:46:26 -0400
Received: by pzk3 with SMTP id 3so3656846pzk.5
        for <linux-ext4@vger.kernel.org>; Sun, 17 Jul 2011 20:46:25 -0700 (PDT)
In-Reply-To: <4E23AB27.7010207@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 18, 2011 at 11:40 AM, Tao Ma <tm@tao.ma> wrote:
> On 07/18/2011 11:21 AM, Yongqiang Yang wrote:
>> On Mon, Jul 18, 2011 at 11:09 AM, Tao Ma <tm@tao.ma> wrote:
>>> On 07/18/2011 10:52 AM, Yongqiang Yang wrote:
>>>> This patch simplifies journal handling in ext4_setup_new_group_blo=
cks().
>>>>
>>>>
>>>> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
>>>> ---
>>>> =A0fs/ext4/resize.c | =A0 39 ++++++++++++++++++++-----------------=
--
>>>> =A01 files changed, 20 insertions(+), 19 deletions(-)
>>>>
>>>> diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
>>>> index c91653c..ac5b63d 100644
>>>> --- a/fs/ext4/resize.c
>>>> +++ b/fs/ext4/resize.c
>>>> @@ -171,8 +171,7 @@ static struct buffer_head *bclean(handle_t *ha=
ndle, struct super_block *sb,
>>>> =A0 * If that fails, restart the transaction & regain write access=
 for the
>>>> =A0 * buffer head which is used for block_bitmap modifications.
>>>> =A0 */
>>>> -static int extend_or_restart_transaction(handle_t *handle, int th=
resh,
>>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0struct buffer_head *bh)
>>>> +static int extend_or_restart_transaction(handle_t *handle, int th=
resh)
>>>> =A0{
>>>> =A0 =A0 =A0 int err;
>>>>
>>>> @@ -183,9 +182,8 @@ static int extend_or_restart_transaction(handl=
e_t *handle, int thresh,
>>>> =A0 =A0 =A0 if (err < 0)
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return err;
>>>> =A0 =A0 =A0 if (err) {
>>>> - =A0 =A0 =A0 =A0 =A0 =A0 if ((err =3D ext4_journal_restart(handle=
, EXT4_MAX_TRANS_DATA)))
>>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return err;
>>>> - =A0 =A0 =A0 =A0 =A0 =A0 if ((err =3D ext4_journal_get_write_acce=
ss(handle, bh)))
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 err =3D ext4_journal_restart(handle, EXT=
4_MAX_TRANS_DATA);
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 if (err)
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return err;
>>> you removed an ext4_journal_get_write_access here, and I didn't see=
 you
>>> add it back anywhere.
>> This get_write_access() was used to guarantee modification on the
>> block bitmap is in the new handle in previous code. =A0In previous c=
ode,
>> bitmap is modified everywhere in setup_group_blocks(), =A0actually, =
this
>> makes things complicated, in this patch, the modifications on block
>> bitmap are batched and are done by ext4_set_bits() after
>> extend_or_restart_transaction(), so it is ok.
> oh, I see. You moved the initialization of bh after the extension of
> journal. OK, but please do describe all your changes in more detail i=
n
> the commit log.
Yes, my carelessness.

Thank you for your review.

Yongqiang.
>
> Thanks
> Tao
>>
>> Thanks,
>> Yongqiang.
>>>
>>> Thanks
>>> Tao
>>>> =A0 =A0 =A0 }
>>>>
>>>> @@ -222,29 +220,24 @@ static int setup_new_group_blocks(struct sup=
er_block *sb,
>>>>
>>>> =A0 =A0 =A0 BUG_ON(input->group !=3D sbi->s_groups_count);
>>>>
>>>> - =A0 =A0 if (IS_ERR(bh =3D bclean(handle, sb, input->block_bitmap=
))) {
>>>> - =A0 =A0 =A0 =A0 =A0 =A0 err =3D PTR_ERR(bh);
>>>> - =A0 =A0 =A0 =A0 =A0 =A0 goto exit_journal;
>>>> - =A0 =A0 }
>>>> -
>>>> =A0 =A0 =A0 /* Copy all of the GDT blocks into the backup in this =
group */
>>>> =A0 =A0 =A0 for (i =3D 0, bit =3D 1, block =3D start + 1;
>>>> =A0 =A0 =A0 =A0 =A0 =A0i < gdblocks; i++, block++, bit++) {
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct buffer_head *gdb;
>>>>
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_debug("update backup group %#04ll=
x (+%d)\n", block, bit);
>>>> -
>>>> - =A0 =A0 =A0 =A0 =A0 =A0 if ((err =3D extend_or_restart_transacti=
on(handle, 1, bh)))
>>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto exit_bh;
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 err =3D extend_or_restart_transaction(ha=
ndle, 1);
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 if (err)
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto exit_journal;
>>>>
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 gdb =3D sb_getblk(sb, block);
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!gdb) {
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D -EIO;
>>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto exit_bh;
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto exit_journal;
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((err =3D ext4_journal_get_write_ac=
cess(handle, gdb))) {
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 brelse(gdb);
>>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto exit_bh;
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto exit_journal;
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 lock_buffer(gdb);
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(gdb->b_data, sbi->s_group_desc[=
i]->b_data, gdb->b_size);
>>>> @@ -253,7 +246,7 @@ static int setup_new_group_blocks(struct super=
_block *sb,
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D ext4_handle_dirty_metadata(han=
dle, NULL, gdb);
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (unlikely(err)) {
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 brelse(gdb);
>>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto exit_bh;
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto exit_journal;
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 brelse(gdb);
>>>> =A0 =A0 =A0 }
>>>> @@ -264,7 +257,17 @@ static int setup_new_group_blocks(struct supe=
r_block *sb,
>>>> =A0 =A0 =A0 err =3D sb_issue_zeroout(sb, gdblocks + start + 1, res=
erved_gdb,
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0GFP_NOF=
S);
>>>> =A0 =A0 =A0 if (err)
>>>> - =A0 =A0 =A0 =A0 =A0 =A0 goto exit_bh;
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 goto exit_journal;
>>>> +
>>>> + =A0 =A0 err =3D extend_or_restart_transaction(handle, 2);
>>>> + =A0 =A0 if (err)
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 goto exit_journal;
>>>> +
>>>> + =A0 =A0 bh =3D bclean(handle, sb, input->block_bitmap);
>>>> + =A0 =A0 if (IS_ERR(bh)) {
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 err =3D PTR_ERR(bh);
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 goto exit_journal;
>>>> + =A0 =A0 }
>>>>
>>>> =A0 =A0 =A0 if (ext4_bg_has_super(sb, input->group)) {
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_debug("mark backup group tables %=
#04llx (+0)\n", start);
>>>> @@ -288,8 +291,6 @@ static int setup_new_group_blocks(struct super=
_block *sb,
>>>> =A0 =A0 =A0 ext4_set_bits(bh->b_data, input->inode_table - start,
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sbi->s_itb_per_group);
>>>>
>>>> - =A0 =A0 if ((err =3D extend_or_restart_transaction(handle, 2, bh=
)))
>>>> - =A0 =A0 =A0 =A0 =A0 =A0 goto exit_bh;
>>>>
>>>> =A0 =A0 =A0 ext4_mark_bitmap_end(input->blocks_count, sb->s_blocks=
ize * 8,
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bh->b_data)=
;
>>>
>>>
>>
>>
>>
>
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
