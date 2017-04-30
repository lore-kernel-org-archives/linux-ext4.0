From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] jbd2: Fix dbench4 performance regression for 'nobarrier'
 mounts
Date: Sat, 29 Apr 2017 21:14:18 -0400
Message-ID: <20170430011418.4s6ncc4v5nwe75ah@thunk.org>
References: <20170428095934.11583-1-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        stable@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170428095934.11583-1-jack@suse.cz>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Apr 28, 2017 at 11:59:34AM +0200, Jan Kara wrote:
> Commit b685d3d65ac7 "block: treat REQ_FUA and REQ_PREFLUSH as
> synchronous" removed REQ_SYNC flag from WRITE_FUA implementation. Since
> JBD2 strips REQ_FUA and REQ_FLUSH flags from submitted IO when the
> filesystem is mounted with nobarrier mount option, journal superblock
> writes ended up being async writes after this patch and that caused
> heavy performance regression for dbench4 benchmark with high number of
> processes. In my test setup with HP RAID array with non-volatile write
> cache and 32 GB ram, dbench4 runs with 8 processes regressed by ~25%.
> 
> Fix the problem by making sure journal superblock writes are always
> treated as synchronous since they generally block progress of the
> journalling machinery and thus the whole filesystem.
> 
> Fixes: b685d3d65ac791406e0dfd8779cc9b3707fea5a3
> CC: stable@vger.kernel.org
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

						- Ted
