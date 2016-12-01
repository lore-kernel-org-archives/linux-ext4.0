From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/3] ext4: don't read out of bounds when checking for
 in-inode xattrs
Date: Thu, 1 Dec 2016 14:52:21 -0500
Message-ID: <20161201195221.bdij6drhjofzbbq5@thunk.org>
References: <1480228786-106775-1-git-send-email-ebiggers@google.com>
 <1480228786-106775-2-git-send-email-ebiggers@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>
To: Eric Biggers <ebiggers@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:54716 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934023AbcLATwW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 1 Dec 2016 14:52:22 -0500
Content-Disposition: inline
In-Reply-To: <1480228786-106775-2-git-send-email-ebiggers@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Nov 26, 2016 at 10:39:45PM -0800, Eric Biggers wrote:
> With i_extra_isize equal to or close to the available space, it was
> possible for us to read past the end of the inode when trying to detect
> or validate in-inode xattrs.  Fix this by checking for the needed extra
> space first.
> 
> This patch shouldn't have any noticeable effect on
> non-corrupted/non-malicious filesystems.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Thanks, applied with the style nits that Andreas pointed out.

		     	       	    	 - Ted
