From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2.4 0/3] mm/fs: Remove unnecessary waiting for stable
 pages
Date: Tue, 15 Jan 2013 16:22:46 -0800
Message-ID: <20130116002246.GI6426@blackbox.djwong.org>
References: <20130115054235.1563.12967.stgit@blackbox.djwong.org>
 <20130115144608.722180b7.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: axboe@kernel.dk, lucho@ionkov.net, jack@suse.cz, ericvh@gmail.com,
	tytso@mit.edu, viro@zeniv.linux.org.uk, rminnich@sandia.gov,
	martin.petersen@oracle.com, neilb@suse.de, david@fromorbit.com,
	gnehzuil.liu@gmail.com, linux-kernel@vger.kernel.org,
	hch@infradead.org, linux-fsdevel@vger.kernel.org,
	adilger.kernel@dilger.ca, bharrosh@panasas.com, jlayton@samba.org,
	linux-ext4@vger.kernel.org, hirofumi@mail.parknet.co.jp
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130115144608.722180b7.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jan 15, 2013 at 02:46:08PM -0800, Andrew Morton wrote:
> On Mon, 14 Jan 2013 21:42:35 -0800
> "Darrick J. Wong" <darrick.wong@oracle.com> wrote:
> 
> > This patchset ("stable page writes, part 2") makes some key modifications to
> > the original 'stable page writes' patchset.  First, it provides creators
> > (devices and filesystems) of a backing_dev_info a flag that declares whether or
> > not it is necessary to ensure that page contents cannot change during writeout.
> > It is no longer assumed that this is true of all devices (which was never true
> > anyway).  Second, the flag is used to relaxed the wait_on_page_writeback calls
> > so that wait only occurs if the device needs it.  Third, it fixes up the
> > remaining disk-backed filesystems to use this improved conditional-wait logic
> > to provide stable page writes on those filesystems.
> > 
> > It is hoped that (for people not using checksumming devices, anyway) this
> > patchset will give back unnecessary performance decreases since the original
> > stable page write patchset went into 3.0.  Sorry about not fixing it sooner.
> > 
> > Complaints were registered by several people about the long write latencies
> > introduced by the original stable page write patchset.  Generally speaking, the
> > kernel ought to allocate as little extra memory as possible to facilitate
> > writeout, but for people who simply cannot wait, a second page stability
> > strategy is (re)introduced: snapshotting page contents.  The waiting behavior
> > is still the default strategy; to enable page snapshotting, a superblock flag
> > (MS_SNAP_STABLE) must be set.  This flag is used to bandaid^Henable stable page
> > writeback on ext3[1], and is not used anywhere else.
> > 
> > Given that there are already a few storage devices and network FSes that have
> > rolled their own page stability wait/page snapshot code, it would be nice to
> > move towards consolidating all of these.  It seems possible that iscsi and
> > raid5 may wish to use the new stable page write support to enable zero-copy
> > writeout.
> > 
> > Thank you to Jan Kara for helping fix a couple more filesystems.
> 
> I have to say that 3d08bcc887 ("mm: Wait for writeback when grabbing
> pages to begin a write") was a massive faceplant.  How the heck did that
> happen?

Back then, I believe we thought that the occasional wait when rewriting file
blocks wouldn't be noticeable.  Also, I naively failed to plan for it taking
two years and a change of employers to get back to this. :/

> Looking back at the 19 May 2011 patchset, I see that we all managed to
> avoid cc'ing the guy who wrote and designed that code and who introduced
> the PageWriteback/wait_on_page_writeback() infrastructure to avoid exactly
> the problem which 3d08bcc887 added.  Sigh.

Here's what I saw in MAINTAINERS back in 2011:

MEMORY MANAGEMENT
L:      linux-mm@kvack.org
W:      http://www.linux-mm.org
S:      Maintained
F:      include/linux/mm.h
F:      mm/

Sorry I forgot to cc you directly.  I guess I should have run
get_maintainers.pl and cc'd everyone ... but MAINTAINERS didn't list any
specific recipients, only lists.

> > This patchset has been tested on 3.8.0-rc3 on x64 with ext3, ext4, and xfs.
> > What does everyone think about queueing this for 3.9?
> 
> This patchset lacks any performance testing results.

On my setup (various consumer SSDs and spinny disks, none of which support
T10DIF) I see that the maximum write latency with these patches applied is
about half of what it is without the patches.  But don't take my word for it;
Andy Lutomirski[1] says that his soft-rt latency-sensitive programs no longer
freak out when he applies the patch set.  Afaik, Google and Taobao run custom
kernels with all this turned off, so they should see similar latency
improvements too.

Obviously, I see no difference on the DIF disk.

> For clarity's sake, please provide a description of which filesystems
> (and under which circumstances) will block behind writeback when
> userspace is attempting to dirty a page.  Both before and, particularly,
> after this patchset.  IOW, did everything get fixed?

Heh, this is complicated.

Before this patchset, all filesystems would block, regardless of whether or not
it was necessary.  ext3 would wait, but still generate occasional checksum
errors.  The network filesystems were left to do their own thing, so they'd
wait too.

After this patchset, all the disk filesystems except ext3 and btrfs will wait
only if the hardware requires it.  ext3 (if necessary) snapshots pages instead
of blocking, and btrfs provides its own bdi so the mm will never wait.  Network
filesystems haven't been touched, so either they provide their own wait code,
or they don't block at all.  The blocking behavior is back to what it was
before 3.0 if you don't have a disk requiring stable page writes.

(I will reconfirm this statement before sending out the next iteration.)

I will of course add all of this to the cover message.

--D

[1] https://lkml.org/lkml/2012/12/14/593
