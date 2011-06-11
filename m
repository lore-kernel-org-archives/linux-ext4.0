From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] misc: clean up compiler warnings
Date: Sat, 11 Jun 2011 11:01:03 -0400
Message-ID: <20110611150103.GB11207@thunk.org>
References: <1307681558-31407-1-git-send-email-adilger@whamcloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:49262 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758555Ab1FKPBG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 11 Jun 2011 11:01:06 -0400
Content-Disposition: inline
In-Reply-To: <1307681558-31407-1-git-send-email-adilger@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 09, 2011 at 10:52:38PM -0600, Andreas Dilger wrote:
> Fix several types of compiler warnings (unused variables/labels),
> uninitialized variables, etc that are hit with gcc -Wall.
> 
> Signed-off-by: Andreas Dilger <adilger@whamcloud.com>

Applied into the "next" branch, thanks!  (As per usual, the commits
next branch will graduate into the 'master' branch in a few days.)

						- Ted
