From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [patch] ext4: testing the wrong variable in ext4_init_pageio()
Date: Fri, 24 Dec 2010 04:57:22 -0500
Message-ID: <20101224095722.GH12763@thunk.org>
References: <20101223190911.GM1936@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Dan Carpenter <error27@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:60540 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750970Ab0LXJ53 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 24 Dec 2010 04:57:29 -0500
Content-Disposition: inline
In-Reply-To: <20101223190911.GM1936@bicker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 23, 2010 at 10:09:11PM +0300, Dan Carpenter wrote:
> This is a copy and paste error.  The intent was to check
> "io_page_cachep".  We tested "io_page_cachep" earlier.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>

Thanks, added to the ext4 patch queue.

					- Ted
