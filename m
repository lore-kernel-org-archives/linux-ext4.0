From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [patch] ext4 crypto: unlock on error in
 ext4_set_encryption_metadata()
Date: Fri, 8 Jan 2016 15:36:26 -0500
Message-ID: <20160108203626.GD28412@thunk.org>
References: <20160105095719.GF23619@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39915 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932533AbcAHUg3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 8 Jan 2016 15:36:29 -0500
Content-Disposition: inline
In-Reply-To: <20160105095719.GF23619@mwanda>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 05, 2016 at 12:57:19PM +0300, Dan Carpenter wrote:
> There is a missing unlock if ext4_journal_start() fails.
> 
> Fixes: 374431bae296 ('ext4 crypto: add ioctls to allow backup of encryption metadata')
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Thanks for pointing this out!  I've fixed this by folded this into the
appropriate commit.

       	   	    	 	     	    - Ted
