From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4 extent status tree LRU locking
Date: Wed, 12 Jun 2013 16:48:54 -0400
Message-ID: <20130612204854.GA12456@thunk.org>
References: <51B7B128.60909@intel.com>
 <20130612071735.GB29898@gmail.com>
 <51B88F1A.5000909@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Jan kara <jack@suse.cz>, gnehzuil.liu@gmail.com
To: Dave Hansen <dave.hansen@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <51B88F1A.5000909@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jun 12, 2013 at 08:09:14AM -0700, Dave Hansen wrote:
> You could make per-cpu LRUs, and batch movement on and off the global
> LRU once the local ones get to be a certain size.  Or, you could keep
> them cpu-local *until* the shrinker is called, when the shrinker could
> go drain all the percpu ones.
> 
> Or, you could tag each extent in memory with its last-used time.  You
> write an algorithm to go and walk the tree and attempt to _generally_
> free the oldest objects out of a limited window.

Another approach might be to tag each inode with the last time an
ext4_map_blocks() was called on the inode, and keep an unsorted list
of inodes which has one or more entries in the extent cache.

When we decide to discard entries from the extent cache, we should
drop all of the entries for the inode --- and then when we read in
part of the extent tree leaf block, we should create entries in the
extent cache for all of the extents found in the extent leaf block.

       	     	     	    	    	     - Ted
