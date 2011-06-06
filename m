From: "Amir G." <amir73il@users.sourceforge.net>
Subject: Re: [PATCH RFC 03/30] ext4: snapshot hooks - inside JBD hooks
Date: Mon, 6 Jun 2011 19:08:02 +0300
Message-ID: <BANLkTi==fLzFL_6aD7BSqyzEsww46wgh1g@mail.gmail.com>
References: <1304959308-11122-1-git-send-email-amir73il@users.sourceforge.net>
	<1304959308-11122-4-git-send-email-amir73il@users.sourceforge.net>
	<alpine.LFD.2.00.1106061732000.3934@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45635 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429Ab1FFQID convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 6 Jun 2011 12:08:03 -0400
Received: by wya21 with SMTP id 21so2907281wya.19
        for <linux-ext4@vger.kernel.org>; Mon, 06 Jun 2011 09:08:02 -0700 (PDT)
In-Reply-To: <alpine.LFD.2.00.1106061732000.3934@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 6, 2011 at 6:53 PM, Lukas Czerner <lczerner@redhat.com> wro=
te:
> On Mon, 9 May 2011, amir73il@users.sourceforge.net wrote:
>
>> From: Amir Goldstein <amir73il@users.sf.net>
>>
>> Before every metadata buffer write, the journal API is called,
>> namely, one of the ext4_journal_get_XXX_access() functions.
>> We use these journal hooks to call the snapshot API, namely
>> ext4_snapshot_get_XXX_access(), to COW the metadata buffer before
>> it is modified for the first time.
>>
>> Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
>> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
>> ---
>> =A0fs/ext4/ext4_jbd2.c =A0 | =A0 =A09 +++++++--
>> =A0fs/ext4/ext4_jbd2.h =A0 | =A0 15 +++++++++++----
>> =A0fs/ext4/extents.c =A0 =A0 | =A0 =A03 ++-
>> =A0fs/ext4/inode.c =A0 =A0 =A0 | =A0 22 +++++++++++++++-------
>> =A0fs/ext4/move_extent.c | =A0 =A03 ++-
>> =A05 files changed, 37 insertions(+), 15 deletions(-)
>>
>> diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
>> index 560020d..833969b 100644
>> --- a/fs/ext4/ext4_jbd2.c
>> +++ b/fs/ext4/ext4_jbd2.c
>> @@ -23,13 +23,16 @@ int __ext4_journal_get_undo_access(const char *w=
here, unsigned int line,
>> =A0 =A0 =A0 return err;
>> =A0}
>>
>> -int __ext4_journal_get_write_access(const char *where, unsigned int=
 line,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ha=
ndle_t *handle, struct buffer_head *bh)
>> +int __ext4_journal_get_write_access_inode(const char *where, unsign=
ed int line,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0handle_t *handle, struct inode *inode,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0struct buffer_head *bh, int exclude)
>> =A0{
>> =A0 =A0 =A0 int err =3D 0;
>>
>> =A0 =A0 =A0 if (ext4_handle_valid(handle)) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D jbd2_journal_get_write_access(ha=
ndle, bh);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (!err && !exclude)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D ext4_snapshot_get_=
write_access(handle, inode, bh);
>
> Agh, this is not defined anywhere again. Actually it is defined only =
if
> snapshot is not configured in. It is quite painful to review when hal=
f
> of the code is missing really. And also something like this will brea=
k
> bisecting for all of us. Is not there really the other way ?

Hi Lukas,

Thanks for the review :-)
I just have time to one quick answer now.
I will address the rest of your comments later.

As you understand, this patch series was stripped off of snapshot
code, so it only compiles with EXT4_FS_SNAPSHOT not defined.

I have no problem, of course, sending out the full patch series,
but my intention was, as I wrote in the introduction, that the first
review would concentrate on the question:
Will these patches introduce significant changes when snapshot
code is not compiled or if the feature is off.

Would you like me to post the full (40) patches?
If you rather trying out the github online review,
I can also post the patches there.

Thanks,
Amir.

>
> Also, could you document the new parameters ?
>
> Anyway:
> =A0 =A0 =A0 =A0if (!err && !exclude && inode)
>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (err)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_journal_abort_handl=
e(where, line, __func__, bh,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 handle, err);
>> @@ -111,6 +114,8 @@ int __ext4_journal_get_create_access(const char =
*where, unsigned int line,
>>
>> =A0 =A0 =A0 if (ext4_handle_valid(handle)) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D jbd2_journal_get_create_access(h=
andle, bh);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (!err)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D ext4_snapshot_get_=
create_access(handle, bh);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (err)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_journal_abort_handl=
e(where, line, __func__,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 bh, handle, err);
>> diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
>> index 8ffffb1..75662f7 100644
>> --- a/fs/ext4/ext4_jbd2.h
>> +++ b/fs/ext4/ext4_jbd2.h
>> @@ -132,9 +132,9 @@ void ext4_journal_abort_handle(const char *calle=
r, unsigned int line,
>> =A0int __ext4_journal_get_undo_access(const char *where, unsigned in=
t line,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0h=
andle_t *handle, struct buffer_head *bh);
>>
>> -int __ext4_journal_get_write_access(const char *where, unsigned int=
 line,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ha=
ndle_t *handle, struct buffer_head *bh);
>> -
>> +int __ext4_journal_get_write_access_inode(const char *where, unsign=
ed int line,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0handle_t *handle, struct inode *inode,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0struct buffer_head *bh, int exclude);
>> =A0int __ext4_forget(const char *where, unsigned int line, handle_t =
*handle,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int is_metadata, struct inode *inode=
,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct buffer_head *bh, ext4_fsblk_t=
 blocknr);
>> @@ -151,8 +151,15 @@ int __ext4_handle_dirty_super(const char *where=
, unsigned int line,
>>
>> =A0#define ext4_journal_get_undo_access(handle, bh) \
>> =A0 =A0 =A0 __ext4_journal_get_undo_access(__func__, __LINE__, (hand=
le), (bh))
>> +#define ext4_journal_get_write_access_exclude(handle, bh) \
>> + =A0 =A0 __ext4_journal_get_write_access_inode(__func__, __LINE__, =
\
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0(handle), NULL, (bh), 1)
>> =A0#define ext4_journal_get_write_access(handle, bh) \
>> - =A0 =A0 __ext4_journal_get_write_access(__func__, __LINE__, (handl=
e), (bh))
>> + =A0 =A0 __ext4_journal_get_write_access_inode(__func__, __LINE__, =
\
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0(handle), NULL, (bh), 0)
>> +#define ext4_journal_get_write_access_inode(handle, inode, bh) \
>> + =A0 =A0 __ext4_journal_get_write_access_inode(__func__, __LINE__, =
\
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 (handle), (inode), (bh), 0)
>
> Could you add some comments so everyone knows when to use the _exclud=
e
> helper and when not?
>
>> =A0#define ext4_forget(handle, is_metadata, inode, bh, block_nr) \
>> =A0 =A0 =A0 __ext4_forget(__func__, __LINE__, (handle), (is_metadata=
), (inode), \
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (bh), (block_nr))
>> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
>> index 0c3ea93..c8cab3d 100644
>> --- a/fs/ext4/extents.c
>> +++ b/fs/ext4/extents.c
>> @@ -77,7 +77,8 @@ static int ext4_ext_get_access(handle_t *handle, s=
truct inode *inode,
>> =A0{
>> =A0 =A0 =A0 if (path->p_bh) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* path points to block */
>> - =A0 =A0 =A0 =A0 =A0 =A0 return ext4_journal_get_write_access(handl=
e, path->p_bh);
>> + =A0 =A0 =A0 =A0 =A0 =A0 return ext4_journal_get_write_access_inode=
(handle,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 inode, path->p_bh);
>> =A0 =A0 =A0 }
>> =A0 =A0 =A0 /* path points to leaf/index in inode body */
>> =A0 =A0 =A0 /* we use in-core data, no need to protect them */
>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> index a597ff1..b848072 100644
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
>> @@ -874,7 +874,8 @@ static int ext4_splice_branch(handle_t *handle, =
struct inode *inode,
>> =A0 =A0 =A0 =A0*/
>> =A0 =A0 =A0 if (where->bh) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 BUFFER_TRACE(where->bh, "get_write_acces=
s");
>> - =A0 =A0 =A0 =A0 =A0 =A0 err =3D ext4_journal_get_write_access(hand=
le, where->bh);
>> + =A0 =A0 =A0 =A0 =A0 =A0 err =3D ext4_journal_get_write_access_inod=
e(handle, inode,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0where->bh);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (err)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto err_out;
>> =A0 =A0 =A0 }
>> @@ -4172,7 +4173,8 @@ static int ext4_clear_blocks(handle_t *handle,=
 struct inode *inode,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_err;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (bh) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 BUFFER_TRACE(bh, "retaki=
ng write access");
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D ext4_journal_get_w=
rite_access(handle, bh);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D ext4_journal_get_w=
rite_access_inode(handle,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 inode, bh);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (unlikely(err))
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out=
_err;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> @@ -4223,7 +4225,8 @@ static void ext4_free_data(handle_t *handle, s=
truct inode *inode,
>>
>> =A0 =A0 =A0 if (this_bh) { =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0/* For indirect block */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 BUFFER_TRACE(this_bh, "get_write_access"=
);
>> - =A0 =A0 =A0 =A0 =A0 =A0 err =3D ext4_journal_get_write_access(hand=
le, this_bh);
>> + =A0 =A0 =A0 =A0 =A0 =A0 err =3D ext4_journal_get_write_access_inod=
e(handle, inode,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0this_bh);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Important: if we can't update the ind=
irect pointers
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* to the blocks, we can't free them. =
*/
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (err)
>> @@ -4386,8 +4389,8 @@ static void ext4_free_branches(handle_t *handl=
e, struct inode *inode,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* poi=
nted to by an indirect block: journal it
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 BUFFER_T=
RACE(parent_bh, "get_write_access");
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!ext4_=
journal_get_write_access(handle,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0parent_bh))=
{
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!ext4_=
journal_get_write_access_inode(
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 handle, inode, parent_bh)){
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 *p =3D 0;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 BUFFER_TRACE(parent_bh,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 "call ext4_handle_dirty_metadata");
>> @@ -4759,9 +4762,14 @@ has_buffer:
>>
>> =A0int ext4_get_inode_loc(struct inode *inode, struct ext4_iloc *ilo=
c)
>> =A0{
>> - =A0 =A0 /* We have all inode data except xattrs in memory here. */
>> - =A0 =A0 return __ext4_get_inode_loc(inode, iloc,
>> + =A0 =A0 int in_mem =3D (!EXT4_SNAPSHOTS(inode->i_sb) &&
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 !ext4_test_inode_state(inode, EXT4_STATE=
_XATTR));
>> +
>> + =A0 =A0 /*
>> + =A0 =A0 =A0* We have all inode's data except xattrs in memory here=
,
>> + =A0 =A0 =A0* but we must always read-in the entire inode block for=
 COW.
>> + =A0 =A0 =A0*/
>> + =A0 =A0 return __ext4_get_inode_loc(inode, iloc, in_mem);
>> =A0}
>>
>> =A0void ext4_set_inode_flags(struct inode *inode)
>> diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
>> index b9f3e78..ad5409a 100644
>> --- a/fs/ext4/move_extent.c
>> +++ b/fs/ext4/move_extent.c
>> @@ -421,7 +421,8 @@ mext_insert_extents(handle_t *handle, struct ino=
de *orig_inode,
>>
>> =A0 =A0 =A0 if (depth) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Register to journal */
>> - =A0 =A0 =A0 =A0 =A0 =A0 ret =3D ext4_journal_get_write_access(hand=
le, orig_path->p_bh);
>> + =A0 =A0 =A0 =A0 =A0 =A0 ret =3D ext4_journal_get_write_access_inod=
e(handle,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 orig_inode, orig_path->p_bh);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ret;
>> =A0 =A0 =A0 }
>>
>
> --
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
