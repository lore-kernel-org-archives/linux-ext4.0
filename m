From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: only define label failed_mount8 when used
Date: Tue, 29 Jan 2013 22:52:43 -0500
Message-ID: <20130130035243.GC25006@thunk.org>
References: <1359504540-23474-1-git-send-email-swarren@wwwdotorg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Stephen Warren <swarren@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:46133 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753016Ab3A3Dws (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 29 Jan 2013 22:52:48 -0500
Content-Disposition: inline
In-Reply-To: <1359504540-23474-1-git-send-email-swarren@wwwdotorg.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 29, 2013 at 05:09:00PM -0700, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
> 
> This fixes:
> 
> fs/ext4/super.c: In function 'ext4_fill_super':
> fs/ext4/super.c:4040:1: warning: label 'failed_mount8' defined but not used
> 
> This label is only jumped to by code under ifdef CONFIG_QUOTA, so only
> define the label in that case too.
> 
> Signed-off-by: Stephen Warren <swarren@nvidia.com>

This is already fixed in the ext4 dev tree.  I assume you noticed this
in linux-next?  It should be fixed up in tomorrow's cut.

   		   	     	      	 - Ted
