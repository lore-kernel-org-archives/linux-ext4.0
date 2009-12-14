From: tytso@mit.edu
Subject: Re: [PATCH] Ext4: Don't ask about supporting ext2/3 in ext4 if
 ext4 is not configured
Date: Mon, 14 Dec 2009 09:30:00 -0500
Message-ID: <20091214143000.GA4867@thunk.org>
References: <20091214135546.10111.4495.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: torvalds@osdl.org, akpm@linux-foundation.org,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:38181 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757440AbZLNOaU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Dec 2009 09:30:20 -0500
Content-Disposition: inline
In-Reply-To: <20091214135546.10111.4495.stgit@warthog.procyon.org.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 14, 2009 at 01:55:46PM +0000, David Howells wrote:
> Don't offer to build ext2/3 support into ext4 if ext4 itself is not configured
> on.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>

Whoops, nice catch.  Added to the ext4 patch queue, I'll make sure
this gets pushed to Linus during the merge window.

     	  	    	  	     - Ted
