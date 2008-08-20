From: Theodore Tso <tytso@mit.edu>
Subject: Re: ENOSPC returned during writepages
Date: Wed, 20 Aug 2008 17:55:42 -0400
Message-ID: <20080820215542.GD16634@mit.edu>
References: <20080820054339.GB6381@skywalker> <20080820104644.GA11267@skywalker> <20080820115331.GA9965@mit.edu> <1219265808.7895.14.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:56641 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752655AbYHTV7G (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 20 Aug 2008 17:59:06 -0400
Content-Disposition: inline
In-Reply-To: <1219265808.7895.14.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 20, 2008 at 01:56:48PM -0700, Mingming Cao wrote:
> > BTW, I was looking at the percpu_counter interface, and I'm confused
> > why we have percpu_counter_sum_and_set() and percpu_counter_sum().  If
> > we're taking the fbc->lock to calculate the precise value of the
> > counter, why not simply set fbc->count?  
> 
> I added the percpu_count_sum_and _set() interface, when addingdelalloc
> block reservation. I agree it make sense to clean up current all the
> user of percpu_counter_sum() and replace with
> percpu_counter_sum_and_set(), just hasn't get chance to clean up yet.

Why not make percpu_counter_sum() always do sum_and_set, and change
the ext4 calls to use percpu_counter_sum()?  In fact, I'm wondering
why you didn't do that in the first place?  Was that your trying to be
as conservative as possible with respect to not changing things?

   		   	    	 	    - Ted
