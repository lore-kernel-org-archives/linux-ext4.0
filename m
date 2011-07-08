From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 12/23] ext4: convert s_{dirty,free}blocks_counter to
 s_{dirty,free}clusters_counter
Date: Fri, 8 Jul 2011 18:41:06 -0400
Message-ID: <20110708224106.GH3331@thunk.org>
References: <1309970166-11770-1-git-send-email-tytso@mit.edu>
 <1309970166-11770-13-git-send-email-tytso@mit.edu>
 <05C9E747-3956-4E45-8973-C1574CE88575@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:49620 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752067Ab1GHWlH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 8 Jul 2011 18:41:07 -0400
Content-Disposition: inline
In-Reply-To: <05C9E747-3956-4E45-8973-C1574CE88575@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 06, 2011 at 04:59:59PM -0600, Andreas Dilger wrote:
> On 2011-07-06, at 10:35 AM, Theodore Ts'o wrote:
> > Convert the percpu counters s_dirtyblocks_counter and
> > s_freeblocks_counter in struct ext4_super_info to be
> > s_dirtyblocks_counter and s_freeclusters_counter.
> 
> Commit comment is incorrect.  Should be "s_dirtyclusters_counter"
> at the second usage.

Thanks for pointing that out, fixed.

					- Ted
