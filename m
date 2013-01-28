From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] build: quiet build warnings for "gcc -Wall"
Date: Sun, 27 Jan 2013 22:39:17 -0500
Message-ID: <20130128033917.GA9412@thunk.org>
References: <1358897549-8058-1-git-send-email-adilger@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: adilger@dilger.ca
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45754 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753368Ab3A1DjV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 27 Jan 2013 22:39:21 -0500
Content-Disposition: inline
In-Reply-To: <1358897549-8058-1-git-send-email-adilger@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 22, 2013 at 04:32:29PM -0700, adilger@dilger.ca wrote:
> From: Andreas Dilger <adilger@dilger.ca>
> 
> - quiet unused variable warnings
> - fix "main()" prototype declaration in parse-types.sh
> - fix printf() argument prototype in do_one_pass()
> 
> Signed-off-by: Andreas Dilger <adilger@dilger.ca>

Thanks!  I split up this patch into two commits, one which I applied
to the maint branch, and one which I applied to the next branch.

       	     	     	     	   - Ted
