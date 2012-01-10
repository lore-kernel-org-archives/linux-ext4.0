From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] mke2fs: fix -T/-t usage output
Date: Mon, 9 Jan 2012 21:18:08 -0500
Message-ID: <20120110021808.GA1450@thunk.org>
References: <1323274533-13103-1-git-send-email-vapier@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Mike Frysinger <vapier@gentoo.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:50578 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755486Ab2AJCSP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 Jan 2012 21:18:15 -0500
Content-Disposition: inline
In-Reply-To: <1323274533-13103-1-git-send-email-vapier@gentoo.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Dec 07, 2011 at 11:15:33AM -0500, Mike Frysinger wrote:
> There is a slight desync between the mke2fs(8) man page and the mke2fs
> help output when it comes to the -t/-T options.  Since the man page is
> correct, update the mke2fs usage string to match.
> 
> Reported-by: Ben Kohler <bkohler@gmail.com>
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>

Thanks, applied.

					- Ted
