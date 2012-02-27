From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] libext2fs: include config.h for HAVE_xxx defines
Date: Mon, 27 Feb 2012 01:13:54 -0500
Message-ID: <20120227061354.GC14204@thunk.org>
References: <1330103888-7005-1-git-send-email-vapier@gentoo.org>
 <1330103888-7005-2-git-send-email-vapier@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Mike Frysinger <vapier@gentoo.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:55431 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751263Ab2B0GN5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 27 Feb 2012 01:13:57 -0500
Content-Disposition: inline
In-Reply-To: <1330103888-7005-2-git-send-email-vapier@gentoo.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 24, 2012 at 12:18:08PM -0500, Mike Frysinger wrote:
> We check HAVE_UNISTD_H but haven't included config.h yet, so we end up
> hitting warnings about missing prototypes for close/read/etc... funcs.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>

Thanks, applied.

						- Ted
