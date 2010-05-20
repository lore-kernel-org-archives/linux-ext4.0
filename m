From: tytso@mit.edu
Subject: Re: [PATCH 1/3] quota: use flags interface for dquot alloc/free
 space
Date: Thu, 20 May 2010 18:29:46 -0400
Message-ID: <20100520222946.GD16634@thunk.org>
References: <4BBCFD10.3030504@redhat.com>
 <4BBCFDD1.30505@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:53467 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755028Ab0ETW3v (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 May 2010 18:29:51 -0400
Content-Disposition: inline
In-Reply-To: <4BBCFDD1.30505@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 07, 2010 at 04:49:05PM -0500, Eric Sandeen wrote:
> Switch __dquot_alloc_space and __dquot_free_space to take flags
> to indicate whether to warn and/or to reserve (or free reserve).
> 
> This is slightly more readable at the callpoints, and makes it
> cleaner to add a "nofail" option in the next patch.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Applied to the ext4 patch queue, apologies for the delay.

	       	    	  	 - Ted
