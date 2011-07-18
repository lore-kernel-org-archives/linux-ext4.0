From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] EXT4: Punch Hole Optimizations: Removed un-needed
 ext4_ext_remove_space param
Date: Sun, 17 Jul 2011 23:23:12 -0400
Message-ID: <20110718032312.GC14869@thunk.org>
References: <1309214991-31141-1-git-send-email-achender@linux.vnet.ibm.com>
 <1309214991-31141-3-git-send-email-achender@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:44518 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751736Ab1GRDXN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 17 Jul 2011 23:23:13 -0400
Content-Disposition: inline
In-Reply-To: <1309214991-31141-3-git-send-email-achender@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 27, 2011 at 03:49:51PM -0700, Allison Henderson wrote:
> This patch removes the extra parameter in the ext4_ext_remove_space
> routine which is no longer needed.
> 
> Signed-off-by: Allison Henderson <achender@linux.vnet.ibm.com>

Thanks, added to the ext4 tree.

						- Ted
