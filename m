From: Josef Bacik <jbacik@redhat.com>
Subject: Re: [RFC] JBD ordered mode rewrite
Date: Thu, 6 Mar 2008 14:05:03 -0500
Message-ID: <200803061405.03721.jbacik@redhat.com>
References: <20080306174209.GA14193@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:59497 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752308AbYCFTFS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 6 Mar 2008 14:05:18 -0500
In-Reply-To: <20080306174209.GA14193@duck.suse.cz>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thursday 06 March 2008 12:42:09 pm Jan Kara wrote:
>   Hi,
>
>   Below is my rewrite of ordered mode in JBD. Now we don't have a list of
> data buffers that need syncing on transaction commit but a list of inodes
> that need writeout during commit. This brings all sorts of advantages such
> as possibility to get rid of journal heads and buffer heads for data
> buffers in ordered mode, better ordering of writes on transaction commit,
> simplification of some JBD code, no more anonymous pages when truncate of
> data being committed happens. The patch has survived some light testing
> but it still has some potential of eating your data so beware :) I've run
> dbench to see whether we didn't decrease performance by different handling
> of truncate and the throughput I'm getting on my machine is the same (OK,
> is lower by 0.5%) if I disable the code in truncate waiting for commit to
> finish... Also the throughput of dbench is about 2% better with my patch
> than with current JBD.
>   Any comments or testing most welcome.
>
> 									Honza

Just one nit, doesn't compile properly when jbd/ext3 are modules :).  Thanks 
much,

Josef
