From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] allow goal inode to be specified
Date: Sat, 13 Jun 2009 11:48:11 -0400
Message-ID: <20090613154811.GL24336@mit.edu>
References: <20090610202702.GI9002@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:44474 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753003AbZFMPsO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 13 Jun 2009 11:48:14 -0400
Content-Disposition: inline
In-Reply-To: <20090610202702.GI9002@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 10, 2009 at 02:27:02PM -0600, Andreas Dilger wrote:
> Allow a goal inode to be specified when allocating new inodes.
> If the goal is within the range of valid inodes use this in
> preference to one of the other target inode heuristics (Orlov or
> parent directory).
> 
> The goal inode can be specified via /sys/fs/{dev}/inode_goal for
> testing inode allocation beyond 2^32 blocks on very large filesystems,
> and in the future will be used for large xattr inode allocation.

This patch didn't quite apply against the mainline ext4, and in
addition it conflicted with a patch to keep the choice of Orlov topdir
inode numbers stable for the purposes of benchmarking.  So instead I
dropped the following two patches into the ext4 patch queue.

	    	      	  	       	   	- Ted
