From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/2] ext2, ext3: speed up file create workloads
Date: Thu, 6 Jan 2011 15:47:35 +0100
Message-ID: <20110106144735.GJ4641@quack.suse.cz>
References: <4CFE7347.8030807@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:43736 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752749Ab1AFOrk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 6 Jan 2011 09:47:40 -0500
Content-Disposition: inline
In-Reply-To: <4CFE7347.8030807@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 07-12-10 11:47:51, Eric Sandeen wrote:
> The addition of 64k block capability in the rec_len_from_disk
> and rec_len_to_disk functions added a bit of math overhead which
> slows down file create workloads needlessly when the architecture
> cannot even support 64k blocks, thanks to page size limits.
> 
> The directory entry checking can also be optimized a bit
> by sprinkling in some unlikely() conditions to move the
> error handling out of line.
> 
> These 2 patches speed up a bonnie++ file creation workload for
> me by several percent on ext2 & ext3.
  Thanks. I've merged both patches into my tree.

							Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
