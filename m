From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] tests: fix f_badcluster output formatting
Date: Fri, 1 Aug 2014 21:41:27 -0400
Message-ID: <20140802014127.GE27252@thunk.org>
References: <1406676640-5627-1-git-send-email-adilger@dilger.ca>
 <1406676640-5627-2-git-send-email-adilger@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41244 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751008AbaHBBl3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 1 Aug 2014 21:41:29 -0400
Content-Disposition: inline
In-Reply-To: <1406676640-5627-2-git-send-email-adilger@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 29, 2014 at 05:30:40PM -0600, Andreas Dilger wrote:
> The f_badcluster output format depends on how libreadline formats
> and outputs the commands read from stdin.  Instead of trying to
> handle these differences, use an input command file, which does
> not depend on external components to be consistent.
> 
> Signed-off-by: Andreas Dilger <adilger@dilger.ca>

Applied, thanks.

					- Ted
