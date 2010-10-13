From: "Amir G." <amir73il@users.sourceforge.net>
Subject: Re: [PATCH RFC 0/3] Block reservation for ext3
Date: Wed, 13 Oct 2010 10:49:15 +0200
Message-ID: <AANLkTinD=EE0yYFzBHdvu-fKCQhfMH+DetekHWd-RZc7@mail.gmail.com>
References: <1286583147-14760-1-git-send-email-jack@suse.cz>
	<20101009180357.GG18454@thunk.org>
	<20101011142813.GC3830@quack.suse.cz>
	<20101011145945.166695e3.akpm@linux-foundation.org>
	<20101012231408.GC3812@quack.suse.cz>
	<AANLkTimqbW7+wsXVoLa1Tx0K3VaDfrYKUE8owyD1VUxO@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Theodore Tso <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:53014 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308Ab0JMItR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Oct 2010 04:49:17 -0400
Received: by qyk2 with SMTP id 2so477164qyk.19
        for <linux-ext4@vger.kernel.org>; Wed, 13 Oct 2010 01:49:16 -0700 (PDT)
In-Reply-To: <AANLkTimqbW7+wsXVoLa1Tx0K3VaDfrYKUE8owyD1VUxO@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

---------- Forwarded message ----------
=46rom: Amir Goldstein <amir73il@gmail.com>
Date: Wed, Oct 13, 2010 at 10:44 AM
Subject: Re: [PATCH RFC 0/3] Block reservation for ext3
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ted Ts'o
<tytso@mit.edu>, linux-ext4@vger.kernel.org




On Wed, Oct 13, 2010 at 1:14 AM, Jan Kara <jack@suse.cz> wrote:
>
> On Mon 11-10-10 14:59:45, Andrew Morton wrote:
> > On Mon, 11 Oct 2010 16:28:13 +0200=C2=A0Jan Kara <jack@suse.cz> wro=
te:
> >
> > > =C2=A0 Doing allocation at mmap time does not really work - on ea=
ch mmap we
> > > would have to map blocks for the whole file which would make mmap=
 really
> > > expensive operation. Doing it at page-fault as you suggest in (2a=
) works
> > > (that's the second plausible option IMO) but the increased fragme=
ntation
> > > and thus loss of performance is rather noticeable. I don't have c=
urrent
> > > numbers but when I tried that last year Berkeley DB was like two =
or three
> > > times slower.
> >
> > ouch.
> >
> > Can we fix the layout problem? =C2=A0Are reservation windows of no =
use here?
> =C2=A0Reservation windows do not work for this load. The reason is th=
at the
> page-fault order is completely random so we just spend time creating =
and
> removing tiny reservation windows because the next page fault doing
> allocation is scarcely close enough to fall into the small window.
> =C2=A0The logic in ext3_find_goal() ends up picking blocks close toge=
ther for
> blocks belonging to the same indirect block if we are lucky but they
> definitely won't be sequentially ordered. For Berkeley DB the situati=
on is
> made worse by the fact that there are several database files and thei=
r
> blocks end up interleaved.
> =C2=A0So we could improve the layout but we'd have to tweak the reser=
vation
> logic and allocator and it's not completely clear to me how.
> =C2=A0One thing to note is that currently, ext3 *is* in fact doing de=
layed
> allocation for writes via mmap. We just never called it like that and=
 never
> bothered to do proper space estimation...
>
> > > > 3) Keep a global counter of sparse blocks which are mapped at m=
map()
> > > > time, and update it as blocks are allocated, or when the region=
 is
> > > > freed at munmap() time.
> > > =C2=A0 Here again I see the problem that mapping all file blocks =
at mmap time
> > > is rather expensive and so does not seem viable to me. Also the
> > > overestimation of needed blocks could be rather huge.
> >
> > When I did ext2 delayed allocation back in, err, 2001 I had
> > considerable trouble working out how many blocks to actually reserv=
e
> > for a file block, because it also had to reserve the indirect block=
s.
> > One file block allocation can result in reserving four disk blocks!
> > And iirc it was not possible with existing in-core data structures =
to
> > work out whether all four blocks needed reserving until the actual
> > block allocation had occurred. =C2=A0So I ended up reserving the wo=
rst-case
> > number of indirects, based upon the file offset. =C2=A0If the disk =
ran out
> > of "space" I'd do a forced writeback to empty all the reservations =
and
> > would then take a look to see if the disk was _really_ out of space=
=2E
> >
> > Is all of this an issue with this work? =C2=A0If so, what approach =
did you
> > take?
> =C2=A0Yeah, I've spotted exactly the same problem. How I decided to s=
olve it in
> the end is that in memory we keep track of each indirect block that h=
as
> delay-allocated buffer under it. This allows us to reserve space for =
each
> indirect block at most once (I didn't bother with making the accounti=
ng
> precise for double or triple indirect blocks so when I need to reserv=
e
> space for indirect block, I reserve the whole path just to be sure). =
This
> pushes the error in estimation to rather acceptable range for reasona=
bly
> common workloads - the error can still be 50% for workloads which use=
 just
> one data block in each indirect block but even in this case the absol=
ute
> number of blocks falsely reserved is small.
> =C2=A0The cost is of course increased complexity of the code, the mem=
ory
> spent for tracking those indirect blocks (32 bytes per indirect block=
), and
> some time for lookups in the RB-tree of the structures. At least the =
nice
> thing is that when there are no delay-allocated blocks, there isn't a=
ny
> overhead (tree is empty).
>

How about allocating *only* the indirect blocks on page fault.
IMHO it seems like a fair mixture of high quota accuracy, low
complexity of the accounting code and low file fragmentation (only
indirect may be a bit further away from data).

In my snapshot patches I use the @create arg to get_blocks_handle() to
pass commands just like "allocate only indirect blocks".
The patch is rather simple. I can prepare it for ext3 if you like.

Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
