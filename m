From: Joe Thornber <thornber@redhat.com>
Subject: Re: LVM vs. Ext4 snapshots (was: [PATCH v1 00/30] Ext4 snapshots)
Date: Fri, 10 Jun 2011 16:01:30 +0100
Message-ID: <20110610150129.GA17585@ubuntu>
References: <BANLkTimyBGfg4+ovGsiGqpCz345qVmU_7A@mail.gmail.com>
 <BANLkTik20iYN4c9faKD9dzerehazWTwTFw@mail.gmail.com>
 <BANLkTikKRuPu_NX49vr0w-XeN0ZnWo+9vg@mail.gmail.com>
 <alpine.LFD.2.00.1106101101020.4502@dhcp-27-109.brq.redhat.com>
 <20110610101142.GA10144@ubuntu>
 <BANLkTi=zjU3-FV3AVpYsknzKFgaS7byb_Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Lukas Czerner <lczerner@redhat.com>,
	Mike Snitzer <snitzer@redhat.com>, linux-ext4@vger.kernel.org,
	tytso@mit.edu, linux-kernel@vger.kernel.org, lvm-devel@redhat.com,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: "Amir G." <amir73il@users.sourceforge.net>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <BANLkTi=zjU3-FV3AVpYsknzKFgaS7byb_Q@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jun 10, 2011 at 05:15:37PM +0300, Amir G. wrote:
> On Fri, Jun 10, 2011 at 1:11 PM, Joe Thornber <thornber@redhat.com> w=
rote:
> > FUA/flush allows us to treat multisnap devices as if they are devic=
es
> > with a write cache. =A0When a FUA/FLUSH bio comes in we ensure we c=
ommit
> > metadata before allowing the bio to continue. =A0A crash will lose =
data
> > that is in the write cache, same as any real block device with a wr=
ite
> > cache.
> >
>=20
> Now, here I am confused.
> Reducing the problem to write cache enabled device sounds valid,
> but I am not yet convinced it is enough.
> In ext4 snapshots I had to deal with 'internal ordering' between I/O
> of origin data and snapshot metadata and data.
> That means that every single I/O to origin, which overwrites shared d=
ata,
> must hit the media *after* the original data has been copied to snaps=
hot
> and the snapshot metadata and data are secure on media.
> In ext4 this is done with the help of JBD2, which anyway holds back m=
etadata
> writes until commit.
> It could be that this problem is only relevant to _extenal_ origin, w=
hich
> are not supported for multisnap, but frankly, as I said, I am too con=
fused
> to figure out if there is yet an ordering problem for _internal_ orig=
in or not.

Ok, let me talk you through my solution.  The relevant code is here if
you want to sing along:
https://github.com/jthornber/linux-2.6/blob/multisnap/drivers/md/dm-mul=
tisnap.c

We use a standard copy-on-write btree to store the mappings for the
devices (note I'm talking about copy-on-write of the metadata here,
not the data).  When you take an internal snapshot you clone the root
node of the origin btree.  After this there is no concept of an
origin or a snapshot.  They are just two device trees that happen to
point to the same data blocks.

When we get a write in we decide if it's to a shared data block using
some timestamp magic.  If it is, we have to break sharing.

Let's say we write to a shared block in what was the origin.  The
steps are:

i) plug io further to this physical block. (see bio_prison code).

ii) quiesce any read io to that shared data block.  Obviously
including all devices that share this block.  (see deferred_set code)

iii) copy the data block to a newly allocate block.  This step can be
missed out if the io covers the block. (schedule_copy).

iv) insert the new mapping into the origin's btree
(process_prepared_mappings).  This act of inserting breaks some
sharing of btree nodes between the two devices.  Breaking sharing only
effects the btree of that specific device.  Btrees for the other
devices that share the block never change.  The btree for the origin
device as it was after the last commit is untouched, ie. we're using
persistent data structures in the functional programming sense.

v) unplug io to this physical block, including the io that triggered
the breaking of sharing.

Steps (ii) and (iii) occur in parallel.

The main difference to what you described is the metadata _doesn't_
need to be committed before the io continues.  We get away with this
because the io is always written to a _new_ block.  If there's a
crash, then:

- The origin mapping will point to the old origin block (the shared
  one).  This will contain the data as it was before the io that
  triggered the breaking of sharing came in.

- The snap mapping still points to the old block.  As it would after
  the commit.

The downside of this scheme is the timestamp magic isn't perfect, and
will continue to think that data block in the snapshot device is
shared even after the write to the origin has broken sharing.  I
suspect data blocks will typically be shared by many different
devices, so we're breaking sharing n + 1 times, rather than n, where n
is the number of devices that reference this data block.  At the
moment I think the benefits far, far out weigh the disadvantages.

- Joe
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
