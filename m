From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] ext4: Allow quota file use root reservation
Date: Thu, 20 Oct 2011 20:11:14 -0400
Message-ID: <20111021001114.GK17210@thunk.org>
References: <1319019383-12603-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jack@suse.cz, linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:44668 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998Ab1JUBMq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 Oct 2011 21:12:46 -0400
Content-Disposition: inline
In-Reply-To: <1319019383-12603-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 19, 2011 at 02:16:22PM +0400, Dmitry Monakhov wrote:
> Quota file is fs's metadata, so it is reasonable  to permit use
> root resevation if necessary. This patch fix 265'th xfstest failure
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>

Applied to the ext4 tree, thanks.  I'll leave the ext3 patch to Jan.

					- Ted
