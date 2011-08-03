From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext3: fix message in ext3_remount for rw-remount case
Date: Wed, 3 Aug 2011 11:57:54 +0200
Message-ID: <20110803095754.GA5047@quack.suse.cz>
References: <20110801135451.cb73c981.toshi.okajima@jp.fujitsu.com>
 <20110801084526.GB6522@quack.suse.cz>
 <4E3675D6.3010201@jp.fujitsu.com>
 <20110801095731.GI6522@quack.suse.cz>
 <4E37BFEA.7020601@jp.fujitsu.com>
 <4E38B57B.4050304@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, akpm@linux-foundation.org,
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
To: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48962 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753197Ab1HCJ6I (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Aug 2011 05:58:08 -0400
Content-Disposition: inline
In-Reply-To: <4E38B57B.4050304@jp.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello,

On Wed 03-08-11 11:42:03, Toshiyuki Okajima wrote:
> >(2011/08/01 18:57), Jan Kara wrote:
> >>On Mon 01-08-11 18:45:58, Toshiyuki Okajima wrote:
> >>>(2011/08/01 17:45), Jan Kara wrote:
> >>>>On Mon 01-08-11 13:54:51, Toshiyuki Okajima wrote:
> >>>>>If there are some inodes in orphan list while a filesystem is be=
ing
> >>>>>read-only mounted, we should recommend that pepole umount and th=
en
> >>>>>mount it when they try to remount with read-write. But the curre=
nt
> >>>>>message/comment recommends that they umount and then remount it.
> <SNIP>
> >>>>the most... BTW, I guess you didn't really see this message in pr=
actice, did
> >>>>you?
> >>>No.
> >>>I have seen this message in practice while quotacheck command was =
repeatedly
> >>>executed per an hour.
> >>Interesting. Are you able to reproduce this? Quotacheck does remoun=
t
> >>read-only + remount read-write but you cannot really remount the fi=
lesystem
> >>read-only when it has orphan inodes and so you should not see those=
 when
> >>you remount read-write again. Possibly there's race between remount=
ing and
> >>unlinking...
> >Yes. I can reproduce it. However, it is not frequently reproduced
> >by using the original procedure (qutacheck per an hour). So, I made =
a
> >reproducer.
> To tell the truth, I think the race creates the message:
> ---------------------------------------------------------------------=
--
>  EXT3-fs: <dev>: couldn't remount RDWR because of
>  =E3=80=80=E3=80=80=E3=80=80 =E3=80=80unprocessed orphan inode list. =
 Please umount/remount instead.
> ---------------------------------------------------------------------=
--
> which hides a serious problem.
  I've inquired about this at linux-fsdevel (I think you were in CC unl=
ess
I forgot). It's a race in VFS remount code as you properly analyzed bel=
ow.
People are working on fixing it but it's not trivial. Filesystem is rea=
lly
a wrong place to fix such problem. If there is a trivial fix for ext3 t=
o
workaround the issue, I can take it but I'm not willing to push anythin=
g
complex - effort should better be spent working on a generic fix.

								Honza

> By using my reproducer, I found that it can show another message that
> is not the above mentioned message:
> ---------------------------------------------------------------------=
--
> EXT3-fs error (device <dev>) in start_transaction: Readonly filesyste=
m=09
> ---------------------------------------------------------------------=
--
> After I examined the code path which message could display, I found
> it can display if the following steps are satisfied:
>=20
> [[CASE 1]]
> ( 1)  [process A] do_unlinkat
> ( 2)  [process B] do_remount_sb(, RDONLY, )
> ( 3)  [process A]  vfs_unlink
> ( 4)  [process A]   ext3_unlink
> ( 5)  [process A]    ext3_journal_start
> ( 6)  [process B]  fs_may_remount_ro   (=3D> return 0)
> ( 7)  [process A]    inode->i_nlink-- (i_nlink=3D0)
> ( 8)  [process A]    ext3_orphan_add
> ( 9)  [process A]    ext3_journal_stop
> (10)  [process A]  dput
> (11)  [process A]   iput
> (12)  [process A]    ext3_evict_inode
> (13)  [process B]  ext3_remount
> (14)  [process A]     start_transaction
> (15)  [process B]   sb->s_flags |=3D MS_RDONLY
> (16)  [process B]   ext3_mark_recovery_complete
> (17)  [process A]      start_this_handle (new transaction is created)
> (18)  [process A]     ext3_truncate
> (19)  [process A]      start_transaction (failed =3D> this message is=
 displayed)
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^=
^^^^^^^^^
> (20)  [process A]     ext3_orphan_del
> (21)  [process A]     ext3_journal_stop
>=20
> * "Process A" deletes a file successfully(21). However the file data =
is left
>    because (18) fails. **Furthermore, new transaction can be created =
after
>    ext3_mark_recovery_complete finishes.**
>=20
> [[CASE2]]
> ( 1)  [process A] do_unlinkat
> ( 2)  [process B] do_remount_sb(, RDONLY, )
> ( 3)  [process A]  vfs_unlink
> ( 4)  [process A]   ext3_unlink
> ( 5)  [process A]    ext3_journal_start
> ( 6)  [process B]  fs_may_remount_ro   (=3D> return 0)
> ( 7)  [process A]    inode->i_nlink-- (i_nlink=3D0)
> ( 8)  [process A]    ext3_orphan_add
> ( 9)  [process A]    ext3_journal_stop
> (10)  [process A]  dput
> (11)  [process A]   iput
> (12)  [process A]    ext3_evict_inode
> (13)  [process B]  ext3_remount
> (14)  [process A]     start_transaction
> (15)  [process B]   sb->s_flags |=3D MS_RDONLY
> (17)  [process A]      start_this_handle (new transaction is created)
> (18)  [process A]     ext3_truncate
> (19)  [process A]      start_transaction (failed =3D> this message is=
 displayed)
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^=
^^^^^^^^^
> (20)  [process A]     ext3_orphan_del
> (21)  [process A]     ext3_journal_stop
> (22)  [process B]   ext3_mark_recovery_complete
>=20
> * "Process A" deletes a file successfully(21). However the file data =
is left
>    because (18) fails. This transaction can finish before
>    ext3_mark_recovery_complete finishes.
>=20
> I will try to fix this problem not to do with fs-error.
> Please comment about the fix if I have created one.
>=20
> Thanks,
> Toshiyuki Okajima
>=20
--=20
Jan Kara <jack@suse.cz>
SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
