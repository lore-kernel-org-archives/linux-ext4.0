From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH v1] ext4:Allow an active handle to be started when freezing.
Date: Wed, 6 Apr 2011 08:52:40 +0800
Message-ID: <BANLkTikzAgN=D1UOd9FgKt5A5Qwf_4nevg@mail.gmail.com>
References: <BANLkTikqLrAyVaULk5UQsM7TzGk73ihsKg@mail.gmail.com>
	<20110405222630.GB8531@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Ted Ts'o" <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51105 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102Ab1DFAwm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 5 Apr 2011 20:52:42 -0400
Received: by wya21 with SMTP id 21so836294wya.19
        for <linux-ext4@vger.kernel.org>; Tue, 05 Apr 2011 17:52:41 -0700 (PDT)
In-Reply-To: <20110405222630.GB8531@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 6, 2011 at 6:26 AM, Jan Kara <jack@suse.cz> wrote:
> On Tue 05-04-11 15:47:25, Yongqiang Yang wrote:
>> v0->v1:
>> =A0 check s_frozen in nojournal case only if there is no an active h=
andle.
>> =A0 get reference to an active handle by jbd2_journal_start().
>>
>> ext4_journal_start_sb() should not prevent an active handle from bei=
ng
>> started due to s_frozen. =A0Otherwise, deadlock is easy to happen, b=
elow
>> is a situation.
>>
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
>> =A0 =A0 =A0freeze =A0 =A0 =A0 =A0 | =A0 =A0 =A0 truncate
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0ext4_ext_truncate()
>> =A0 =A0 freeze_super() =A0| =A0 starts a handle
>> =A0 =A0 sets s_frozen =A0 |
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0ext4_ext_truncate()
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0holds i_data_sem
>> =A0 ext4_freeze() =A0 =A0 |
>> =A0 waits for updates |
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0ext4_free_blocks()
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0calls dquot_free_block(=
)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 |
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0dquot_free_blocks()
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0calls ext4_dirty_inode(=
)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 |
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0ext4_dirty_inode()
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0trys to start an active
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0handle
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 |
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0block due to s_frozen
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
>>
>> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
>> Reported-by: Amir Goldstein <amir73il@users.sf.net>
>> Reviewed-by: Jan Kara <jack@suse.cz>
> =A0The usual workflow is that you add 'Reviewed-by' tag to the patch =
only
> after you send a version of a patch the person agrees to and explicit=
ely
> says you can add a tag - for example I write something like "You can =
add
> Reviewed-by: Jan Kara <jack@suse.cz>"
> when I agree to the tag being added.
I see.  Thank you.
>
>> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
>> index ccfa686..53920bd 100644
>> --- a/fs/ext4/super.c
>> +++ b/fs/ext4/super.c
>> @@ -242,27 +242,45 @@ static void ext4_put_nojournal(handle_t *handl=
e)
>> =A0 * journal_end calls result in the superblock being marked dirty,=
 so
>> =A0 * that sync() will call the filesystem's write_super callback if
>> =A0 * appropriate.
>> + *
>> + * To avoid j_barrier hold in userspace when a user calls freeze(),
>> + * ext4 prevents a new handle from being started by s_frozen, which
>> + * is in an upper layer.
>> =A0 */
>> =A0handle_t *ext4_journal_start_sb(struct super_block *sb, int nbloc=
ks)
>> =A0{
>> =A0 =A0 =A0 journal_t *journal;
>> + =A0 =A0 handle_t =A0*handle;
>>
>> =A0 =A0 =A0 if (sb->s_flags & MS_RDONLY)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ERR_PTR(-EROFS);
>>
>> - =A0 =A0 vfs_check_frozen(sb, SB_FREEZE_TRANS);
>> - =A0 =A0 /* Special case here: if the journal has aborted behind ou=
r
>> - =A0 =A0 =A0* backs (eg. EIO in the commit thread), then we still n=
eed to
>> - =A0 =A0 =A0* take the FS itself readonly cleanly. */
>> =A0 =A0 =A0 journal =3D EXT4_SB(sb)->s_journal;
>> - =A0 =A0 if (journal) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 if (is_journal_aborted(journal)) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_abort(sb, "Detected a=
borted journal");
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ERR_PTR(-EROFS);
>> - =A0 =A0 =A0 =A0 =A0 =A0 }
>> - =A0 =A0 =A0 =A0 =A0 =A0 return jbd2_journal_start(journal, nblocks=
);
>> + =A0 =A0 handle =3D ext4_journal_current_handle();
>> +
>> + =A0 =A0 /*
>> + =A0 =A0 =A0* Before vfs_check_frozen(), the current handle should =
be allowed
>> + =A0 =A0 =A0* to finish, otherwise deadlock would happen when the f=
ilesystem
>> + =A0 =A0 =A0* is freezed && active handles are not stopped.
>> + =A0 =A0 =A0*/
>> + =A0 =A0 if (!journal) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (!handle)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 vfs_check_frozen(sb, SB_FR=
EEZE_TRANS);
>> + =A0 =A0 =A0 =A0 =A0 =A0 return ext4_get_nojournal();
>> =A0 =A0 =A0 }
>> - =A0 =A0 return ext4_get_nojournal();
>> +
>> + =A0 =A0 if (!handle)
>> + =A0 =A0 =A0 =A0 =A0 =A0 vfs_check_frozen(sb, SB_FREEZE_TRANS);
> =A0This test is the same for 'nojournal' case so you can move it befo=
re the
> !journal test. Otherwise the patch looks OK to me. So now you can add
> Reviewed-by: Jan Kara <jack@suse.cz>
> line :)
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
Honza
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
