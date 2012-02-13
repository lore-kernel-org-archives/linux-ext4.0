From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [patch] ext4: using PTR_ERR() on the wrong variable in
 ext4_ext_migrate()
Date: Mon, 13 Feb 2012 18:41:47 -0500
Message-ID: <20120213234147.GJ21641@thunk.org>
References: <20120126061406.GB15856@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:58638 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753834Ab2BMXlt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 Feb 2012 18:41:49 -0500
Content-Disposition: inline
In-Reply-To: <20120126061406.GB15856@elgon.mountain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 26, 2012 at 09:14:06AM +0300, Dan Carpenter wrote:
> "inode" is a valid pointer here.  "tmp_inode" was intended.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Thanks, applied.

					- Ted
