From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] tests: shorten test descriptions to fit in 80 columns
Date: Sun, 15 Oct 2017 16:34:57 -0400
Message-ID: <20171015203457.4i2vyep63grptika@thunk.org>
References: <1507675426-70319-1-git-send-email-adilger@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49106 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751337AbdJOUfA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 15 Oct 2017 16:35:00 -0400
Content-Disposition: inline
In-Reply-To: <1507675426-70319-1-git-send-email-adilger@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 10, 2017 at 04:43:46PM -0600, Andreas Dilger wrote:
> While not critical to functionality, it is easier to see the pass/fail
> status of each test if they are not wrapped onto the next line.
> Shorten test descriptions so the name+description fit in 80 columns.
> 
> Signed-off-by: Andreas Dilger <adilger@dilger.ca>

Thanks, applied.

					- Ted
