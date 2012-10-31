From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFC PATCH 1/2] bdi: Create a flag to indicate that a backing
 device needs stable page writes
Date: Wed, 31 Oct 2012 12:36:52 -0700
Message-ID: <20121031193652.GF19591@blackbox.djwong.org>
References: <20121026101909.GB19617@blackbox.djwong.org>
 <20121027013524.GA19591@blackbox.djwong.org>
 <yq1ehkg8us1.fsf@sermon.lab.mkp.net>
 <20121030154844.1898f068@notabene.brown>
 <yq1a9v4884i.fsf@sermon.lab.mkp.net>
 <20121030201424.GD19559@blackbox.djwong.org>
 <20121031091441.5fc6b412@notabene.brown>
 <20121031085604.GC19591@blackbox.djwong.org>
 <20121031115614.GC18424@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: NeilBrown <neilb@suse.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	"Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:42553 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759793Ab2JaThG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 31 Oct 2012 15:37:06 -0400
Content-Disposition: inline
In-Reply-To: <20121031115614.GC18424@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 31, 2012 at 12:56:14PM +0100, Jan Kara wrote:
> On Wed 31-10-12 01:56:04, Darrick J. Wong wrote:
> > On Wed, Oct 31, 2012 at 09:14:41AM +1100, NeilBrown wrote:
> > > On Tue, 30 Oct 2012 13:14:24 -0700 "Darrick J. Wong"
> > > <darrick.wong@oracle.com> wrote:
> > > 
> > > > On Tue, Oct 30, 2012 at 08:19:41AM -0400, Martin K. Petersen wrote:
> > > > > >>>>> "Neil" == NeilBrown  <neilb@suse.de> writes:
> > > > > 
> > > > > Neil,
> > > > > 
> > > > > >> Might be nice to make the sysfs knob tweakable. Also, don't forget to
> > > > > >> add a suitable blurb to Documentation/ABI/.
> > > > > 
> > > > > Neil>  It isn't at all clear to me that having the sysfs knob
> > > > > Neil>  'tweakable' is a good idea.  From the md/raid5 perspective, I
> > > > > Neil>  would want to know for certain whether the pages in a give bio
> > > > > Neil>  are guaranteed not to change, or if they might.  I could set the
> > > > > Neil>  BDI_CAP_STABLE_WRITES and believe they will never change, or test
> > > > > Neil>  the BDI_CAP_STABLE_WRITES and let that tell me if they might
> > > > > Neil>  change or not.  But if the bit can be changed at any moment, then
> > > > > Neil>  it can never be trusted and so becomes worthless to me.
> > > > > 
> > > > > I was mostly interested in being able to turn it on for devices that
> > > > > haven't explicitly done so. I agree that turning it off can be
> > > > > problematic.
> > > > 
> > > > I'm ok with having a tunable that can turn it on, but atm I can't really think
> > > > of a convincing reason to let people turn it /off/.  If people yell loud enough
> > > > I'll add it, but I'd rather not have to distinguish between "on because user
> > > > set it on" vs "on because hw needs it".
> > > > 
> > > > It'd be nice if the presence BDI_CAP_STABLE_WRITES meant that all filesystems
> > > > would wait on page writes.  Hrm, guess I'll see about adding that to the patch
> > > > set.  Though ISTR that at least the vfat and ext2 maintainers weren't
> > > > interested the last time I asked.
> > > 
> > > I'm still a little foggy on the exact semantics and use-cases for this flag.
> > > I'll try to piece together the bits that I know and ask you to tell me what
> > > I've missed or what I've got wrong.
> > > 
> > >  Stable writes are valuable when the filesystem or device driver calculates
> > >  some sort of 'redundancy' information based on the page in memory that is
> > >  about to be written.
> > >  This could be:
> > >       integrity data that will be sent with the page to the storage device
> > >       parity over a number of pages that will be written to a separate device
> > >        (i.e. RAID5/RAID6).
> > >       MAC or similar checksum that will be sent with the data over the network
> > >         and will be validated by the receiving device, which can then ACK or
> > >         NAK depending on correctness.
> > > 
> > >  These could be implemented  in the filesystem or in the device driver, so
> > >  either should be able to request stable writes.  If neither request stable
> > >  writes, then the cost of stable writes should be avoided.
> > 
> > Most of the changes are in the VM; the only place where filesystem-specific
> > bits are needed are for things like ext4 which override page_mkwrite.  I'm not
> > sure what you mean by the filesystem requesting stable writes; unless I'm
> > missing something (it's late), it's only the storage device that has any sort
> > of needs.  The filesystem is free either to accomodate the need for stable
> > writes, or ignore that and deal with the IO errors.
>   As it was noted somewhere else in the thread, if you compute data
> checksums in the filesystem, you need stable pages as well.

Which filesystems other than btrfs do this?

iirc btrfs already provides its own stable page writes by virtue of its COW
nature, though I'm not sure if that holds when nodatacow is set.

> > >  For the device driver (or network transport), not getting stable writes when
> > >  requested might be a performance issue, or it might be a correctness issue.
> > >  e.g. if an unstable write causes a MAC to be wrong, the network layer can
> > >  simply arrange a re-transmit.  If an unstable write causes RAID5 parity to
> > >  be wrong, that unstable write could cause data corruption.
> > > 
> > >  For the filesystem, the requirement to provide stable writes could just be a
> > >  performance cost (a few extra waits) or it could require significant
> > >  re-working of the code (you say vfat and ext2 aren't really comfortable with
> > >  supporting them).
> > 
> > I vaguely recall that the reason for skipping vfat was that the maintainer
> > didn't like the idea of paying the wait costs even on a disk that didn't
> > require it.  I think we're addressing that.  As for ext2 there wasn't much
> > comment, though I think Ted or someone mentioned that since it was "stable"
> > code, it wasn't worth fixing.  In any case, patching filemap_page_mkwrite to
> > have a write_on_page_writeback seems to have fixed a number of filesystems
> > (hfs, reiser, ext2...) with little fuss.
>   Yup, I sent you a patch for this a while ago. If stable pages are
> conditional only for case which require them (or make a good use of them),
> I have no problem with making all filesystems provide them. After changing
> filemap_page_mkwrite(), there are 5 filesystems (ncpfs, ceph, cifs, ubifs,
> ocfs2) which won't support stable pages. I can fix these once we agree on
> the generic infrastructure.

Yesterday I added a patch to my tree that's similar to yours. :)

Actually, I created a function so that we don't have to open-code the if and
wait pieces.

It looks like ceph, cifs, and ocfs2 won't be difficult to modify.  ncpfs seems
to use the generic vm_ops and should be covered.  That leaves ubifs, which
seems to return VM_FAULT_MINOR after unlocking the page.

> > >  Finally there is the VFS/VM which needs to provide support for stable
> > >  writes.  It already does - your flag seems to just allow clients of the
> > >  VFS/VM to indicate whether stable writes are required.
> > > 
> > >  So there seem to be several cases:
> > > 
> > >  1/ The filesystem wants to always use stable writes.  It just sets the flag,
> > >     and the device will see stable writes whether it cares or not.  This would
> > >     happen if the filesystem is adding integrity data.
> > >  2/ The device would prefer stable writes if possible.  This would apply to
> > >     iscsi (??) as it needs to add some sort of checksum before putting the
> > >     data on the network
> > >  3/ The device absolutely requires stable writes, or needs to provide
> > >     stability itself by taking a copy (md/RAID5 does this).  So it needs to
> > >     know whether each write is stable, or it cannot take advantage of stable
> > >     writes.
> > > 
> > > 
> > >  So I see a need for 2 flags here.
> > >  The first one is set by the device or transport to say "I would prefer
> > >  stable writes if possible".
> > 
> > Yep, that seems to correspond with what the patch provides right now.
> > 
> > >  The second is set by the filesystem, either because it has its own needs, or
> > >  because it sees the first flag set on the device and chooses to honour it.
> > >  The VFS/VM would act based on this second flag, and devices like md/RAID5
> > >  would set the first flag, and assume writes are stable if the second flag is
> > >  also set.
> > 
> > This is a trickier piece... I guess this means that the bdi has to keep track
> > of how many clients are using it (it looks like multiple fses on a partitioned
> > disk share the same bdi) and of those clients, which ones claim to support
> > stable page writes.  If all clients do, then the disk can assume that all
> > writes headed to it will be stable.  If even one doesn't, then I guess the
> > device falls back to whatever strategy it used before (the raid5 copying).
> > 
> > I guess we also need a way to pass these flags through md/dm if appropriate.
>   I'd like to keep things simple. It's not hard to make all filesystems
> support stable pages so let's just do that to remove one variable from the
> picture. Then we are in the situation where storage can request stable
> pages by setting bdi bit and filesystem will obey. Also filesystem itself can
> request stable pages by setting the bit and generic functions in mm will
> take that into account. No need for two flags...
> 
> You are right that we need a mechanism to push the flags from the devices
> through various storage layers up into the bdi filesystem sees to make
> things reliable.

md/dm will call blk_integrity_register, so pushing the "stable page writes
required" flag through the various layers is already taken care of.  If devices
and filesystems can both indicate that they want stable page writes,  I'll have
to keep track of however many users there are.

It does seem like less work to fix all the filesystems than to dork around with
another flag.

--D
> 
> 								Honza
> -- 
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
