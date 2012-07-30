From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] blkmap64_ba: Only define ba_print_stats() when
 needed.
Date: Mon, 30 Jul 2012 15:41:17 -0400
Message-ID: <20120730194116.GD10343@thunk.org>
References: <1340794759-15286-1-git-send-email-tony@bakeyournoodle.com>
 <1340794759-15286-2-git-send-email-tony@bakeyournoodle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@dilger.ca>
To: Tony Breeds <tony@bakeyournoodle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:42098 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754873Ab2G3TlS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 Jul 2012 15:41:18 -0400
Content-Disposition: inline
In-Reply-To: <1340794759-15286-2-git-send-email-tony@bakeyournoodle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 27, 2012 at 08:59:19PM +1000, Tony Breeds wrote:
> If ENABLE_BMAP_STATS isn't defined make a_print_stats() do nothing.
> 
> Signed-off-by: Tony Breeds <tony@bakeyournoodle.com>

Added to the next branch of e2fsprogs.

					- Ted
