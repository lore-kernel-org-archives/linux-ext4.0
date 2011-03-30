From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [LSF/FS TOPIC] Ext4 snapshots status update
Date: Wed, 30 Mar 2011 07:50:15 -0400
Message-ID: <1301485711-sup-3080@think>
References: <AANLkTink6o249JivXiETT6JnANNcikNqGGfr8+McDQsM@mail.gmail.com> <20110204002043.GA15658@noexit> <AANLkTimuR-oOprBR7Xkehx01ojrdxYOmgqdnX7wNbpt6@mail.gmail.com> <20110330003429.GA32669@noexit> <AANLkTi=vReDmq22=kKieJp9uaeAVC-VXj8VjHWQfXaDp@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Joel Becker <jlbec@evilplan.org>,
	lsf-pc <lsf-pc@lists.linuxfoundation.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Theodore Tso <tytso@mit.edu>, Josef Bacik <josef@redhat.com>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:26895 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754852Ab1C3Lvg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 30 Mar 2011 07:51:36 -0400
In-reply-to: <AANLkTi=vReDmq22=kKieJp9uaeAVC-VXj8VjHWQfXaDp@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Excerpts from Amir Goldstein's message of 2011-03-30 00:16:45 -0400:
> On Wed, Mar 30, 2011 at 2:34 AM, Joel Becker <jlbec@evilplan.org> wro=
te:
> > On Wed, Mar 23, 2011 at 10:19:38PM +0200, Amir Goldstein wrote:
> >> On Fri, Feb 4, 2011 at 2:20 AM, Joel Becker <jlbec@evilplan.org> w=
rote:
> >> > On Fri, Feb 04, 2011 at 12:33:39AM +0200, Amir Goldstein wrote:
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0I've already got a design for a front=
-end snapshot program that
> >> > implements a policy on top this generic behavior. =C2=A0This des=
ign would
> >> > cover both first-class and hidden style snapshots, because it as=
sume
> >> > snapshots are in a distinct namespace. =C2=A0I haven't gotten ar=
ound to
> >> > implementing it yet, but btrfs and other snapshottable filesyste=
ms were
> >> > part of the design goal.
> >>
> >> Any chance of getting a copy of that design of yours, to get a hea=
d start
> >> for LSF?
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0Yeah, I owe it to you. =C2=A0It wasn't a=
 written-down thing, it was a
> > hammered-out-in-our-heads thing among some ocfs2 developers. =C2=A0=
I'm going
> > to braindump here to get us going. =C2=A0First, I'll speak to your =
points.
> >
> >> Here are some other generic snapshot related topics we may want to=
 discuss:
> >>
> >> 1. Collaborating the use of inode flags COW_FL, NOCOW_FL, suggeste=
d by Chris.
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0I'm unsure where these fit, perhaps beca=
use I missed the
> > discussion between Chris and you. =C2=A0ocfs2 has the inode flag
> > OCFS2_REFCOUNTED_FL to signify a refcount tree is attached to the i=
node.
> > This is ocfs2's structure for maintaining extent reference counts. =
=C2=A0Is
> > your COW_FL the same? =C2=A0Or is it a permission flag? =C2=A0NOCOW=
_FL sounds
> > like: "Set this flag on the inode and it will prevent CoW."
>=20
> I don't have a use for COW_FL, since my snapshots are volume level sn=
apshots.
> I intend to use NOCOW_FL to mark an inode as an "island" of NOCOW
> blocks in the volume.
> Maybe Chris or Josef can elaborate of the flags intended use in btrfs=
=2E

NOWCOW_FL in btrfs means to directly overwrite blocks (and not do crcs)
unless the block has another reference.  If there is another reference,
we COW once to honor the snapshot and then continue in NOCOW mode.

I'm kind of worried about your NOCOW island idea, maybe we can talk mor=
e
about that next week.  It seems like it will lead to a lot of admin
surprises.

-chris
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
