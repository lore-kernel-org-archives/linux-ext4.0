From: Theodore Tso <tytso@mit.edu>
Subject: Re: ENOSPC returned during writepages
Date: Wed, 20 Aug 2008 15:34:02 -0400
Message-ID: <20080820193402.GG8109@mit.edu>
References: <20080820054339.GB6381@skywalker> <20080820104644.GA11267@skywalker> <20080820115331.GA9965@mit.edu> <20080820192536.GF3392@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:60043 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751593AbYHTTeJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 20 Aug 2008 15:34:09 -0400
Content-Disposition: inline
In-Reply-To: <20080820192536.GF3392@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 20, 2008 at 01:25:36PM -0600, Andreas Dilger wrote:
> What I think makes sense, however, is that if freeblocks < $threshold that
> a global spinlock is taken and the percpu_counter_sum() is done under the
> lock before deciding if enough space is left.  Since it is impossible that
> the other CPUs get below -FBC_BATCH away from the correct free space they
> should all get the spinlock at the same time when we get too low.

Yep, I agree.  I suggested something very similar as my first suggestion.

I do think though that we need to rationalize the percpu_counter
interface, though; those are two separable issues, and both IMHO need
fixing...  The fact that we have a #ifdef CONFIG_SMP in
fs/ext4/inode.c and we are doing wierd things with percpu_counter_sum
and percpu_counter_sum_and_set is ugly.  And it would be good if most
of the time we can avoid taking the filesystem-level spinlock, and
rely on the percpu_counter except when we start getting low on space.

     	    		   	       	  	- Ted
