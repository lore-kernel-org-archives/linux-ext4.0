From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4 extent status tree LRU locking
Date: Mon, 17 Jun 2013 22:47:27 -0400
Message-ID: <20130618024727.GA24479@thunk.org>
References: <51B7B128.60909@intel.com>
 <20130614140940.GA20401@gmail.com>
 <20130614140215.GA1017@thunk.org>
 <20130614170028.GA21544@gmail.com>
 <20130614180054.GB1017@thunk.org>
 <20130617101033.GA17828@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Dave Hansen <dave.hansen@intel.com>, linux-ext4@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>, Jan kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130617101033.GA17828@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> Subject: [PATCH v2] ext4: improve extent cache shrink mechanism to avoid to burn CPU time
> 
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> Now we maintain an proper in-order LRU list in ext4 to reclaim entries
> from extent status tree when we are under heavy memory pressure.  For
> keeping this order, a spin lock is used to protect this list.  But this
> lock burns a lot of CPU time.  We can use the following steps to trigger
> it.
> 
>   % cd /dev/shm
>   % dd if=/dev/zero of=ext4-img bs=1M count=2k
>   % mkfs.ext4 ext4-img
>   % mount -t ext4 -o loop ext4-img /mnt
>   % cd /mnt
>   % for ((i=0;i<160;i++)); do truncate -s 64g $i; done
>   % for ((i=0;i<160;i++)); do cp $i /dev/null &; done
>   % perf record -a -g
>   % perf report
> 
> This commit tries to fix this problem.  Now a new member called
> i_touch_when is added into ext4_inode_info to record the last access
> time for an inode.  Meanwhile we never need to keep a proper in-order
> LRU list.  So this can avoid to burns some CPU time.  When we try to
> reclaim some entries from extent status tree, we use list_sort() to get
> a proper in-order list.  Then we traverse this list to discard some
> entries.  In ext4_sb_info, we use s_es_last_sorted to record the last
> time of sorting this list.  When we traverse the list, we skip the inode
> that is newer than this time, and move this inode to the tail of LRU
> list.  When the head of the list is newer than s_es_last_sorted, we will
> sort the LRU list again.
> 
> In this commit, we break the loop if s_extent_cache_cnt == 0 because
> that means that all extents in extent status tree have been reclaimed.
> 
> Meanwhile in this commit, ext4_es_{un}register_shrinker()'s prototype is
> changed to save a local variable in these functions.
> 
> Reported-by: Dave Hansen <dave.hansen@intel.com>
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>

Applied, thanks.

					- Ted
