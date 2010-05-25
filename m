From: tytso@mit.edu
Subject: Re: [PATCH 2/2] ext4: Fix compat EXT4_IOC_ADD_GROUP
Date: Tue, 25 May 2010 11:25:42 -0400
Message-ID: <20100525152542.GN5556@thunk.org>
References: <1274398223.2257.0.camel@localhost>
 <1274398462.2257.7.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org
To: Ben Hutchings <ben@decadent.org.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:37574 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757090Ab0EYPZp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 May 2010 11:25:45 -0400
Content-Disposition: inline
In-Reply-To: <1274398462.2257.7.camel@localhost>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 21, 2010 at 12:34:22AM +0100, Ben Hutchings wrote:
> struct ext4_new_group_input needs to be converted because u64 has
> only 32-bit alignment on some 32-bit architectures, notably i386.
> 
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---

Thanks for your patches.  Both have been applied to the ext4 tree.

       	   		       	    	 - Ted
