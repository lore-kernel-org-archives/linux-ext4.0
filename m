From: Jan Kara <jack@suse.cz>
Subject: Re: [BUG] ext3: cannot unfreeze a filesystem due to a deadlock
Date: Thu, 8 Sep 2011 00:32:08 +0200
Message-ID: <20110907223208.GH7725@quack.suse.cz>
References: <20110907122929.3715.61FB500B@jp.fujitsu.com>
 <20110907173444.GF7725@quack.suse.cz>
 <CAGpXXZ+JdCXv3K4ASWhum=iW7TTQ+k0HYBHkQNnVWVQ7j-Wtrg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>,
	Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Valerie Aurora <val@vaaconsulting.com>
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57583 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756943Ab1IGWcL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 7 Sep 2011 18:32:11 -0400
Content-Disposition: inline
In-Reply-To: <CAGpXXZ+JdCXv3K4ASWhum=iW7TTQ+k0HYBHkQNnVWVQ7j-Wtrg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 07-09-11 13:56:08, Greg Freemyer wrote:
> On Wed, Sep 7, 2011 at 1:34 PM, Jan Kara <jack@suse.cz> wrote:
> > =A0Hello,
> >
> > =A0Thanks for report!
> >
> > On Wed 07-09-11 12:29:30, Masayoshi MIZUMA wrote:
> >> When I checked the freeze feature for ext3 filesystem using fsfree=
ze
> >> command at 3.1.0-rc4, I think the following deadlock problem happe=
ned.
> >>
> >> How to reproduce:
> >> =A0# mkfs -t ext3 /dev/sdd1
> >> =A0# mount /dev/sdd1 /MNT
> >> =A0# ./fsstress -d /MNT/tmp -n 10 -p 1000 > /dev/null 2>&1 &
> >> =A0# fsfreeze -f /MNT
> >> =A0# fsfreeze -u /MNT
> >>
> >> =A0If this deadlock is reproduced, "fsfreeze -u /MNT" does not ret=
urn.
> >>
> >> The detail of deadlock:
> >> o [flush-8:16:1523]
> >> =A0 wb_do_writeback
> >> =A0 =A0wb_writeback
> >> =A0 =A0...
> >> =A0 =A0 =A0ext3_journalled_writepage
> >> =A0 =A0 =A0 journal_start
> >> =A0 =A0 =A0 =A0start_this_handle
> >> =A0 =A0 =A0 =A0# waiting until journal->j_barrier_count turns 0...
> >> =A0 =A0 =A0 =A0# j_barrier_count was incremented by journal_lock_u=
pdates()
> >> =A0 =A0 =A0 =A0# via ext3_freeze().
> >>
> >> o [fsstress:2673]
> >> =A0 sys_sync
> >> =A0 =A0sync_filesystems
> >> =A0 =A0 iterate_supers
> >> =A0 =A0 =A0down_read(sb->s_umount)
> >> =A0 =A0 =A0sync_one_sb
> >> =A0 =A0 =A0 __sync_filesystem
> >> =A0 =A0 =A0 =A0writeback_inodes_sb
> >> =A0 =A0 =A0 =A0 writeback_inodes_sb_nr
> >> =A0 =A0 =A0 =A0 =A0wait_for_completion
> >> =A0 =A0 =A0 =A0 =A0 wait_for_common
> >> =A0 =A0 =A0 =A0 =A0 # waiting for completion of [flush-8:16:1523].=
=2E.
> >>
> >> o [fsfreeze:2749]
> >> =A0 sys_ioctl
> >> =A0 =A0do_vfs_ioctl
> >> =A0 =A0 thaw_super
> >> =A0 =A0 # waiting for down_write(sb->s_umount)...
> >> =A0 =A0 # [fsfreeze:2673] did down_read(sb->s_umount).
> > =A0Yes, this is a classical deadlock that can happen for any filesy=
stem. The
> > problem is flusher thread holds s_umount semaphore (either directly=
, or as
> > in your case, indirectly via blocked sync) and tries to do some IO =
which
> > blocks on frozen filesystem. It's particularly easy to hit for ext3=
 because
> > it doesn't do vfs_check_frozen() checks but all other filesystems h=
ave the
> > race window as well. Val Henson is working on fixing the problem - =
she even
> > has some first version of patches I believe.
> >
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Honza
>=20
> xfstests test 068 has been around since kernel 2.4 days and should
> have caught it if xfs is impacted.
>=20
> I know I ran the 2002 version many times to prove to myself that
> fsfreeze for xfs was stable when teamed with LVM.  (It wasn't when I
> first wrote 068 way back then).
>=20
> 068 has been greatly simplified since 2002, but it still looks like i=
t
> should do a good job.
>=20
> Is there a problem with 068?  Does it need extra test coverage even f=
or xfs?
  I believe at least mmapped writes can trigger the deadlock even for x=
fs
and fsstress (slightly surprisingly) does not test that. It's a narrow =
race
window but it is there and it has been triggered in practice (for ext4 =
but
it's a race in VFS code used by both XFS and ext4). So maybe extending
fsstress would be a way to go?

								Honza
--=20
Jan Kara <jack@suse.cz>
SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
