From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: ext4 extent status tree LRU locking
Date: Thu, 13 Jun 2013 21:27:15 +0800
Message-ID: <20130613132715.GA12622@gmail.com>
References: <51B7B128.60909@intel.com>
 <20130612071735.GB29898@gmail.com>
 <51B88F1A.5000909@intel.com>
 <20130612204854.GA12456@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Ts'o <tytso@mit.edu>, Dave Hansen <dave.hansen@intel.com>,
	linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Jan kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130612204854.GA12456@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Ted,

On Wed, Jun 12, 2013 at 04:48:54PM -0400, Theodore Ts'o wrote:
> On Wed, Jun 12, 2013 at 08:09:14AM -0700, Dave Hansen wrote:
> > You could make per-cpu LRUs, and batch movement on and off the global
> > LRU once the local ones get to be a certain size.  Or, you could keep
> > them cpu-local *until* the shrinker is called, when the shrinker could
> > go drain all the percpu ones.
> > 
> > Or, you could tag each extent in memory with its last-used time.  You
> > write an algorithm to go and walk the tree and attempt to _generally_
> > free the oldest objects out of a limited window.
> 
> Another approach might be to tag each inode with the last time an
> ext4_map_blocks() was called on the inode, and keep an unsorted list
> of inodes which has one or more entries in the extent cache.
> 
> When we decide to discard entries from the extent cache, we should
> drop all of the entries for the inode --- and then when we read in
> part of the extent tree leaf block, we should create entries in the
> extent cache for all of the extents found in the extent leaf block.

Thanks for your suggestion.  But, sorry, I couldn't get your point here.
As you suggested above, we can tag each inode with the last access time
when ext4_map_blocks() is called.  Then we will get an unsorted list of
inodes with some extent entries.  When we tries to reclaim some entries
from extent cache, we can call list_sort() to get an sorted list of
inodes and try to reclaim some entries according to the last access
time.  My question is why do we need to drop all of the entries from all
inodes.

Af far as I understand, we can do the following improvement.  We tag the
last access time for each inode.  So that would avoid to move the inode
in lru list frequently.  When we try to reclaim some entries, we call
list_sort() to get a sorted lru list, and drop some entries from lru
list.  Please correct me if I misunderstood.

For creating all extent leaf blocks, that is another improvement.  I
will try to add it after I solve current problem that Dave reported.

Thanks,
                                                - Zheng
