From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] misc: use EXT2_I_SIZE() consistently to get size
Date: Fri, 8 Jul 2011 20:53:29 -0400
Message-ID: <20110709005329.GM3331@thunk.org>
References: <1310169297-4561-1-git-send-email-adilger@whamcloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:40172 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751794Ab1GIAxc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 8 Jul 2011 20:53:32 -0400
Content-Disposition: inline
In-Reply-To: <1310169297-4561-1-git-send-email-adilger@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 08, 2011 at 05:54:57PM -0600, Andreas Dilger wrote:
> Use the EXT2_I_SIZE() macro consistently to access the inode size.
> The i_size/i_size_high combination is open coded in several places.
> 
> Signed-off-by: Andreas Dilger <adilger@whamcloud.com>

Applied to the next branch, thanks.

						- Ted
