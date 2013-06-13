From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] jbd2: export __jbd2_debug for modular builds
Date: Thu, 13 Jun 2013 10:18:49 -0400
Message-ID: <20130613141849.GF13429@thunk.org>
References: <1371131130-1894-1-git-send-email-paul.gortmaker@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:57678 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752642Ab3FMOSv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Jun 2013 10:18:51 -0400
Content-Disposition: inline
In-Reply-To: <1371131130-1894-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 13, 2013 at 09:45:30AM -0400, Paul Gortmaker wrote:
> The commit "jbd2: use a single printk for jbd_debug()" introduced
> a new function, __jbd2_debug.  However it needs to be exported
> or the final modpost stage of the build will fail with:
> 
>   ERROR: "__jbd2_debug" [fs/ext4/ext4.ko] undefined!
>   make[1]: *** [__modpost] Error 1
>   make: *** [modules] Error 2
> 
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

Thanks, I've merged this into the original commit and pushed out an
updated dev branch.

					- Ted
