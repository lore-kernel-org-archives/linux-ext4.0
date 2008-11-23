From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH -V4] ext4: Fix lockdep recursive locking warning
Date: Sun, 23 Nov 2008 13:32:08 -0500
Message-ID: <20081123183208.GD26473@mit.edu>
References: <1227285646-16263-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20081122204625.GF9150@mit.edu> <20081123024911.GG9150@mit.edu> <20081123163349.GB17002@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:61561 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750884AbYKWSfj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 23 Nov 2008 13:35:39 -0500
Content-Disposition: inline
In-Reply-To: <20081123163349.GB17002@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Nov 23, 2008 at 10:03:49PM +0530, Aneesh Kumar K.V wrote:
> 
> How about the below patch. We can have more than 2 groups in a page
> depending on the page size and blocksize. So instead of using
> single_depth I guess we should use the relative group number ?.

That should work.  The maximum number of subclasses that we can have
by default is 8.  With 16k pages, that will barely be enough for 1k
blocksize file systems (since we lock alloc_sem for
page_size/(2*fs_block_size) block groups).  If we need more than that,
we might be better off just locking the entire filesystem against
block allocations, since after all this is a pretty rare case; it's
used only when we resize or when the filesystem is getting mounted.

     	       	  	    	 - Ted
