From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] debugfs: fix filehandle leak in copy_file()
Date: Thu, 22 May 2014 17:55:40 -0400
Message-ID: <20140522215540.GD11448@thunk.org>
References: <1400625035-61772-1-git-send-email-adilger@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:56510 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751112AbaEVVzl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 22 May 2014 17:55:41 -0400
Content-Disposition: inline
In-Reply-To: <1400625035-61772-1-git-send-email-adilger@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 20, 2014 at 04:30:35PM -0600, Andreas Dilger wrote:
> Fix a file handle leak for the target file in copy_file() when error
> handlers return without closing the file.  Instead, clean up at the
> end of the function to handle cleanup in normal and error cases.
> 
> Minor other code style cleanups.
> 
> Signed-off-by: Andreas Dilger <adilger@dilger.ca>

Thanks, applied.

					- Ted
