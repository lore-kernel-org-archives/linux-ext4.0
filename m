From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix performance regression in ext4_writepages
Date: Wed, 16 Oct 2013 23:40:17 -0400
Message-ID: <20131017034017.GC11932@thunk.org>
References: <1381886317-19539-1-git-send-email-ming.lei@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
To: Ming Lei <ming.lei@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1381886317-19539-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Oct 16, 2013 at 09:18:37AM +0800, Ming Lei wrote:
> Commit 4e7ea81db5(ext4: restructure writeback path) introduces
> another performance regression on random write:
> 
> - one more page may be added to ext4 extent in mpage_prepare_extent_to_map,
>   and will be submitted for I/O so nr_to_write will become -1 before 'done'
>   is set
> 
> - the worse thing is that dirty pages may still be retrieved from page
>   cache after nr_to_write becomes negative, so lots of small chunks can be
>   submitted to block device when page writeback is catching up with write
>   path, and performance is hurted.
> 
> On one arm A15 board with sata 3.0 SSD(CPU: 1.5GHz dura core, RAM: 2GB,
> SATA controller: 3.0Gbps), this patch can improve below test's result
> from 157MB/sec to 174MB/sec(>10%):
> 
> 	dd if=/dev/zero of=./z.img bs=8K count=512K
> 
> The above test is actually prototype of block write in bonnie++ utility.
> 
> This patch makes sure no more pages than nr_to_write can be added to extent
> for mapping, so that nr_to_write won't become negative.
> 
> Cc: Ted Tso <tytso@mit.edu>
> Cc: linux-ext4@vger.kernel.org
> Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
> Acked-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Ming Lei <ming.lei@canonical.com>

Thanks, applied.

					- Ted
