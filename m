From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [Ext4][Bug] Deadlock in ext4 with memcg enabled.
Date: Mon, 18 May 2015 11:46:16 -0400
Message-ID: <20150518154616.GC4180@thunk.org>
References: <5559965B.5080006@kyup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Nikolay Borisov <kernel@kyup.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5559965B.5080006@kyup.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, May 18, 2015 at 10:35:55AM +0300, Nikolay Borisov wrote:
> The conclusion that I've drawn looking from the code and some offline
> discussions is that when fsync is requested ext4 starts marking pages
> for writeback (ext4_writepages). I think some heavy inlining is
> happening and ext4_map_blocks is being called from:
> 
>  ext4_writepages->mpage_map_and_submit_extent -> mpage_map_one_extent ->
> ext4_map_blocks
> 
> which in turn when trying to write the pages exceeds the memory cgroup
> limit which triggers the memory freeing logic. This, in turn, executes
> the wait_on_page_writeback(page) in shrink_page_list. E.g. the the memcg
> sees a page as being marked for writeback (presumably this is the same
> page which caused the OOM) so it sleeps to wait for the page to be
> written back, but since it is the writeback path that executed the page
> shrinking it causes a deadlock.
> 
> This deadlock then causes other processes on the system to enter D
> state, waiting on trying to acquire a certain inode->i_mutex.

What *should* be happening is that the memory allocations taking place
in find_or_create_page when called by grow_dev_page() should be done
with GFP_NOFS (i.e., the __GFP_FS flag should be masked out).

I think you're right, but I view this as a mm bug; the memory
allocation should have been properly executed with GFP_NOFS so the
memory allocator should know that it can't recurse into page cleaner.
In this case, it looks like it's not doing this, but it is trying to
wait for a page to be cleaned, which is just as bad.

Have you checked to see if this problem has fixed in newer kernels?

     	 	    	   		- Ted
