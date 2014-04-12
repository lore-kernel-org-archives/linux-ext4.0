From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/4] fs: Prevent doing FALLOC_FL_ZERO_RANGE on append
 only file
Date: Sat, 12 Apr 2014 09:49:05 -0400
Message-ID: <20140412134905.GB13837@thunk.org>
References: <1397242665-2183-1-git-send-email-lczerner@redhat.com>
 <1397242665-2183-2-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	xfs@oss.sgi.com, ceph-devel@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53167 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753525AbaDLNtJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 12 Apr 2014 09:49:09 -0400
Content-Disposition: inline
In-Reply-To: <1397242665-2183-2-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 11, 2014 at 08:57:43PM +0200, Lukas Czerner wrote:
> Currently punch hole and collapse range fallocate operation are not
> allowed on append only file. This should be case for zero range as well.
> Fix it.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Looks good to me.  If people don't object, I'll carry this in the ext4
tree for merging in 3.15, since this is a bug fix...

     	 	    	  	     	  - Ted
