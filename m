From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] mke2fs: sort option parsing, deprecate "-R"
Date: Sat, 15 Jun 2013 18:48:04 -0400
Message-ID: <20130615224804.GB32754@thunk.org>
References: <1367280961-16458-1-git-send-email-adilger@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from [67.18.176.11] ([67.18.176.11]:58248 "EHLO imap.thunk.org"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754558Ab3FOWsh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 15 Jun 2013 18:48:37 -0400
Content-Disposition: inline
In-Reply-To: <1367280961-16458-1-git-send-email-adilger@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 29, 2013 at 06:16:01PM -0600, Andreas Dilger wrote:
> A minor cleanup to order the command-line option parsing in
> alphabetical order, except for "-E" and "-R", which need to
> be co-located.
> 
> Print a message that the "-R" option is deprecated.  It has
> been deprecated since 2005 (commit c6a44136b9b).
> 
> Signed-off-by: Andreas Dilger <adilger@dilger.ca>

Applied, thanks.

					- Ted
