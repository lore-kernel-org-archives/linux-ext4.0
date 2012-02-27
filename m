From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2image: skip uninitialized bitmaps and inode tables
Date: Mon, 27 Feb 2012 00:59:18 -0500
Message-ID: <20120227055918.GD9881@thunk.org>
References: <1329860849-28076-1-git-send-email-psusi@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:46831 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753285Ab2B0GAc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 27 Feb 2012 01:00:32 -0500
Content-Disposition: inline
In-Reply-To: <1329860849-28076-1-git-send-email-psusi@ubuntu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 21, 2012 at 04:47:29PM -0500, Phillip Susi wrote:
> When the block bitmap is uninitialized, skip copying it.
> When the inode bitmap is uninitialized, skip copying it,
> as well as the inode table.  When there are unused inodes
> towards the end of the table, skip those blocks too.
> 
> Signed-off-by: Phillip Susi <psusi@ubuntu.com>

Thanks, applied.

						- Ted
