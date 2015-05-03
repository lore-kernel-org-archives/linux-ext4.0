From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Fix data corruption caused by unwritten and
 delayed extents
Date: Sat, 2 May 2015 22:31:06 -0400
Message-ID: <20150503023106.GE10014@thunk.org>
References: <1429711576-15006-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, stable@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1429711576-15006-1-git-send-email-lczerner@redhat.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Apr 22, 2015 at 04:06:16PM +0200, Lukas Czerner wrote:
> Currently it is possible to lose whole file system block worth of data
> when we hit the specific interaction with unwritten and delayed extents
> in status extent tree.
> 
> The problem is that when we insert delayed extent into extent status
> tree the only way to get rid of it is when we write out delayed buffer.
> However there is a limitation in the extent status tree implementation
> so that when inserting unwritten extent should there be even a single
> delayed block the whole unwritten extent would be marked as delayed.
> 
> At this point, there is no way to get rid of the delayed extents,
> because there are no delayed buffers to write out. So when a we write
> into said unwritten extent we will convert it to written, but it still
> remains delayed.
> 
> When we try to write into that block later ext4_da_map_blocks() will set
> the buffer new and delayed and map it to invalid block which causes
> the rest of the block to be zeroed loosing already written data.
> 
> For now we can fix this by simply not allowing to set delayed status on
> written extent in the extent status tree. Also add WARN_ON() to make
> sure that we notice if this happens in the future.
> 
> This problem can be easily reproduced by running the following xfs_io.
> 
> xfs_io -f -c "pwrite -S 0xaa 4096 2048" \
>           -c "falloc 0 131072" \
>           -c "pwrite -S 0xbb 65536 2048" \
>           -c "fsync" /mnt/test/fff
> 
> echo 3 > /proc/sys/vm/drop_caches
> xfs_io -c "pwrite -S 0xdd 67584 2048" /mnt/test/fff
> 
> This can be theoretically also reproduced by at random by running fsx,
> but it's not very reliable, though on machines with bigger page size
> (like ppc) this can be seen more often (especially xfstest generic/127)
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> Cc: stable@vger.kernel.org

Applied, thanks.

						- Ted
