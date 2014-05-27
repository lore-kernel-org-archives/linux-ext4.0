From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] filefrag: exit with error code if an error is hit
Date: Tue, 27 May 2014 12:57:07 -0400
Message-ID: <20140527165707.GE1158@thunk.org>
References: <1400707043-13122-1-git-send-email-adilger@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35206 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752280AbaE0Q5K (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 27 May 2014 12:57:10 -0400
Content-Disposition: inline
In-Reply-To: <1400707043-13122-1-git-send-email-adilger@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 21, 2014 at 03:17:23PM -0600, Andreas Dilger wrote:
> If an error is hit during filefrag operation, it will continue to run
> (if multiple files are specified on the command-line), but will exit
> with a non-zero value, so that callers can determine that some error
> was hit.
> 
> Clean up the printing of FIEMAP flags and print some newer flags that
> were missing.  Also print unknown flags as hex values.
> 
> Signed-off-by: Andreas Dilger <adilger@dilger.ca>

Applied, thanks.

					- Ted
