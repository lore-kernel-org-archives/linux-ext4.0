From: tytso@mit.edu
Subject: Re: [PATCH 3/3] ext4: consolidate in_range() definisions
Date: Thu, 4 Mar 2010 00:19:54 -0500
Message-ID: <20100304051954.GA15028@thunk.org>
References: <1267627246-12863-1-git-send-email-akinobu.mita@gmail.com>
 <1267627246-12863-3-git-send-email-akinobu.mita@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@sun.com>
To: Akinobu Mita <akinobu.mita@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:46908 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750718Ab0CDFT5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 4 Mar 2010 00:19:57 -0500
Content-Disposition: inline
In-Reply-To: <1267627246-12863-3-git-send-email-akinobu.mita@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 03, 2010 at 11:40:46PM +0900, Akinobu Mita wrote:
> There are same in_range() macro definisions in mballoc.h and
> balloc.c. This consolidates these in_range() definisions and
> use it in extents.c, too
> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: Andreas Dilger <adilger@sun.com>
> Cc: linux-ext4@vger.kernel.org
> Cc: "Theodore Ts'o" <tytso@mit.edu>

I've added all three to the ext4 patch queue, thanks.

     	       	     	    	 - Ted
