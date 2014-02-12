From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [patch] ext4: remove an unneeded check in mext_page_mkuptodate()
Date: Wed, 12 Feb 2014 12:25:22 -0500
Message-ID: <20140212172522.GG14520@thunk.org>
References: <20140206124549.GA16998@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:57137 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752002AbaBLRZ1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 Feb 2014 12:25:27 -0500
Content-Disposition: inline
In-Reply-To: <20140206124549.GA16998@elgon.mountain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 06, 2014 at 03:45:50PM +0300, Dan Carpenter wrote:
> "err" is zero here, there is no need to check again.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Thanks, applied.

					- Ted
