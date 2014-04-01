From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] ext4: Fix flag handling in
 ext4_split_convert_extents()
Date: Tue, 1 Apr 2014 00:57:08 -0400
Message-ID: <20140401045708.GM4911@thunk.org>
References: <1396257094-10386-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, dan.carpenter@oracle.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:48149 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751057AbaDAE5P (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Apr 2014 00:57:15 -0400
Content-Disposition: inline
In-Reply-To: <1396257094-10386-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 31, 2014 at 11:11:33AM +0200, Lukas Czerner wrote:
> In commit 1f0e51771281 "ext4: Introduce FALLOC_FL_ZERO_RANGE flag
> for fallocate" we've introduced wrong flag handling. Fix it.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Thanks, I've merged this into the base zero_range patch.

	     	    	      	  - Ted
