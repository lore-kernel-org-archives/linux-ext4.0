From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [5/6] mke2fs: Use unix_discard() for discards
Date: Tue, 23 Nov 2010 10:18:18 -0500
Message-ID: <20101123151818.GE32759@thunk.org>
References: <1290087521-9123-6-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: sandeen@redhat.com, adilger@dilger.ca, linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:52325 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753516Ab0KWPSs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 23 Nov 2010 10:18:48 -0500
Content-Disposition: inline
In-Reply-To: <1290087521-9123-6-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 18, 2010 at 03:38:40AM -0000, Lukas Czerner wrote:
> There is generic discard function in struct_io_manager, or in
> unix_io_manager to be specific. So use this instead of
> mke2fs_discard_blocks().
> 
> Since mke2fs_discard_blocks() is not used anymore (and should not be)
> remove it.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Changed to use io_channel_discard() instead of derferencing the
function pointer directly.  I've applied this to the master branch.

	 	 	    	 	 - Ted
