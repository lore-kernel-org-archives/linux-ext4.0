From: Curt Wohlgemuth <curtw@google.com>
Subject: Re: [PATCH 2/2] ext4: Handle nested ext4_journal_start/stop calls
	without a journal
Date: Wed, 23 Sep 2009 07:39:43 -0700
Message-ID: <6601abe90909230739j27162e99p54ddd82223e9a6d5@mail.gmail.com>
References: <6601abe90909171455g597fe672g1ca6d426e609f937@mail.gmail.com>
	 <20090918055010.GN2537@webber.adilger.int>
	 <6601abe90909181133g27458301nb3aae756e473541c@mail.gmail.com>
	 <6601abe90909181433l67e7764w6416ae5975b78c3f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:17474 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289AbZIWOjo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Sep 2009 10:39:44 -0400
Received: from wpaz24.hot.corp.google.com (wpaz24.hot.corp.google.com [172.24.198.88])
	by smtp-out.google.com with ESMTP id n8NEdkmA003464
	for <linux-ext4@vger.kernel.org>; Wed, 23 Sep 2009 15:39:47 +0100
Received: from pzk31 (pzk31.prod.google.com [10.243.19.159])
	by wpaz24.hot.corp.google.com with ESMTP id n8NEdhUb031098
	for <linux-ext4@vger.kernel.org>; Wed, 23 Sep 2009 07:39:44 -0700
Received: by pzk31 with SMTP id 31so567788pzk.26
        for <linux-ext4@vger.kernel.org>; Wed, 23 Sep 2009 07:39:43 -0700 (PDT)
In-Reply-To: <6601abe90909181433l67e7764w6416ae5975b78c3f@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ted, do you have any comments or suggestions on this patch?
No-journal use of ext4 is definitely broken without it; we've seen
numerous crashes with the existing code, which doesn't ref count the
no-journal handle.

Thanks,
Curt


On Fri, Sep 18, 2009 at 2:33 PM, Curt Wohlgemuth <curtw@google.com> wro=
te:
> Here's version 2, thanks to Andreas' suggestion.
>
> Curt
>
>
> This patch fixes a problem with handling nested calls to
> ext4_journal_start/ext4_journal_stop, when there is no journal presen=
t.
>
> =A0 =A0 =A0 =A0Signed-off-by: Curt Wohlgemuth <curtw@google.com>
> ---
>
> Taking Andreas' suggestion, what I'm calling "an allocated handle tha=
t
> doesn't use a journal" is now identified by a value in the range
>
> =A0 [1, 4095]
>
> A handle with value 0 (NULL) still represents "an unallocated handle.=
"
>
> I added a comment atop ext4_handle_valid() to indicate that sending i=
t a
> NULL pointer was just wrong.
>
> diff -uprN orig/fs/ext4/ext4_jbd2.h new/fs/ext4/ext4_jbd2.h
> --- orig/fs/ext4/ext4_jbd2.h =A0 =A02009-09-18 14:04:15.000000000 -07=
00
> +++ new/fs/ext4/ext4_jbd2.h =A0 =A0 2009-09-18 14:17:31.000000000 -07=
00
> @@ -161,11 +161,13 @@ int __ext4_handle_dirty_metadata(const c
> =A0handle_t *ext4_journal_start_sb(struct super_block *sb, int nblock=
s);
> =A0int __ext4_journal_stop(const char *where, handle_t *handle);
>
> -#define EXT4_NOJOURNAL_HANDLE =A0((handle_t *) 0x1)
> +#define EXT4_NOJOURNAL_MAX_REF_COUNT ((unsigned long) 4096)
>
> +/* Note: =A0Do not use this for NULL handles. =A0This is only to det=
ermine if
> + * a properly allocated handle is using a journal or not. */
> =A0static inline int ext4_handle_valid(handle_t *handle)
> =A0{
> - =A0 =A0 =A0 if (handle =3D=3D EXT4_NOJOURNAL_HANDLE)
> + =A0 =A0 =A0 if ((unsigned long)handle < EXT4_NOJOURNAL_MAX_REF_COUN=
T)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 0;
> =A0 =A0 =A0 =A0return 1;
> =A0}
> diff -uprN orig/fs/ext4/inode.c new/fs/ext4/inode.c
> --- orig/fs/ext4/inode.c =A0 =A0 =A0 =A02009-09-18 14:04:15.000000000=
 -0700
> +++ new/fs/ext4/inode.c 2009-09-18 14:17:31.000000000 -0700
> @@ -4931,12 +4931,14 @@ int ext4_write_inode(struct inode *inode
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0err =3D ext4_force_commit(inode->i_sb)=
;
> =A0 =A0 =A0 =A0} else {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct ext4_iloc iloc;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 handle_t *handle =3D ext4_journal_start=
(inode, 1);
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0err =3D ext4_get_inode_loc(inode, &ilo=
c);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (err)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return err;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D ext4_do_update_inode(EXT4_NOJOU=
RNAL_HANDLE,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0inode, &iloc, wait);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D ext4_do_update_inode(handle, in=
ode, &iloc, wait);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_journal_stop(handle);
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0return err;
> =A0}
> diff -uprN orig/fs/ext4/namei.c new/fs/ext4/namei.c
> --- orig/fs/ext4/namei.c =A0 =A0 =A0 =A02009-09-18 14:04:15.000000000=
 -0700
> +++ new/fs/ext4/namei.c 2009-09-18 14:17:31.000000000 -0700
> @@ -2076,7 +2076,8 @@ int ext4_orphan_del(handle_t *handle, st
> =A0 =A0 =A0 =A0struct ext4_iloc iloc;
> =A0 =A0 =A0 =A0int err =3D 0;
>
> - =A0 =A0 =A0 if (!ext4_handle_valid(handle))
> + =A0 =A0 =A0 /* ext4_handle_valid() assumes a valid handle_t pointer=
 */
> + =A0 =A0 =A0 if (handle && !ext4_handle_valid(handle))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 0;
>
> =A0 =A0 =A0 =A0mutex_lock(&EXT4_SB(inode->i_sb)->s_orphan_lock);
> diff -uprN orig/fs/ext4/super.c new/fs/ext4/super.c
> --- orig/fs/ext4/super.c =A0 =A0 =A0 =A02009-09-18 14:04:15.000000000=
 -0700
> +++ new/fs/ext4/super.c 2009-09-18 14:17:31.000000000 -0700
> @@ -198,6 +198,36 @@ void ext4_itable_unused_set(struct super
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bg->bg_itable_unused_hi =3D cpu_to_le1=
6(count >> 16);
> =A0}
>
> +
> +/* Just increment the non-pointer handle value */
> +static handle_t *ext4_get_nojournal(void)
> +{
> + =A0 =A0 =A0 handle_t *handle =3D current->journal_info;
> + =A0 =A0 =A0 unsigned long ref_cnt =3D (unsigned long)handle;
> +
> + =A0 =A0 =A0 BUG_ON(ref_cnt >=3D EXT4_NOJOURNAL_MAX_REF_COUNT);
> +
> + =A0 =A0 =A0 ref_cnt++;
> + =A0 =A0 =A0 handle =3D (handle_t *)ref_cnt;
> +
> + =A0 =A0 =A0 current->journal_info =3D handle;
> + =A0 =A0 =A0 return handle;
> +}
> +
> +
> +/* Decrement the non-pointer handle value */
> +static void ext4_put_nojournal(handle_t *handle)
> +{
> + =A0 =A0 =A0 unsigned long ref_cnt =3D (unsigned long)handle;
> +
> + =A0 =A0 =A0 BUG_ON(ref_cnt =3D=3D 0);
> +
> + =A0 =A0 =A0 ref_cnt--;
> + =A0 =A0 =A0 handle =3D (handle_t *)ref_cnt;
> +
> + =A0 =A0 =A0 current->journal_info =3D handle;
> +}
> +
> =A0/*
> =A0* Wrappers for jbd2_journal_start/end.
> =A0*
> @@ -224,11 +254,7 @@ handle_t *ext4_journal_start_sb(struct s
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return jbd2_journal_start(journal, nbl=
ocks);
> =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 /*
> - =A0 =A0 =A0 =A0* We're not journaling, return the appropriate indic=
ation.
> - =A0 =A0 =A0 =A0*/
> - =A0 =A0 =A0 current->journal_info =3D EXT4_NOJOURNAL_HANDLE;
> - =A0 =A0 =A0 return current->journal_info;
> + =A0 =A0 =A0 return ext4_get_nojournal();
> =A0}
>
> =A0/*
> @@ -244,11 +270,7 @@ int __ext4_journal_stop(const char *wher
> =A0 =A0 =A0 =A0int rc;
>
> =A0 =A0 =A0 =A0if (!ext4_handle_valid(handle)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* Do this here since we don't call j=
bd2_journal_stop() in
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* no-journal mode.
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 current->journal_info =3D NULL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_put_nojournal(handle);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 0;
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0sb =3D handle->h_transaction->t_journal->j_private;
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
