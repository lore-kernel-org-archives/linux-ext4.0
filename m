From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2.4 0/3] mm/fs: Remove unnecessary waiting for stable
 pages
Date: Tue, 15 Jan 2013 14:46:08 -0800
Message-ID: <20130115144608.722180b7.akpm@linux-foundation.org>
References: <20130115054235.1563.12967.stgit@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: axboe@kernel.dk, lucho@ionkov.net, jack@suse.cz, ericvh@gmail.com,
	tytso@mit.edu, viro@zeniv.linux.org.uk, rminnich@sandia.gov,
	martin.petersen@oracle.com, neilb@suse.de, david@fromorbit.com,
	gnehzuil.liu@gmail.com, linux-kernel@vger.kernel.org,
	hch@infradead.org, linux-fsdevel@vger.kernel.org,
	adilger.kernel@dilger.ca, bharrosh@panasas.com, jlayton@samba.org,
	linux-ext4@vger.kernel.org, hirofumi@mail.parknet.co.jp
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130115054235.1563.12967.stgit@blackbox.djwong.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 14 Jan 2013 21:42:35 -0800
"Darrick J. Wong" <darrick.wong@oracle.com> wrote:

> This patchset ("stable page writes, part 2") makes some key modifications to
> the original 'stable page writes' patchset.  First, it provides creators
> (devices and filesystems) of a backing_dev_info a flag that declares whether or
> not it is necessary to ensure that page contents cannot change during writeout.
> It is no longer assumed that this is true of all devices (which was never true
> anyway).  Second, the flag is used to relaxed the wait_on_page_writeback calls
> so that wait only occurs if the device needs it.  Third, it fixes up the
> remaining disk-backed filesystems to use this improved conditional-wait logic
> to provide stable page writes on those filesystems.
> 
> It is hoped that (for people not using checksumming devices, anyway) this
> patchset will give back unnecessary performance decreases since the original
> stable page write patchset went into 3.0.  Sorry about not fixing it sooner.
> 
> Complaints were registered by several people about the long write latencies
> introduced by the original stable page write patchset.  Generally speaking, the
> kernel ought to allocate as little extra memory as possible to facilitate
> writeout, but for people who simply cannot wait, a second page stability
> strategy is (re)introduced: snapshotting page contents.  The waiting behavior
> is still the default strategy; to enable page snapshotting, a superblock flag
> (MS_SNAP_STABLE) must be set.  This flag is used to bandaid^Henable stable page
> writeback on ext3[1], and is not used anywhere else.
> 
> Given that there are already a few storage devices and network FSes that have
> rolled their own page stability wait/page snapshot code, it would be nice to
> move towards consolidating all of these.  It seems possible that iscsi and
> raid5 may wish to use the new stable page write support to enable zero-copy
> writeout.
> 
> Thank you to Jan Kara for helping fix a couple more filesystems.

I have to say that 3d08bcc887 ("mm: Wait for writeback when grabbing
pages to begin a write") was a massive faceplant.  How the heck did that
happen?

Looking back at the 19 May 2011 patchset, I see that we all managed to
avoid cc'ing the guy who wrote and designed that code and who introduced
the PageWriteback/wait_on_page_writeback() infrastructure to avoid exactly
the problem which 3d08bcc887 added.  Sigh.

> This patchset has been tested on 3.8.0-rc3 on x64 with ext3, ext4, and xfs.
> What does everyone think about queueing this for 3.9?

This patchset lacks any performance testing results.


The patchset looks OK to me, but one thing I find unclear:

For clarity's sake, please provide a description of which filesystems
(and under which circumstances) will block behind writeback when
userspace is attempting to dirty a page.  Both before and, particularly,
after this patchset.  IOW, did everything get fixed?
