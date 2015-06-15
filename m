From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: improve warning directory handling messages
Date: Mon, 15 Jun 2015 14:52:47 -0400
Message-ID: <20150615185247.GB5003@thunk.org>
References: <1430782281-22440-1-git-send-email-adilger@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:36533 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752008AbbFOSws (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 15 Jun 2015 14:52:48 -0400
Content-Disposition: inline
In-Reply-To: <1430782281-22440-1-git-send-email-adilger@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 04, 2015 at 05:31:21PM -0600, Andreas Dilger wrote:
> Several ext4_warning() messages in the directory handling code do not
> report the inode number of the (potentially corrupt) directory where a
> problem is seen, and others report this in an ad-hoc manner.  Add an
> ext4_warning_inode() helper to print the inode number and command name
> consistent with ext4_error_inode().
> 
> Consolidate the place in ext4.h that these macros are defined.
> 
> Clean up some other directory error and warning messages to print the
> calling function name.
> 
> Minor code style fixes in nearby lines.
> 
> Signed-off-by: Andreas Dilger <adilger@dilger.ca>

Thanks, applied.

						- Ted
