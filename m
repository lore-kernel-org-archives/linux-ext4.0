From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2.3 0/3] mm/fs: Implement faster stable page writes on
 filesystems
Date: Thu, 13 Dec 2012 00:07:40 -0800
Message-ID: <20121213080740.23360.16346.stgit@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: martin.petersen@oracle.com, neilb@suse.de, david@fromorbit.com,
	Zheng Liu <gnehzuil.liu@gmail.com>,
	linux-kernel@vger.kernel.org, hch@infradead.org,
	linux-fsdevel@vger.kernel.org, adilger.kernel@dilger.ca,
	bharrosh@panasas.com, jlayton@samba.org,
	v9fs-developer@lists.sourceforge.net, linux-ext4@vger.kernel.org
To: axboe@kernel.dk, lucho@ionkov.net, jack@suse.cz,
	"Darrick J. Wong" <darrick.wong@oracle.com>, ericvh@gmail.com,
	viro@zeniv.linux.org.uk, rminnich@sandia.gov, tytso@mit.edu
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi all,

This patchset ("stable page writes, part 2") makes some key modifications to
the original 'stable page writes' patchset.  First, it provides creators
(devices and filesystems) of a backing_dev_info a flag that declares whether or
not it is necessary to ensure that page contents cannot change during writeout.
It is no longer assumed that this is true of all devices (which was never true
anyway).  Second, the flag is used to relaxed the wait_on_page_writeback calls
so that wait only occurs if the device needs it.  Third, it fixes up the
remaining disk-backed filesystems to use this improved conditional-wait logic
to provide stable page writes on those filesystems.

It is hoped that (for people not using checksumming devices, anyway) this
patchset will give back unnecessary performance decreases since the original
stable page write patchset went into 3.0.  Sorry about not fixing it sooner.

Complaints were registered by several people about the long write latencies
introduced by the original stable page write patchset.  Generally speaking, the
kernel ought to allocate as little extra memory as possible to facilitate
writeout, but for people who simply cannot wait, a second page stability
strategy is (re)introduced: snapshotting page contents.  The waiting behavior
is still the default strategy; to enable page snapshotting, a superblock flag
(MS_SNAP_STABLE) must be set.  This flag is primary used to bandaid^Henable
stable page writeout on ext3[1], but a mount options is provided for impatient
ext4 users.

Given that there are already a few storage devices and network FSes that have
rolled their own page stability wait/page snapshot code, it would be nice to
move towards consolidating all of these.  It seems possible that iscsi and
raid5 may wish to use the new stable page write support to enable zero-copy
writeout.

In the future, it would be useful to develop a heuristic to select a strategy
automatically rather than leaving it up to manual control.

This patchset has been lightly tested on 3.7.0 on x64 with ext3, ext4, and xfs.

--D

[1] The alternative fixes to ext3 include fixing the locking order and page bit
handling like we did for ext4 (but then why not just use ext4?), or setting
PG_writeback so early that ext3 becomes extremely slow.  I tried that, but the
number of write()s I could initiate dropped by nearly an order of magnitude.
That was a bit much even for the author of the stable page series! :)
