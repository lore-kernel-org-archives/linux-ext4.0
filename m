From: "Amir G." <amir73il@users.sourceforge.net>
Subject: Re: [PATCH RFC 05/30] ext4: snapshot hooks - delete blocks
Date: Tue, 7 Jun 2011 16:24:44 +0300
Message-ID: <BANLkTinKD5aQQfhVAdFc9UbpJTjvhnW-3A@mail.gmail.com>
References: <1304959308-11122-1-git-send-email-amir73il@users.sourceforge.net>
	<1304959308-11122-6-git-send-email-amir73il@users.sourceforge.net>
	<alpine.LFD.2.00.1106071306510.4754@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu,
	Amir Goldstein <amir73il@users.sf.net>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51713 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235Ab1FGNYp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Jun 2011 09:24:45 -0400
Received: by wwa36 with SMTP id 36so4924990wwa.1
        for <linux-ext4@vger.kernel.org>; Tue, 07 Jun 2011 06:24:44 -0700 (PDT)
In-Reply-To: <alpine.LFD.2.00.1106071306510.4754@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 7, 2011 at 2:24 PM, Lukas Czerner <lczerner@redhat.com> wro=
te:
> On Mon, 9 May 2011, amir73il@users.sourceforge.net wrote:
>
>> From: Amir Goldstein <amir73il@users.sf.net>
>>
>> Before deleting file blocks in ext4_free_blocks(),
>> we call the snapshot API ext4_snapshot_get_delete_access(),
>> to optionally move the block to the snapshot file instead of
>> freeing them.
>>
>> Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
>> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
>> ---
>> =A0fs/ext4/ext4.h =A0 =A0| =A0 10 +++++++---
>> =A0fs/ext4/mballoc.c | =A0 30 +++++++++++++++++++++++++++---
>> =A02 files changed, 34 insertions(+), 6 deletions(-)
>>
>> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
>> index ca25e67..4e9e46a 100644
>> --- a/fs/ext4/ext4.h
>> +++ b/fs/ext4/ext4.h
>> @@ -1729,9 +1729,13 @@ extern int ext4_mb_reserve_blocks(struct supe=
r_block *, int);
>> =A0extern void ext4_discard_preallocations(struct inode *);
>> =A0extern int __init ext4_init_mballoc(void);
>> =A0extern void ext4_exit_mballoc(void);
>> -extern void ext4_free_blocks(handle_t *handle, struct inode *inode,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct buffer_h=
ead *bh, ext4_fsblk_t block,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned long c=
ount, int flags);
>> +extern void __ext4_free_blocks(const char *where, unsigned int line=
,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0handle_t *h=
andle, =A0struct inode *inode,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct buff=
er_head *bh, ext4_fsblk_t block,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned lo=
ng count, int flags);
>> +#define ext4_free_blocks(handle, inode, bh, block, count, flags) \
>> + =A0 =A0 __ext4_free_blocks(__func__, __LINE__ , (handle), (inode),=
 (bh), \
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(block), (count), (=
flags))
>> =A0extern int ext4_mb_add_groupinfo(struct super_block *sb,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_group_t i, struct ext4_group_desc *=
desc);
>> =A0extern int ext4_trim_fs(struct super_block *, struct fstrim_range=
 *);
>> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
>> index e8bfd8d..3b1c6d1 100644
>> --- a/fs/ext4/mballoc.c
>> +++ b/fs/ext4/mballoc.c
>> @@ -4445,9 +4445,9 @@ ext4_mb_free_metadata(handle_t *handle, struct=
 ext4_buddy *e4b,
>> =A0 * @count: =A0 =A0 =A0 =A0 =A0 number of blocks to count
>> =A0 * @metadata: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Are these metadata b=
locks
>> =A0 */
>> -void ext4_free_blocks(handle_t *handle, struct inode *inode,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct buffer_head *bh, ext4_f=
sblk_t block,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned long count, int flags=
)
>> +void __ext4_free_blocks(const char *where, unsigned int line, handl=
e_t *handle,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct inode *inode, struc=
t buffer_head *bh,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_fsblk_t block, unsign=
ed long count, int flags)
>> =A0{
>> =A0 =A0 =A0 struct buffer_head *bitmap_bh =3D NULL;
>> =A0 =A0 =A0 struct super_block *sb =3D inode->i_sb;
>> @@ -4461,6 +4461,7 @@ void ext4_free_blocks(handle_t *handle, struct=
 inode *inode,
>> =A0 =A0 =A0 struct ext4_buddy e4b;
>> =A0 =A0 =A0 int err =3D 0;
>> =A0 =A0 =A0 int ret;
>> + =A0 =A0 int maxblocks;
>>
>> =A0 =A0 =A0 if (bh) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (block)
>> @@ -4543,6 +4544,29 @@ do_more:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto error_return;
>> =A0 =A0 =A0 }
>>
>> + =A0 =A0 maxblocks =3D count;
>> + =A0 =A0 ret =3D ext4_snapshot_get_delete_access(handle, inode,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 block, &maxblocks);
>
> It would be nice to have this defined in the same commit, so I know w=
hat
> is it doing.

Sorry, full patches again :-/
I will post them soon without any fixes, so you can have a look.

>
>> + =A0 =A0 if (ret < 0) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 ext4_journal_abort_handle(where, line, __f=
unc__,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 NULL, handle, ret);
>> + =A0 =A0 =A0 =A0 =A0 =A0 err =3D ret;
>> + =A0 =A0 =A0 =A0 =A0 =A0 goto error_return;
>> + =A0 =A0 }
>> + =A0 =A0 if (ret > 0) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 /* 'ret' blocks were moved to snapshot - s=
kip them */
>> + =A0 =A0 =A0 =A0 =A0 =A0 block +=3D maxblocks;
>> + =A0 =A0 =A0 =A0 =A0 =A0 count -=3D maxblocks;
>> + =A0 =A0 =A0 =A0 =A0 =A0 count +=3D overflow;
>> + =A0 =A0 =A0 =A0 =A0 =A0 cond_resched();
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (count > 0)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto do_more;
>> + =A0 =A0 =A0 =A0 =A0 =A0 /* no more blocks to free/move to snapshot=
 */
>> + =A0 =A0 =A0 =A0 =A0 =A0 ext4_mark_super_dirty(sb);
>> + =A0 =A0 =A0 =A0 =A0 =A0 goto error_return;
>> + =A0 =A0 }
>> + =A0 =A0 overflow +=3D count - maxblocks;
>> + =A0 =A0 count =3D maxblocks;
>> =A0 =A0 =A0 BUFFER_TRACE(bitmap_bh, "getting write access");
>> =A0 =A0 =A0 err =3D ext4_handle_get_bitmap_access(handle, sb, block_=
group, bitmap_bh);
>> =A0 =A0 =A0 if (err)
>>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
