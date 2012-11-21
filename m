From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2.1 0/3] mm/fs: Implement faster stable page writes on
 filesystems
Date: Tue, 20 Nov 2012 18:00:27 -0800
Message-ID: <20121121020027.10225.43206.stgit@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: martin.petersen@oracle.com, neilb@suse.de, david@fromorbit.com,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	adilger.kernel@dilger.ca, bharrosh@panasas.com, jlayton@samba.org,
	v9fs-developer@lists.sourceforge.net, linux-ext4@vger.kernel.org
To: axboe@kernel.dk, lucho@ionkov.net, jack@suse.cz, ericvh@gmail.com,
	tytso@mit.edu, rminnich@sandia.gov, viro@zeniv.linux.org.uk
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi all,

This patchset ("stable page writes, part 2") makes some key modifications to
the kernel's strategy to keep page contents intact during writeback.  First, it
provides users (devices and filesystems) of a backing_dev_info the ability to
declare whether or not it is necessary to ensure that page contents cannot
change during writeout, whereas the current code assumes that this is true.
Second, it relaxes the wait_on_page_writeback calls so that they only occur if
something needs it.  Third, it fixes up (most of) the remaining disk-based
filesystems to use this improved conditional-wait logic in the hopes of
providing stable page writes on all filesystems, when needed.

It is hoped that (for people not using checksumming devices, anyway) this
patchset will give back unnecessary performance decreases since the original
stable page write patchset went into 3.0.

Note: Even without this patchset, ext3 is broken on DIF/DIX checksumming
devices.  As a part of the discussion about part 1 of this patch set, I recall
that we reached a consensus that fixing ext3 was too invasive, and that new
deployments could use ext4 instead.  Since we can now test for devices that
want stable page writes, put a warning into ext3.

This patchset has been tested on 3.7.0-rc6 on x64 with significant speedups for
some hardware, and (afaict) no regressions.

For the next phase, I'll explore changing md-raid5 and iscsi to use stable page
writes, and figuring out how stable page writes intersects with the networked
filesystems.  In the meantime, this part 2 should alleviate some user pain.

--D
