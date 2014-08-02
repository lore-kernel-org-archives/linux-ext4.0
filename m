From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] misc: quiet signed/unsigned charactr compiler
 warnings
Date: Fri, 1 Aug 2014 21:39:38 -0400
Message-ID: <20140802013937.GD27252@thunk.org>
References: <1406676640-5627-1-git-send-email-adilger@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41237 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751008AbaHBBjl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 1 Aug 2014 21:39:41 -0400
Content-Disposition: inline
In-Reply-To: <1406676640-5627-1-git-send-email-adilger@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 29, 2014 at 05:30:39PM -0600, Andreas Dilger wrote:
> Quiet warnings about signed vs. unsigned character mismatch.
> Use __u8 for storing UUIDs instead of char to match the superblock
> s_uuid field.
> 
> Signed-off-by: Andreas Dilger <adilger@dilger.ca>

Applied, thanks.

					- Ted
