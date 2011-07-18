From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] EXT4: Punch Hole Optimizations: Skip un-needed
 extent lookup
Date: Sun, 17 Jul 2011 23:22:56 -0400
Message-ID: <20110718032256.GB14869@thunk.org>
References: <1309214991-31141-1-git-send-email-achender@linux.vnet.ibm.com>
 <1309214991-31141-2-git-send-email-achender@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:44515 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751736Ab1GRDW7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 17 Jul 2011 23:22:59 -0400
Content-Disposition: inline
In-Reply-To: <1309214991-31141-2-git-send-email-achender@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 27, 2011 at 03:49:50PM -0700, Allison Henderson wrote:
> This patch optimizes the punch hole operation by skipping the
> tree walking code that is used by truncate.  Since punch hole
> is done through map blocks, the path to the extent is already
> known in this function, so we do not need to look it up again.
> 
> Signed-off-by: Allison Henderson <achender@linux.vnet.ibm.com>

Thanks, added to the ext4 tree.

					- Ted
