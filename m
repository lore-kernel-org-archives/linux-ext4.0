From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: pass inode pointer instead of file poiner to punch
 hole
Date: Tue, 18 Jun 2013 11:24:46 -0400
Message-ID: <20130618152446.GE7359@thunk.org>
References: <519f7b26.81b1440a.6cc8.ffffa881@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger@dilger.ca, linux-ext4@vger.kernel.org,
	Ashish Sangwan <a.sangwan@samsung.com>,
	Namjae Jeon <namjae.jeon@samsung.com>
To: ashishsangwan2@gmail.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:59046 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755058Ab3FRPYu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 18 Jun 2013 11:24:50 -0400
Content-Disposition: inline
In-Reply-To: <519f7b26.81b1440a.6cc8.ffffa881@mx.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 24, 2013 at 08:06:55PM +0530, ashishsangwan2@gmail.com wrote:
> From: Ashish Sangwan <a.sangwan@samsung.com>
> 
> No need to pass file pointer when we can directly pass inode pointer.
> 
> Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>

Applied, thanks.

					- Ted
