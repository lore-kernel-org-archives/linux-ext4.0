From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] debugfs.c: the max length of debugfs argument is too
 short
Date: Sun, 28 Jul 2013 22:37:56 -0400
Message-ID: <20130729023756.GD5827@thunk.org>
References: <1374834657-17091-1-git-send-email-liezhi.yang@windriver.com>
 <1374834657-17091-2-git-send-email-liezhi.yang@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, dvhart@linux.intel.com,
	darrick.wong@oracle.com
To: Robert Yang <liezhi.yang@windriver.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45904 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754221Ab3G2D0r (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 28 Jul 2013 23:26:47 -0400
Content-Disposition: inline
In-Reply-To: <1374834657-17091-2-git-send-email-liezhi.yang@windriver.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 26, 2013 at 06:30:56PM +0800, Robert Yang wrote:
> The max length of debugfs argument is 256 which is too short, the
> arguments are two paths, the PATH_MAX is 4096 according to
> /usr/include/linux/limits.h, use 2048 (4096 / 2) is a reasonable value.

I'd just use BUFSIZ (which is 8192 on Linux systems).  That's what the
ss library uses, and if you might have two paths and PATH_MAX is 4096,
2048 could easily be too small.

					- Ted
