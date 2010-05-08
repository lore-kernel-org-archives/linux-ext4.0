From: "Amir G." <amir73il@users.sourceforge.net>
Subject: Re: Introducing Next3 - built-in snapshots support for Ext3
Date: Sat, 8 May 2010 21:40:12 +0200
Message-ID: <AANLkTiniWITctyA7t3IEWM-K-Rla9YJ9AeSqE3klOg41@mail.gmail.com>
References: <g2j18730dc51004180841obb1171bbwa1822d6fe0856429@mail.gmail.com>
	 <20100504224226.GE6344@thunk.org>
	 <p2h18730dc51005041905ma9e3733uc944bdb58af9f10@mail.gmail.com>
	 <87vdaz21b0.fsf@basil.nowhere.org>
	 <q2i18730dc51005071222q7d97ab67p968072fa6fdceb28@mail.gmail.com>
	 <4BE4855E.40808@redhat.com>
	 <AANLkTinbzARSNHOvMbRq7iKSZENKhnKYdKSq5IHvX_xs@mail.gmail.com>
	 <8D8944AA-9368-4E4F-B91D-5CEEE6E2EE2A@mit.edu>
	 <AANLkTin0kirxWJR1jfKdX8AtWJbAjBiQNR3WsTmr5z8U@mail.gmail.com>
	 <20100508172557.GK18762@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ric Wheeler <rwheeler@redhat.com>, Andi Kleen <andi@halobates.de>,
	linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:52500 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086Ab0EHTkO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 8 May 2010 15:40:14 -0400
Received: by bwz19 with SMTP id 19so1111341bwz.21
        for <linux-ext4@vger.kernel.org>; Sat, 08 May 2010 12:40:12 -0700 (PDT)
In-Reply-To: <20100508172557.GK18762@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, May 8, 2010 at 7:25 PM,  <tytso@mit.edu> wrote:
> On Sat, May 08, 2010 at 06:07:40PM +0200, Amir G. wrote:
>>
>> Next3 is another implementation of the extended f/s format.
>> Next3 is a superset of ext3 plus snapshots.
>
> As long as Next3 uses fields which have already assigned to ext4, thi=
s
> is a claim that you can not make correctly. =A0Because, you see, the
> ext4 is also an implementation of the extended f/s format, and those
> field assignments have already been made.
>
>> All overlapping field issues can be resolved.
>
> As long as you are willing to say that, then sure, let's work towards
> that goal.
>

Let me state my case then:

Next3 uses 1 assigned field (i_version), but it does not "abuse" it.
You see, Next3 only tampers with i_version of snapshot files.
And by tamper I mean: set it to next snapshot inode number on snapshot =
take.
And snapshot files are not modifiable by users (only by the f/s itself)=
=2E
So if the f/s decides to assign an arbitrary value to i_version of
snapshot files,
it doesn't break the extended f/s format. does it?

Next3 also uses 9 i_flags bits (0x1FF00000), in snapshot file inodes on=
ly,
some currently overlapping flags recently assigned to Ext4 (you beat me=
 to it).
There is a big waste in i_flag bits space, for example, the 4 bits
reserved for compression,
which are not in use by non-compressed files.
Snapshot files are never compressed, so I wouldn't mind reusing those
4 bits for snapshot flags.
Overloading auxiliary bits with different meanings depending on some
other bit does not make this a different f/s format.
It simply makes use of expensive space more efficiently.


>
> If you do the "move-on-write" trick, you just have to split the exten=
t
> and do a COW of the extent tree and/or the inode. =A0So for a single
> block, the performance hit the same, yes? =A0But in the long-run, it'=
s
> probably more efficient to do "move-on-write".
>

All metadata is COWed, inside the JBD hooks, so the extent tree and
inode are taken care of.
It is the data blocks which are being moved-on-write for efficiency.
The problem with splitting the extent is that when an application does
a lot of in-place writes to an extent mapped file,
it will eventually end up being broken down into tiny extents or
blocks and that is a problem. right?

>> There is an important design decision to make here.
>
> Technically speaking, it's possible to do it both way, yes? =A0I'm no=
t
> sure why you consider this such a important design decision. =A0We ca=
n
> even play games where for some files we might do copy-on-write, and
> for some files, we do move-on-write. =A0It's always possible to check
> the COW bitmaps to decide what had happened.
>

Definitely yes! I never thought it would really have to come down to a
"decision",
because there is a trade-off at hand.
Even in Next3, without extents, it makes sense to have a choice of
write performance vs. fragmentation per file.
The few applications that use random in-place write (db, virtual disk)
would probably want to avoid the fragmentation.

> In any case, if this is all you have to do, I'm not sure why you said
> it was fundamentally impossible to support extents with the Next3
> design.
>

Wait just a minute! I said "not an easy task" and "break the design
concepts", but I never said (as far as I recall) "fundamentally
impossible". Well, perhaps "breaking the design concepts" was too
harsh :-)

I quote from Next3 wiki FAQ:
"Can Next3 snapshot support be applied to Ext4?
Most of the snapshot code can work on Ext4 as is, but the
move-on-write technique used for regular files data blocks will
require additional work before it can be applied to extent mapped
files."

I would have to say that "considerable amount of time" is the main
obstacle for the merge task.

So my humble and biased suggestion is:
let's start working with Next3, get to know it's strengths and weakness=
es
and then design the nExt4 merge together.

Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
