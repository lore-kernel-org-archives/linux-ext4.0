From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 4/4] ext4: Wait for proper transaction commit on fsync
Date: Sun, 15 Nov 2009 19:46:41 -0500
Message-ID: <20091116004641.GM4323@mit.edu>
References: <1256647729-29834-1-git-send-email-jack@suse.cz> <1256647729-29834-5-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:41721 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751962AbZKPAsi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 15 Nov 2009 19:48:38 -0500
Content-Disposition: inline
In-Reply-To: <1256647729-29834-5-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 27, 2009 at 01:48:49PM +0100, Jan Kara wrote:
> +	/*
> +	 * Transactions that contain inode's metadata needed to complete
> +	 * fsync and fdatasync, respectively.
> +	 */
> +	atomic_t i_sync_tid;
> +	atomic_t i_datasync_tid;

Why do we need an atomic_t here at all?  It's not clear it's
necessary.  What specific race are you worried about?

	    	 	       	       - Ted
