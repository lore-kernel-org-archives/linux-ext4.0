From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [LSF/FS TOPIC] Ext4 snapshots status update
Date: Wed, 30 Mar 2011 14:08:50 +0200
Message-ID: <AANLkTim+7hUX0rsusDTvBNGKOU6bwA=8AGT9EM1+z7hu@mail.gmail.com>
References: <AANLkTink6o249JivXiETT6JnANNcikNqGGfr8+McDQsM@mail.gmail.com>
	<20110204002043.GA15658@noexit>
	<AANLkTimuR-oOprBR7Xkehx01ojrdxYOmgqdnX7wNbpt6@mail.gmail.com>
	<20110330003429.GA32669@noexit>
	<AANLkTi=vReDmq22=kKieJp9uaeAVC-VXj8VjHWQfXaDp@mail.gmail.com>
	<1301485711-sup-3080@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Joel Becker <jlbec@evilplan.org>,
	lsf-pc <lsf-pc@lists.linuxfoundation.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Theodore Tso <tytso@mit.edu>, Josef Bacik <josef@redhat.com>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:52025 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754285Ab1C3MIw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 30 Mar 2011 08:08:52 -0400
In-Reply-To: <1301485711-sup-3080@think>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 30, 2011 at 1:50 PM, Chris Mason <chris.mason@oracle.com> w=
rote:
> Excerpts from Amir Goldstein's message of 2011-03-30 00:16:45 -0400:
>> On Wed, Mar 30, 2011 at 2:34 AM, Joel Becker <jlbec@evilplan.org> wr=
ote:
>> > On Wed, Mar 23, 2011 at 10:19:38PM +0200, Amir Goldstein wrote:
>> >> On Fri, Feb 4, 2011 at 2:20 AM, Joel Becker <jlbec@evilplan.org> =
wrote:
>> >> > On Fri, Feb 04, 2011 at 12:33:39AM +0200, Amir Goldstein wrote:
>> >> > =A0 =A0 =A0 =A0I've already got a design for a front-end snapsh=
ot program that
>> >> > implements a policy on top this generic behavior. =A0This desig=
n would
>> >> > cover both first-class and hidden style snapshots, because it a=
ssume
>> >> > snapshots are in a distinct namespace. =A0I haven't gotten arou=
nd to
>> >> > implementing it yet, but btrfs and other snapshottable filesyst=
ems were
>> >> > part of the design goal.
>> >>
>> >> Any chance of getting a copy of that design of yours, to get a he=
ad start
>> >> for LSF?
>> >
>> > =A0 =A0 =A0 =A0Yeah, I owe it to you. =A0It wasn't a written-down =
thing, it was a
>> > hammered-out-in-our-heads thing among some ocfs2 developers. =A0I'=
m going
>> > to braindump here to get us going. =A0First, I'll speak to your po=
ints.
>> >
>> >> Here are some other generic snapshot related topics we may want t=
o discuss:
>> >>
>> >> 1. Collaborating the use of inode flags COW_FL, NOCOW_FL, suggest=
ed by Chris.
>> >
>> > =A0 =A0 =A0 =A0I'm unsure where these fit, perhaps because I misse=
d the
>> > discussion between Chris and you. =A0ocfs2 has the inode flag
>> > OCFS2_REFCOUNTED_FL to signify a refcount tree is attached to the =
inode.
>> > This is ocfs2's structure for maintaining extent reference counts.=
 =A0Is
>> > your COW_FL the same? =A0Or is it a permission flag? =A0NOCOW_FL s=
ounds
>> > like: "Set this flag on the inode and it will prevent CoW."
>>
>> I don't have a use for COW_FL, since my snapshots are volume level s=
napshots.
>> I intend to use NOCOW_FL to mark an inode as an "island" of NOCOW
>> blocks in the volume.
>> Maybe Chris or Josef can elaborate of the flags intended use in btrf=
s.
>
> NOWCOW_FL in btrfs means to directly overwrite blocks (and not do crc=
s)
> unless the block has another reference. =A0If there is another refere=
nce,
> we COW once to honor the snapshot and then continue in NOCOW mode.
>
> I'm kind of worried about your NOCOW island idea, maybe we can talk m=
ore
> about that next week. =A0It seems like it will lead to a lot of admin
> surprises.
>

Yes, that's something to talk about.
My desire for NOCOW comes from lack of sub volume granularity
in ext4 snapshots.

My NOCOW design states that NOCOW flag cannot be toggled on a regular f=
ile.
like a snapshot file, a NOCOW file must be born and die NOCOW, to avoid
admin surprises. NOCOW directories (which ARE COWed) are were NOCOW
files are born.

Using this scheme, an admin can exclude->include->exclude directory sub=
 trees
from snapshots.

Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
