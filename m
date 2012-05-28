From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [patch v2] ext4: potential NULL dereference on error
Date: Mon, 28 May 2012 11:01:43 -0400
Message-ID: <20120528150143.GG19152@thunk.org>
References: <20120514222535.GW5353@quack.suse.cz>
 <20120515084640.GB30265@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45981 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751899Ab2E1PBu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 May 2012 11:01:50 -0400
Content-Disposition: inline
In-Reply-To: <20120515084640.GB30265@elgon.mountain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 15, 2012 at 11:46:40AM +0300, Dan Carpenter wrote:
> The ext4_get_group_desc() function returns NULL on error, and
> ext4_free_inodes_count() function dereferences it without checking.
> There is a check on the next line, but it's too late.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Thanks, applied.

					- Ted
