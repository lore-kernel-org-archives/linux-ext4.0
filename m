From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] libext2fs: change getpagesize to sysconf
Date: Mon, 9 Jan 2012 21:38:07 -0500
Message-ID: <20120110023807.GB1450@thunk.org>
References: <1323274568-13551-1-git-send-email-vapier@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Mike Frysinger <vapier@gentoo.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:35293 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755952Ab2AJCiK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 Jan 2012 21:38:10 -0500
Content-Disposition: inline
In-Reply-To: <1323274568-13551-1-git-send-email-vapier@gentoo.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Dec 07, 2011 at 11:16:08AM -0500, Mike Frysinger wrote:
> Newer versions of glibc no longer export the getpagesize() prototype when
> using recent versions of POSIX (_XOPEN_SOURCE).  So building tdb.c gives
> use implicit function declaration warnings.  Fix the issue by using the
> portable sysconf() function which returns the same answer.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>

Applied, thanks.

						- Ted
