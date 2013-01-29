From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/4] ext4: remove useless assignment in dx_probe()
Date: Mon, 28 Jan 2013 21:35:14 -0500
Message-ID: <20130129023514.GH7003@thunk.org>
References: <1358496074-6228-1-git-send-email-yan@linux.vnet.ibm.com>
 <1358496074-6228-3-git-send-email-yan@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Guo Chao <yan@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45971 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753328Ab3A2CfT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Jan 2013 21:35:19 -0500
Content-Disposition: inline
In-Reply-To: <1358496074-6228-3-git-send-email-yan@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 18, 2013 at 04:01:13PM +0800, Guo Chao wrote:
> No body care about the effect of this assignment.
> 
> Signed-off-by: Guo Chao <yan@linux.vnet.ibm.com>

Thanks, applied.

					- Ted
