From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4 extent status tree LRU locking
Date: Fri, 14 Jun 2013 10:02:15 -0400
Message-ID: <20130614140215.GA1017@thunk.org>
References: <51B7B128.60909@intel.com>
 <20130614140940.GA20401@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Dave Hansen <dave.hansen@intel.com>, linux-ext4@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>, Jan kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130614140940.GA20401@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jun 14, 2013 at 10:09:40PM +0800, Zheng Liu wrote:
> This commit tries to fix this problem.  Now a new member called
> i_touch_when is added into ext4_inode_info to record the last access
> time for an inode.  Meanwhile we never need to keep a proper in-order
> LRU list.  So this can avoid to burns some CPU time.  When we try to
> reclaim some entries from extent status tree, we use list_sort() to get
> a proper in-order list.  Then we traverse this list to discard some
> entries.

I think this approach is very sound.  I have one reservation, however.
If there are a large number of inodes on this list, list_sort() could
burn a lot of CPU time, especially if the shrinker is called a very
large number of times in a short time period (i.e., when the system is
thrashing, or when one or more memory containers are under a large
amount of memory pressure).

I have a suggestion for how to address this: Keep a timestamp of when
the list last has been sorted in struct ext4_super_info.  When
iterating over the list, looking for a candidate inode, if inode's
i_touch_when is greater than the last time sorted, skip the inode.  If
there are no inodes left in the list, or more than some threshold
inodes have been skipped, only then resort the list (and update the
timestamp in the ext4_super_info structure).

What do you think?

					- Ted
