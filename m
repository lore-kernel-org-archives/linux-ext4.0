From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET v2 block/for-4.2/writeback] ext4: implement cgroup
 writeback support
Date: Thu, 16 Jul 2015 19:37:11 -0400
Message-ID: <20150716233711.GA15934@mtj.duckdns.org>
References: <1434495193-31182-1-git-send-email-tj@kernel.org>
 <20150712180520.GE18734@mtj.duckdns.org>
 <20150716194058.GZ15934@mtj.duckdns.org>
 <20150716232159.GN7943@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, adilger.kernel@dilger.ca,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	lizefan@huawei.com, cgroups@vger.kernel.org, hannes@cmpxchg.org,
	kernel-team@fb.com, linux-ext4@vger.kernel.org, axboe@kernel.dk
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150716232159.GN7943@dastard>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hello, Dave.

On Fri, Jul 17, 2015 at 09:21:59AM +1000, Dave Chinner wrote:
> Tejun, is this all that needs to be done to support cgroup aware
> writeback in a filesystem (i.e. wbc_init_bio, wbc_account_io in the
> writepage path, superblock flag)?

Yes, this is about it.  It gets slightly more complex if bio's are
bounced to another task as they would need to be associated with the
current cgroup.

The following is from Documentation/cgroups/blkio-controller.txt

Filesystem support for cgroup writeback
---------------------------------------

A filesystem can make writeback IOs cgroup-aware by updating
address_space_operations->writepage[s]() to annotate bio's using the
following two functions.

* wbc_init_bio(@wbc, @bio)

  Should be called for each bio carrying writeback data and associates
  the bio with the inode's owner cgroup.  Can be called anytime
  between bio allocation and submission.

* wbc_account_io(@wbc, @page, @bytes)

  Should be called for each data segment being written out.  While
  this function doesn't care exactly when it's called during the
  writeback session, it's the easiest and most natural to call it as
  data segments are added to a bio.

With writeback bio's annotated, cgroup support can be enabled per
super_block by setting MS_CGROUPWB in ->s_flags.  This allows for
selective disabling of cgroup writeback support which is helpful when
certain filesystem features, e.g. journaled data mode, are
incompatible.

wbc_init_bio() binds the specified bio to its cgroup.  Depending on
the configuration, the bio may be executed at a lower priority and if
the writeback session is holding shared resources, e.g. a journal
entry, may lead to priority inversion.  There is no one easy solution
for the problem.  Filesystems can try to work around specific problem
cases by skipping wbc_init_bio() or using bio_associate_blkcg()
directly.

Thanks.

-- 
tejun
