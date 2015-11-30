From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] mke2fs: sort "-d" option alphabetically
Date: Mon, 30 Nov 2015 18:31:25 -0500
Message-ID: <20151130233125.GJ4316@thunk.org>
References: <1448403406-25049-1-git-send-email-adilger@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:58723 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755167AbbK3Xb2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 Nov 2015 18:31:28 -0500
Content-Disposition: inline
In-Reply-To: <1448403406-25049-1-git-send-email-adilger@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 24, 2015 at 03:16:46PM -0700, Andreas Dilger wrote:
> Move the mke2fs "-d" option to be alphabetical like other options.
> 
> Rename "root_dir" to "src_root_dir" to avoid confusion with the
> actual root inode in the new filesystem.
> 
> Signed-off-by: Andreas Dilger <adilger@dilger.ca>

Thanks, applied.

					- Ted
