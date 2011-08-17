From: Jan Kara <jack@suse.cz>
Subject: Re: DIO process stuck apparently due to dioread_nolock (3.0)
Date: Wed, 17 Aug 2011 11:04:15 +0200
Message-ID: <20110817090415.GA9959@quack.suse.cz>
References: <4E48390E.9050102@msgid.tls.msk.ru>
 <4E488625.609@tao.ma>
 <4E48D231.5060807@msgid.tls.msk.ru>
 <4E48DF31.4050603@msgid.tls.msk.ru>
 <CAFgt=MAfbU_muEzmxx-8CK8w7=nGR5dUZSgBQ1dN6XkyrTbO9g@mail.gmail.com>
 <20110816135325.GD23416@quack.suse.cz>
 <4E4A86D0.2070300@tao.ma>
 <CAFgt=MCQttE5Vv_4W=hFWU_L_FvELnY6bnFQ3uSOu07VkDm6rA@mail.gmail.com>
 <20110816235901.GL26978@dastard>
 <CAFgt=MD4EmeEXNQGinMJHyZ-DOoWPnBbYdzdcw2YRm+yYjodpw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Dave Chinner <david@fromorbit.com>, Tao Ma <tm@tao.ma>,
	Jan Kara <jack@suse.cz>, Michael Tokarev <mjt@tls.msk.ru>,
	linux-ext4@vger.kernel.org, sandeen@redhat.com
To: Jiaying Zhang <jiayingz@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37367 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751187Ab1HQJEc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 17 Aug 2011 05:04:32 -0400
Content-Disposition: inline
In-Reply-To: <CAFgt=MD4EmeEXNQGinMJHyZ-DOoWPnBbYdzdcw2YRm+yYjodpw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 16-08-11 17:08:42, Jiaying Zhang wrote:
> On Tue, Aug 16, 2011 at 4:59 PM, Dave Chinner <david@fromorbit.com> w=
rote:
> > On Tue, Aug 16, 2011 at 02:32:12PM -0700, Jiaying Zhang wrote:
> >> On Tue, Aug 16, 2011 at 8:03 AM, Tao Ma <tm@tao.ma> wrote:
> >> > On 08/16/2011 09:53 PM, Jan Kara wrote:
> >> I wonder whether the following patch will solve the problem:
> >>
> >> diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
> >> index 6c27111..ca90d73 100644
> >> --- a/fs/ext4/indirect.c
> >> +++ b/fs/ext4/indirect.c
> >> @@ -800,12 +800,17 @@ ssize_t ext4_ind_direct_IO(int rw, struct ki=
ocb *iocb,
> >> =A0 =A0 =A0 =A0 }
> >>
> >> =A0retry:
> >> - =A0 =A0 =A0 if (rw =3D=3D READ && ext4_should_dioread_nolock(ino=
de))
> >> + =A0 =A0 =A0 if (rw =3D=3D READ && ext4_should_dioread_nolock(ino=
de)) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (unlikely(!list_empty(&ei->i_comp=
leted_io_list))) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mutex_lock(&inode->i=
_mutex);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_flush_completed=
_IO(inode);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mutex_unlock(&inode-=
>i_mutex);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D __blockdev_direct_IO(rw, i=
ocb, inode,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
inode->i_sb->s_bdev, iov,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
offset, nr_segs,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
ext4_get_block, NULL, NULL, 0);
> >> - =A0 =A0 =A0 else {
> >> + =A0 =A0 =A0 } else {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D blockdev_direct_IO(rw, ioc=
b, inode,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
inode->i_sb->s_bdev, iov,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
offset, nr_segs,
> >>
> >> I tested the patch a little bit and it seems to resolve the race
> >> on dioread_nolock in my case. Michael, I would very appreciate
> >> if you can try this patch with your test case and see whether it w=
orks.
> >
> > Just my 2c worth here: this is a data corruption bug so the root
> > cause neeeds to be fixed. The above patch does not address the root
> > cause.
> >
> >> > You are absolutely right. The really problem is that ext4_direct=
_IO
> >> > begins to work *after* we clear the page writeback flag and *bef=
ore* we
> >> > convert unwritten extent to a valid state. Some of my trace does=
 show
> >> > that. I am working on it now.
> >
> > And that's the root cause - think about what that means for a
> > minute. =A0It means that extent conversion can race with anything t=
hat
> > requires IO to complete first. e.g. truncate or fsync. =A0It can th=
en
> > race with other subsequent operations, which can have even nastier
> > effects. IOWs, there is a data-corruption landmine just sitting
> > there waiting for the next person to trip over it.
> You are right that extent conversion can race with truncate and fsync
> as well. That is why we already need to call ext4_flush_completed_IO(=
)
> in those places as well. I agree this is a little nasty and there can=
 be
> some other corner cases that we haven't covered.
  Exactly. I agree with Dave here that it is asking for serious trouble=
 to
clear PageWriteback bit before really completing the IO.=20

> The problem is we can not do extent conversion during the end_io time=
=2E I
> haven't thought of a better approach to deal with these races. I am
> curious how xfs deals with this problem.
  Well, XFS cannot do extent conversion in end_io for AIO+DIO either. S=
o it
clears PageWriteback bit only after extent conversion has happened in t=
he
worker thread. ext4 has problems with this (deadlocks) because of unluc=
ky
locking of extent tree using i_mutex. So I believe we have to find a be=
tter
locking for extent tree so that ext4 can clear PageWriteback bit from t=
he
worker thread...

								Honza
--=20
Jan Kara <jack@suse.cz>
SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
