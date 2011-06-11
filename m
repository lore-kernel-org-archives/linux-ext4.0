From: "Amir G." <amir73il@users.sourceforge.net>
Subject: Re: LVM vs. Ext4 snapshots (was: [PATCH v1 00/30] Ext4 snapshots)
Date: Sat, 11 Jun 2011 07:01:36 +0300
Message-ID: <BANLkTikUZadpVJRcfX_MLMZ-p_G0bT_8uQ@mail.gmail.com>
References: <BANLkTimyBGfg4+ovGsiGqpCz345qVmU_7A@mail.gmail.com>
	<BANLkTik20iYN4c9faKD9dzerehazWTwTFw@mail.gmail.com>
	<BANLkTikKRuPu_NX49vr0w-XeN0ZnWo+9vg@mail.gmail.com>
	<alpine.LFD.2.00.1106101101020.4502@dhcp-27-109.brq.redhat.com>
	<20110610101142.GA10144@ubuntu>
	<BANLkTi=zjU3-FV3AVpYsknzKFgaS7byb_Q@mail.gmail.com>
	<20110610150129.GA17585@ubuntu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Lukas Czerner <lczerner@redhat.com>,
	Mike Snitzer <snitzer@redhat.com>, linux-ext4@vger.kernel.org,
	tytso@mit.edu, linux-kernel@vger.kernel.org, lvm-devel@redhat.com,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Joe Thornber <thornber@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45476 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857Ab1FKEBi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 11 Jun 2011 00:01:38 -0400
In-Reply-To: <20110610150129.GA17585@ubuntu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 10, 2011 at 6:01 PM, Joe Thornber <thornber@redhat.com> wro=
te:
> On Fri, Jun 10, 2011 at 05:15:37PM +0300, Amir G. wrote:
>> On Fri, Jun 10, 2011 at 1:11 PM, Joe Thornber <thornber@redhat.com> =
wrote:
>> > FUA/flush allows us to treat multisnap devices as if they are devi=
ces
>> > with a write cache. =A0When a FUA/FLUSH bio comes in we ensure we =
commit
>> > metadata before allowing the bio to continue. =A0A crash will lose=
 data
>> > that is in the write cache, same as any real block device with a w=
rite
>> > cache.
>> >
>>
>> Now, here I am confused.
>> Reducing the problem to write cache enabled device sounds valid,
>> but I am not yet convinced it is enough.
>> In ext4 snapshots I had to deal with 'internal ordering' between I/O
>> of origin data and snapshot metadata and data.
>> That means that every single I/O to origin, which overwrites shared =
data,
>> must hit the media *after* the original data has been copied to snap=
shot
>> and the snapshot metadata and data are secure on media.
>> In ext4 this is done with the help of JBD2, which anyway holds back =
metadata
>> writes until commit.
>> It could be that this problem is only relevant to _extenal_ origin, =
which
>> are not supported for multisnap, but frankly, as I said, I am too co=
nfused
>> to figure out if there is yet an ordering problem for _internal_ ori=
gin or not.
>
> Ok, let me talk you through my solution. =A0The relevant code is here=
 if
> you want to sing along:
> https://github.com/jthornber/linux-2.6/blob/multisnap/drivers/md/dm-m=
ultisnap.c
>
> We use a standard copy-on-write btree to store the mappings for the
> devices (note I'm talking about copy-on-write of the metadata here,
> not the data). =A0When you take an internal snapshot you clone the ro=
ot
> node of the origin btree. =A0After this there is no concept of an
> origin or a snapshot. =A0They are just two device trees that happen t=
o
> point to the same data blocks.
>
> When we get a write in we decide if it's to a shared data block using
> some timestamp magic. =A0If it is, we have to break sharing.
>
> Let's say we write to a shared block in what was the origin. =A0The
> steps are:
>
> i) plug io further to this physical block. (see bio_prison code).
>
> ii) quiesce any read io to that shared data block. =A0Obviously
> including all devices that share this block. =A0(see deferred_set cod=
e)
>
> iii) copy the data block to a newly allocate block. =A0This step can =
be
> missed out if the io covers the block. (schedule_copy).
>
> iv) insert the new mapping into the origin's btree
> (process_prepared_mappings). =A0This act of inserting breaks some
> sharing of btree nodes between the two devices. =A0Breaking sharing o=
nly
> effects the btree of that specific device. =A0Btrees for the other
> devices that share the block never change. =A0The btree for the origi=
n
> device as it was after the last commit is untouched, ie. we're using
> persistent data structures in the functional programming sense.
>
> v) unplug io to this physical block, including the io that triggered
> the breaking of sharing.
>
> Steps (ii) and (iii) occur in parallel.
>
> The main difference to what you described is the metadata _doesn't_
> need to be committed before the io continues. =A0We get away with thi=
s
> because the io is always written to a _new_ block. =A0If there's a
> crash, then:
>
> - The origin mapping will point to the old origin block (the shared
> =A0one). =A0This will contain the data as it was before the io that
> =A0triggered the breaking of sharing came in.
>
> - The snap mapping still points to the old block. =A0As it would afte=
r
> =A0the commit.
>

OK. Now I am convinced that there is no I/O ordering issue,
since you are never overwriting shared data in-place.

Now I also convinced that the origin will be so heavily fragmented,
to the point that the solution will not be practical for performance
sensitive applications. Specifically, applications that use spinning
media storage and require consistent and predictable performance.

I do have a crazy idea, though, how to combine the power of the
multisnap features with the speed of a raw ext4 fs.

In the early days of next3 snapshots design I tried to mimic
the generic JBD APIs and added generic snapshot APIs
to ext3, so that some day an external snapshot store
implementation could use this API.

Over time, as the internal snapshots store implementation grew
to use many internal fs optimizations, I neglected the option to
ever support an external snapshots store.

Now that I think about it, it doesn't look so far fetched after all.
The concept is that multisnap can register as a 'snapshot store
provider' and get called by ext4 directly (not via device mapper)
to copy a metadata buffer on write (snapshot_get_write_access),
get ownership over fs data blocks on delete and rewrite
(snapshot_get_delete/move_access) and to commit/flush the store.

ext4 will keep track of blocks which are owned by the external
snapshot store (in the exclude bitmap) and provide a callback
API from the snapshots store to free those blocks on snapshot
delete.

The ext4 snapshot APIs are already working that way with
the internal store implementation (the store is a sparse file).

There is also the step of creating the initial metadata btree
when creating the multisnap volume with __external__ origin.
This is just a simple translation of the ext4 block bitmap to
a btree. After that, changes to the __external__ btree can
be made on changes to the ext4 block bitmap - an API already
being used by internal implementation (snapshot_get_bitmap_access).

What do you think?
Does this plan sound too crazy?
Do you think it is doable for multisnap to support this kind of
__external__ origin?

Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
