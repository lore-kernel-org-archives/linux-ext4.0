From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Fix deadlock in ext4_write_begin() and
	ext4_da_write_begin()
Date: Sun, 22 Feb 2009 21:16:35 -0500
Message-ID: <20090223021635.GM17066@mit.edu>
References: <1235053488-16937-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:54786 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435AbZBWCQl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 22 Feb 2009 21:16:41 -0500
Content-Disposition: inline
In-Reply-To: <1235053488-16937-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 19, 2009 at 03:24:48PM +0100, Jan Kara wrote:
> Functions ext4_write_begin() and ext4_da_write_begin() call
> grab_cache_page_write_begin() without AOP_FLAG_NOFS. Thus it
> can happen that page reclaim is triggered in that function
> and it recurses back into the filesystem (or some other filesystem).
> But this can lead to various problems as a transaction is already
> started at that point. Add the necessary flag.
> 
> (Reported in http://bugzilla.kernel.org/show_bug.cgi?id=11688)
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, queued.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

						- Ted
