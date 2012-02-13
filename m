From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [patch] ext4: remove an unneeded NULL check
Date: Mon, 13 Feb 2012 18:39:17 -0500
Message-ID: <20120213233917.GI21641@thunk.org>
References: <20120124084109.GC29097@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:58634 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752962Ab2BMXjU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 Feb 2012 18:39:20 -0500
Content-Disposition: inline
In-Reply-To: <20120124084109.GC29097@elgon.mountain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 24, 2012 at 11:41:09AM +0300, Dan Carpenter wrote:
> We dereference "bh" unconditionally a couple lines down to find
> "by->b_size".  This function is never called with a NULL "bh" so I have
> removed the check.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Thanks, applied.

					- Ted
