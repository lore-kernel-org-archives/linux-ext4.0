From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [patch] ext4: unneeded variable in ext4_try_add_inline_entry()
Date: Thu, 6 Dec 2012 12:23:08 -0500
Message-ID: <20121206172308.GD30273@thunk.org>
References: <20121205080836.GA10259@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, kernel-janitors@vger.kernel.org,
	Tao Ma <boyu.mt@taobao.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:37164 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1424456Ab2LFRXT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 6 Dec 2012 12:23:19 -0500
Content-Disposition: inline
In-Reply-To: <20121205080836.GA10259@elgon.mountain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Dec 05, 2012 at 11:08:37AM +0300, Dan Carpenter wrote:
> We never actually use "backup_buf" so I have removed it.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

I've merged this into the inline data patches; thanks for reporting it!

     	    	      	  	      - Ted
