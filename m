From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH]ext4: delete dead code
Date: Sun, 17 Apr 2011 20:19:18 -0400
Message-ID: <20110418001918.GC3806@thunk.org>
References: <1302747032.3981.181.camel@sli10-conroe>
 <20110415041610.GD29512@mtj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Shaohua Li <shaohua.li@intel.com>, linux-ext4@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:49137 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751411Ab1DRATV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 17 Apr 2011 20:19:21 -0400
Content-Disposition: inline
In-Reply-To: <20110415041610.GD29512@mtj.dyndns.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 15, 2011 at 01:16:10PM +0900, Tejun Heo wrote:
> On Thu, Apr 14, 2011 at 10:10:32AM +0800, Shaohua Li wrote:
> > percpu_counter_sum_positive never returns negative.
> > 
> > Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> 
> Acked-by: Tejun Heo <tj@kernel.org>
> 
> Ted, can you please pick this up?

Added to the ext4 tree.

						- Ted
