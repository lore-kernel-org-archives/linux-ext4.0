From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [patch,rfc v2] ext3/4: enhance fsync performance when using cfq
Date: Wed, 21 Apr 2010 16:42:38 -0400
Message-ID: <z2u170fa0d21004211342ncaf04f90h2cd7ebe832dcc46a@mail.gmail.com>
References: <x49ochv7yi3.fsf@segfault.boston.devel.redhat.com>
	 <20100407214631.GL3206@redhat.com> <20100408110442.GK10103@kernel.dk>
	 <20100408140515.GB10879@redhat.com> <20100408140944.GQ10103@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Vivek Goyal <vgoyal@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	dm-devel@redhat.com
To: Jeff Moyer <jmoyer@redhat.com>, Jens Axboe <jens.axboe@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58836 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756496Ab0DUUmk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 21 Apr 2010 16:42:40 -0400
In-Reply-To: <20100408140944.GQ10103@kernel.dk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 8, 2010 at 10:09 AM, Jens Axboe <jens.axboe@oracle.com> wro=
te:
> On Thu, Apr 08 2010, Vivek Goyal wrote:
>> On Thu, Apr 08, 2010 at 01:04:42PM +0200, Jens Axboe wrote:
>> > On Wed, Apr 07 2010, Vivek Goyal wrote:
>> > > On Wed, Apr 07, 2010 at 05:18:12PM -0400, Jeff Moyer wrote:
>> > > > Hi again,
>> > > >
>> > > > So, here's another stab at fixing this. =A0This patch is very =
much an RFC,
>> > > > so do not pull it into anything bound for Linus. =A0;-) =A0For=
 those new to
>> > > > this topic, here is the original posting: =A0http://lkml.org/l=
kml/2010/4/1/344
>> > > >
>> > > > The basic problem is that, when running iozone on smallish fil=
es (up to
>> > > > 8MB in size) and including fsync in the timings, deadline outp=
erforms
>> > > > CFQ by a factor of about 5 for 64KB files, and by about 10% fo=
r 8MB
>> > > > files. =A0From examining the blktrace data, it appears that io=
zone will
>> > > > issue an fsync() call, and will have to wait until it's CFQ ti=
meslice
>> > > > has expired before the journal thread can run to actually comm=
it data to
>> > > > disk.
>> > > >
>> > > > The approach below puts an explicit call into the filesystem-s=
pecific
>> > > > fsync code to yield the disk so that the jbd[2] process has a =
chance to
>> > > > issue I/O. =A0This bring performance of CFQ in line with deadl=
ine.
>> > > >
>> > > > There is one outstanding issue with the patch that Vivek point=
ed out.
>> > > > Basically, this could starve out the sync-noidle workload if t=
here is a
>> > > > lot of fsync-ing going on. =A0I'll address that in a follow-on=
 patch. =A0For
>> > > > now, I wanted to get the idea out there for others to comment =
on.
>> > > >
>> > > > Thanks a ton to Vivek for spotting the problem with the initia=
l
>> > > > approach, and for his continued review.
>> > > >
=2E..
>> > > So we got to take care of two issues now.
>> > >
>> > > - Make it work with dm/md devices also. Somehow shall have to pr=
opogate
>> > > =A0 this yield semantic down the stack.
>> >
>> > The way that Jeff set it up, it's completely parallel to eg conges=
tion
>> > or unplugging. So that should be easily doable.
>> >
>>
>> Ok, so various dm targets now need to define "yield_fn" and propogat=
e the
>> yield call to all the component devices.
>
> Exactly.

To do so doesn't DM (and MD) need a blk_queue_yield() setter to
establish its own yield_fn?  The established dm_yield_fn would call
blk_yield() for all real devices in a given DM target.  Something like
how blk_queue_merge_bvec() or blk_queue_make_request() allow DM to
provide functional extensions.

I'm not seeing such a yield_fn hook for stacking drivers to use. And
as is, jbd and jbd2 just call blk_yield() directly and there is no way
for the block layer to call into DM.

What am I missing?

Thanks,
Mike
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
