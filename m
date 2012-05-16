From: Hugh Dickins <hughd@google.com>
Subject: Re: punch-hole should go beyond i_size
Date: Wed, 16 May 2012 11:09:53 -0700
Message-ID: <CANsGZ6Zw7tvL-98P6yvs+abVrbJLxPn=uCbOdxL9H1a16pz1Qg@mail.gmail.com>
References: <alpine.LSU.2.00.1201111639240.1833@eggly.anvils>
	<20120112025547.GC2806@dastard>
	<4F0F08F6.2000205@linux.vnet.ibm.com>
	<alpine.LSU.2.00.1205131404040.1547@eggly.anvils>
	<4FB2CC79.4020200@linux.vnet.ibm.com>
	<alpine.LSU.2.00.1205151529140.1571@eggly.anvils>
	<alpine.LFD.2.00.1205160810580.3179@dhcp-1-248.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Allison Henderson <achender@linux.vnet.ibm.com>,
	Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
	"Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: =?UTF-8?B?THVrw6HFoSBDemVybmVy?= <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:62174 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760084Ab2EPSJy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 May 2012 14:09:54 -0400
Received: by vbbff1 with SMTP id ff1so934228vbb.19
        for <linux-ext4@vger.kernel.org>; Wed, 16 May 2012 11:09:53 -0700 (PDT)
In-Reply-To: <alpine.LFD.2.00.1205160810580.3179@dhcp-1-248.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 15, 2012 at 11:14 PM, Luk=C3=A1=C5=A1 Czerner <lczerner@red=
hat.com> wrote:
> On Tue, 15 May 2012, Hugh Dickins wrote:
>>> Date: Tue, 15 May 2012 15:38:33 -0700 (PDT)
>> From: Hugh Dickins <hughd@google.com>
>> To: Allison Henderson <achender@linux.vnet.ibm.com>
>> Cc: Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
>> =C2=A0 =C2=A0 Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.=
org,
>> =C2=A0 =C2=A0 Lukas Czerner <lczerner@redhat.com>
>> Subject: Re: punch-hole should go beyond i_size
>>
>> On Tue, 15 May 2012, Allison Henderson wrote:
>> > On 05/13/2012 02:13 PM, Hugh Dickins wrote:
>> > > On Thu, 12 Jan 2012, Allison Henderson wrote:
>> > >> On 01/11/2012 07:55 PM, Dave Chinner wrote:
>> > >>> On Wed, Jan 11, 2012 at 05:02:12PM -0800, Hugh Dickins wrote:
>> > >>>> Hi Allison,
>> > >>>>
>> > >>>> In thinking about fallocate() on tmpfs, I cross-check with ex=
t4
>> > >>>> and find this bug in its implementation of FALLOC_FL_PUNCH_HO=
LE:
>> > >>>>
>> > >>>> rm -f temp
>> > >>>> fallocate =C2=A0 =C2=A0-l 4096 temp
>> > >>>> du temp =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0# shows 4, righ=
t
>> > >>>> fallocate -p -l 4096 temp
>> > >>>> du temp =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0# shows 0, righ=
t
>> > >>>> rm -f temp
>> > >>>> fallocate -n -l 4096 temp
>> > >>>> du temp =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0# shows 4, righ=
t
>> > >>>> fallocate -p -l 4096 temp
>> > >>>> du temp =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0# shows 4, wron=
g
>> > >>>> rm temp
>> > >>>>
>> > >>>> ext4_ext_punch_hole() contains /* No need to punch hole beyon=
d i_size */
>> > >>>> early return, and trimming to i_size below, but forgets that =
the other
>> > >>>> variety of fallocate(), with FALLOC_FL_KEEP_SIZE set, may hav=
e allocated
>> > >>>> blocks beyond i_size. =C2=A0They can be removed with ftruncat=
e(), but it is
>> > >>>> unexpected for fallocate() not to undo its own work, and xfs =
does so.
>> > >>>
>> > >>> I'm pretty sure that's a bug as XFS allows punching holes in e=
xtents
>> > >>> beyond EOF.
>> > >>>
>> > >>> Cheers,
>> > >>>
>> > >>> Dave.
>> > >>
>> > >> Oh I see, I'll take a look at it, I think it will be ok to just=
 take out the
>> > >> early return. =C2=A0Thx!
>> > >
>> > > I see the -EOPNOTSUPPs have gone into 3.4's ext4_punch_hole() - =
thanks -
>> > > but the i_size issue remains unfixed. =C2=A0I wouldn't be surpri=
sed if it were
>> > > more complicated than you had hoped - I had no intention of tryi=
ng a patch
>> > > myself! =C2=A0It's not an actual problem for me, but I thought I=
'd just send a
>> > > reminder, before I move out of the hole-punching business.
>> >
>> > Hi all,
>> >
>> > I had a fix for this a while ago and I believe Lukas had rebased i=
t
>> > when he was working on some punch hole optimizations, but Im not s=
ure
>> > what happened to it after that. =C2=A0I think Lukas might still be=
 working
>> > on that set? =C2=A0If not, I can take a peek at it again and see i=
f I can
>> > get it updated and resent. =C2=A0Thx!
>> >
>> > Allison Henderson
>>
>> Thanks, Allison. =C2=A0I just added Jan to the Cc list to make sure =
he sees,
>> since we mentioned this in the inode_dio_wait thread (which I skilfu=
lly
>> directed to an almost disjoint set of addressees - though I expect h=
e
>> already saw via linux-ext4).
>>
>> Hugh
>
> Yes, we've been talking about this issue on LSF with Ted and the
> conclusion is that we want to wait for the range locks to be ready.
> This way we can avoid taking imutex for the punch hole when punching
> beyond isize which we would have to do otherwise.
>
> I am not sure how big of an issue this is, probably not so big. If
> we can not wait for the range locks, I can make a patch with imutex
> protection.

I agree with you, this issue is not big enough to be worth reordering
ext4 priorities and making an interim fix.  I don't think it has
actually inconvenienced anyone at all, but merely came to my notice
when I was trying to work out the correct behaviour for tmpfs.

However, the issues that Jan is grappling with in "Hole punching and
mmap races" seem more serious, and may end up affecting or solving
this one too.

Hugh
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
