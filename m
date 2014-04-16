From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/3 v2] fs: move falloc collapse range check into the
 filesystem methods
Date: Tue, 15 Apr 2014 22:55:21 -0400
Message-ID: <20140416025521.GC21807@thunk.org>
References: <1397580076-19826-1-git-send-email-lczerner@redhat.com>
 <1397580076-19826-3-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	xfs@oss.sgi.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1397580076-19826-3-git-send-email-lczerner@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Apr 15, 2014 at 06:41:16PM +0200, Lukas Czerner wrote:
> Currently in do_fallocate in collapse range case we're checking whether
> offset + len is not bigger than i_size. However there is nothing which
> would prevent i_size from changing so the check is pointless. It should
> be done in the file system itself and the file system needs to make sure
> that i_size is not going to change. The i_size check for the other
> fallocate modes are also done in the filesystems.
> 
> As it is now we can easily crash kernel by having two processes doing
> truncate and fallocate collapse range at the same time. This can be
> reproduced on ext4 and it is theoretically possible on xfs even though I
> was not able to trigger it with this simple test.
> 
> This commit removes the check from do_fallocate and adds it to the file
> system.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> Acked-by: Dave Chinner <david@fromorbit.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks, updated.

						- Ted
