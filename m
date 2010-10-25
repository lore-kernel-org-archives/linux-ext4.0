From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Check return value of sb_getblk() and friends
Date: Mon, 25 Oct 2010 10:51:02 -0400
Message-ID: <20101025145102.GE16981@thunk.org>
References: <1287476529-5314-1-git-send-email-namhyung@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Namhyung Kim <namhyung@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:46709 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753311Ab0JYOvG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Oct 2010 10:51:06 -0400
Content-Disposition: inline
In-Reply-To: <1287476529-5314-1-git-send-email-namhyung@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 19, 2010 at 05:22:09PM +0900, Namhyung Kim wrote:
> Fail block allocation if sb_getblk() returns NULL. In that case,
> sb_find_get_block() also likely to fail so that it should skip
> calling ext4_forget().
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>

Thanks, I've added this patch to the ext4 patch queue.

       	    	       	     	    - Ted
