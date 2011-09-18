From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH 1/3] VFS: Fix s_umount thaw/write deadlock
Date: Mon, 19 Sep 2011 09:25:17 +1000
Message-ID: <20110918232517.GG15688@dastard>
References: <CAD-Xujmjai2evYC4a4CdNPtjh_9xhbELcZePtGSS54VPRGpznA@mail.gmail.com>
 <CAD-Xujm87Aj6y09GRXPVMZM+9N_7wyte-YNp7t0Wi3R2qH2mHQ@mail.gmail.com>
 <20110914140047.GB7903@quack.suse.cz>
 <CAD-Xuj=XnUBQ=-gmrdaBj6ABJei25ELR-Mg1XMRw4wEL=JwWcQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
	Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>,
	Greg Freemyer <greg.freemyer@gmail.com>,
	linux-ext4@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>
To: Valerie Aurora <val@vaaconsulting.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:16700 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932770Ab1IRXZg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 18 Sep 2011 19:25:36 -0400
Content-Disposition: inline
In-Reply-To: <CAD-Xuj=XnUBQ=-gmrdaBj6ABJei25ELR-Mg1XMRw4wEL=JwWcQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 14, 2011 at 04:53:38PM -0700, Valerie Aurora wrote:
> On Wed, Sep 14, 2011 at 7:00 AM, Jan Kara <jack@suse.cz> wrote:
> > On Mon 12-09-11 19:57:11, Valerie Aurora wrote:
> >> Val, if you are sending patches as attachments, make them at least
> >> text/plain please!
>=20
> Oops, sorry.
>=20
> >> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> >> index 04cf3b9..d1dca03 100644
> >> --- a/fs/fs-writeback.c
> >> +++ b/fs/fs-writeback.c
> >> @@ -537,6 +537,9 @@ static long writeback_sb_inodes(struct super_b=
lock *sb,
> >> =A0 =A0 =A0 long write_chunk;
> >> =A0 =A0 =A0 long wrote =3D 0; =A0/* count both pages and inodes */
> >>
> >> + =A0 =A0 if (vfs_is_frozen(sb))
> >> + =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> >> +
> > =A0Umm, maybe we could make this more robust by skipping the superb=
lock in
> > __writeback_inodes_wb() and just explicitely stopping the writeback=
 when
> > work->sb is set (i.e. writeback is required only for frozen sb) in
> > wb_writeback()?
>=20
> Sorry, I don't quite understand what the goal is here?  I'm happy to
> make the change, just want to make sure I'm accomplishing what you
> want.
>=20
> >> =A0 =A0 =A0 while (!list_empty(&wb->b_io)) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct inode *inode =3D wb_inode(wb->b=
_io.prev);
> >>
> >> @@ -1238,39 +1241,43 @@ EXPORT_SYMBOL(writeback_inodes_sb);
> >> =A0 * writeback_inodes_sb_if_idle =A0 =A0 =A0 - =A0 =A0 =A0 start =
writeback if none underway
> >> =A0 * @sb: the superblock
> >> =A0 *
> >> - * Invoke writeback_inodes_sb if no writeback is currently underw=
ay.
> >> - * Returns 1 if writeback was started, 0 if not.
> >> + * Invoke writeback_inodes_sb if no writeback is currently underw=
ay
> >> + * and no one else holds the s_umount lock. =A0Returns 1 if write=
back
> >> + * was started, 0 if not.
> >> =A0 */
> >> =A0int writeback_inodes_sb_if_idle(struct super_block *sb)
> >> =A0{
> >> =A0 =A0 =A0 if (!writeback_in_progress(sb->s_bdi)) {
> >> - =A0 =A0 =A0 =A0 =A0 =A0 down_read(&sb->s_umount);
> >> - =A0 =A0 =A0 =A0 =A0 =A0 writeback_inodes_sb(sb);
> >> - =A0 =A0 =A0 =A0 =A0 =A0 up_read(&sb->s_umount);
> >> - =A0 =A0 =A0 =A0 =A0 =A0 return 1;
> >> - =A0 =A0 } else
> >> - =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 if (down_read_trylock(&sb->s_umount)) {
> > =A0What's exactly the deadlock trylock protects from here? Or is it=
 just an
> > optimization?
>=20
> The trylock is an optimization Dave Chinner suggested.  The first
> version I wrote acquired the lock and then checked vfs_is_frozen().

It's not so much an optimisation, but the general case of avoiding
read-write deadlocks such that freezing can trigger. I think remount
can trigger the same deadlock as freezing, so the trylock avoids both
deadlock cases rather than just working around the freeze problem....

Cheers,

Dave.
--=20
Dave Chinner
david@fromorbit.com
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
