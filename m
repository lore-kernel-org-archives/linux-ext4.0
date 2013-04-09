From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix free space estimate in ext4_nonda_switch()
Date: Tue, 9 Apr 2013 09:28:19 -0400
Message-ID: <20130409132819.GD12050@thunk.org>
References: <20130403171931.GC3006@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:60617 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934626Ab3DIN2V (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Apr 2013 09:28:21 -0400
Content-Disposition: inline
In-Reply-To: <20130403171931.GC3006@wallace>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 03, 2013 at 01:19:31PM -0400, Eric Whitney wrote:
> Values stored in s_freeclusters_counter and s_dirtyclusters_counter
> are both in cluster units.  Remove the cluster to block conversion
> applied to s_freeclusters_counter causing an inflated estimate of
> free space because s_dirtyclusters_counter is not similarly
> converted.  Rename free_blocks and dirty_blocks to better reflect
> the units these variables contain to avoid future confusion.  This
> fix corrects ENOSPC failures for xfstests 127 and 231 on bigalloc
> file systems.
> 
> Signed-off-by: Eric Whitney <enwlinux@gmail.com>

Hi Eric,

This patch looks good.  Thanks for submitting it!!

I've applied it to the dev branch for testing.

					- Ted
