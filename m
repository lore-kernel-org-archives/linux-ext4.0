From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] initialize error handling before journal replay
Date: Sun, 17 May 2009 23:29:41 -0400
Message-ID: <20090518032941.GF32019@mit.edu>
References: <20090515185158.GQ3209@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:40244 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751771AbZERD3p (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 17 May 2009 23:29:45 -0400
Content-Disposition: inline
In-Reply-To: <20090515185158.GQ3209@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 15, 2009 at 12:51:58PM -0600, Andreas Dilger wrote:
> The following patch moves the e2fsck error handler initialization earlier
> in the e2fsck startup code before the journal is processed, so that the
> user will be prompted for an action.  This is the first IO that is not
> part of ext2fs_open() where fs->io is first initialized.

Applied, thanks.

					- Ted
