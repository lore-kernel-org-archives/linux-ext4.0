From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH-e2fsprogs] filefrag: accept positive ioctl return value
Date: Tue, 2 Jun 2009 08:40:17 -0400
Message-ID: <20090602124017.GS31943@mit.edu>
References: <1243944761-18673-1-git-send-email-bergwolf@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Peng Tao <bergwolf@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:47558 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752836AbZFBMk1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Jun 2009 08:40:27 -0400
Content-Disposition: inline
In-Reply-To: <1243944761-18673-1-git-send-email-bergwolf@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 02, 2009 at 08:12:41PM +0800, Peng Tao wrote:
> Some ioctl() returns non-negative value on success. filefrag_fiemap should
> treat positive ioctl() return values as success.
> This can be triggered by running filefrag on btrfs partitions.

What does the positive fiemap ioctl return mean?  It's not documented
in Documentation/filesystems/fiemap.txt.

						- Ted
