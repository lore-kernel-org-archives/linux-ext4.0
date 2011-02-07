From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 0/5] mballoc: trivial code cleanup
Date: Mon, 7 Feb 2011 12:41:25 -0500
Message-ID: <20110207174125.GB3457@thunk.org>
References: <4D4E294E.4080507@coly.li>
 <AANLkTimT3i1oOSh02oTtvN_OmHcYwhNOABLV4cT7VV5p@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: i@coly.li, linux-ext4@vger.kernel.org,
	Alex Tomas <alex@clusterfs.com>,
	Theodore Tso <tytso@google.com>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:53783 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753791Ab1BGRla (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 Feb 2011 12:41:30 -0500
Content-Disposition: inline
In-Reply-To: <AANLkTimT3i1oOSh02oTtvN_OmHcYwhNOABLV4cT7VV5p@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Feb 06, 2011 at 10:43:58AM +0200, Amir Goldstein wrote:
> When looking at alloc_sem, I realized that it is only needed to avoid
> race with adjacent group buddy initialization.

Actually, alloc_sem is used to protect all of the block group specific
data structures; the buddy bitmap counters, adjusting the buddy bitmap
itself, the largest free order in a block group, etc.  So even in the
case where block_size == page_size, alloc_sem is still needed!

     	   	      	 	    	      	 - Ted
