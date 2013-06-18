From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: optimize extent selection for block removal in
 case of hole punch
Date: Tue, 18 Jun 2013 11:40:53 -0400
Message-ID: <20130618154053.GF7359@thunk.org>
References: <519f7ba2.04fc440a.06c2.ffffd589@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger@dilger.ca, linux-ext4@vger.kernel.org,
	Ashish Sangwan <a.sangwan@samsung.com>,
	Namjae Jeon <namjae.jeon@samsung.com>
To: ashishsangwan2@gmail.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:59060 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756274Ab3FRPk6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 18 Jun 2013 11:40:58 -0400
Content-Disposition: inline
In-Reply-To: <519f7ba2.04fc440a.06c2.ffffd589@mx.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 24, 2013 at 08:09:17PM +0530, ashishsangwan2@gmail.com wrote:
> From: Ashish Sangwan <a.sangwan@samsung.com>
> 
> Both hole punch and truncate use ext4_ext_rm_leaf for removing
> blocks. Currently we choose the last extent as the starting
> point for removing blocks: ex = EXT_LAST_EXTENT(eh);
> This is OK for truncate but for hole punch we can optimize the
> extent selection as the path is already initialized.
> We could use this information to select proper starting extent.
> The code change in this patch will not affect truncate as for
> truncate path[depth].p_ext will always be NULL.
> 
> Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>

Applied, thanks.

					- Ted
