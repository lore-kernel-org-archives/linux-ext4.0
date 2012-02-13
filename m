From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: expand commit callback
Date: Mon, 13 Feb 2012 16:02:25 -0500
Message-ID: <20120213210225.GA21641@thunk.org>
References: <y>
 <1319626156-2444-1-git-send-email-bobijam@whamcloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@whamcloud.com>
To: Bobi Jam <bobijam@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:36676 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758146Ab2BMVCa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 Feb 2012 16:02:30 -0500
Content-Disposition: inline
In-Reply-To: <1319626156-2444-1-git-send-email-bobijam@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 26, 2011 at 06:49:16PM +0800, Bobi Jam wrote:
> The per-commit callback is now used by mballoc code to manage free
> space bitmaps after deleted blocks have been released. This patch
> expand it to contain multiple different callbacks.
> 
> Signed-off-by: Bobi Jam <bobijam@whamcloud.com>
> Signed-off-by: Andreas Dilger <adilger@whamcloud.com>

Thanks, applied.

Note: since this callback is called *after* the commit is completed,
we can't really use this to do things like compute metadata checksums
or update atimes more efficiently, since those sorts of things have to
happen *before* we actually finish up the commit.

					- Ted
