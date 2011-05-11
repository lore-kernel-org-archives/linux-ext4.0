From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 0/3] Rewrite ext4_page_mkwrite, fix fs freezing
Date: Tue, 10 May 2011 20:30:12 -0400
Message-ID: <20110511003012.GC6933@thunk.org>
References: <1305066574-1573-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:46619 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790Ab1EKAaR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 May 2011 20:30:17 -0400
Content-Disposition: inline
In-Reply-To: <1305066574-1573-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 11, 2011 at 12:29:31AM +0200, Jan Kara wrote:
> 
>   following three patches reimplement ext4_page_mkwrite() so that it returns
> locked pages (which is necessary for stable pages work and also for fixing of
> freezing code). As a bonus we also avoid taking i_alloc_sem as it's not
> necessary and use generic block_page_mkwrite() helper. The common delalloc
> path should be more straightforward now.

How does this relate to Darrick Wong's patches?  Are your patches in
addition to or instead of his?

					- Ted
