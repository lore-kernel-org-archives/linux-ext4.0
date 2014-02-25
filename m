From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] util-linux/fallocate: introduce an option -c to support
 FALLOC_FL_COLLAPSE_RANGE
Date: Wed, 26 Feb 2014 06:31:01 +1100
Message-ID: <20140225193101.GW13647@dastard>
References: <alpine.LFD.2.00.1402181001530.2216@localhost.localdomain>
 <1393355305-12009-1-git-send-email-dongsu.park@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Namjae Jeon <linkinjeon@gmail.com>, linux-fsdevel@vger.kernel.org,
	xfs@oss.sgi.com, linux-ext4@vger.kernel.org, tytso@mit.edu,
	Lukas Czerner <lczerner@redhat.com>,
	Namjae Jeon <namjae.jeon@samsung.com>,
	Ashish Sangwan <a.sangwan@samsung.com>
To: Dongsu Park <dongsu.park@profitbricks.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1393355305-12009-1-git-send-email-dongsu.park@profitbricks.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Feb 25, 2014 at 08:08:25PM +0100, Dongsu Park wrote:
> Introduce a new option -c (or --collapse-range) to support a new flag
> FALLOC_FL_COLLAPSE_RANGE for fallocate(2). It will nullify a particular
> range [offset, offset+len] by shifting extents beyond the range to the
> beginning of the hole.
> 
> To test that, it's necessary to apply kernel patches in the patchset
> "fs: Introduce new flag (FALLOC_FL_COLLAPSE_RANGE) for fallocate" [1],
> as well as "[PATCH v6] ext4: Add support FALLOC_FL_COLLAPSE_RANGE for
> fallocate". [2]
> 
> As discussed in the thread "[PATCH RESEND 3/10] ext4: Add support
> FALLOC_FL_COLLAPSE_RANGE for fallocate", [3] this patch to util-linux
> will be useful for testing collapse-range inside xfstests.

FYI, we've already got support in xfs_io for collapse-range tests
inside xfstests.

http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs/cmds/xfsprogs.git;a=commit;h=ca692f162d36c871c9c1b6169136b2c70503f2d8

There are already several tests that use it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
