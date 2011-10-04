From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fsprogs: Fix thinko in ext2fs_initialize bigalloc
 case
Date: Mon, 3 Oct 2011 23:24:15 -0400
Message-ID: <20111004032415.GL6684@thunk.org>
References: <4E8A30AE.10805@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:51497 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753480Ab1JDDYR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 3 Oct 2011 23:24:17 -0400
Content-Disposition: inline
In-Reply-To: <4E8A30AE.10805@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 03, 2011 at 05:01:18PM -0500, Eric Sandeen wrote:
> Surely we should be setting s_clusters_per_group, not
> s_blocks_per_group, to EXT2_MAX_CLUSTERS_PER_GROUP here.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Yes, oops.  Good catch, applied.

						- Ted
