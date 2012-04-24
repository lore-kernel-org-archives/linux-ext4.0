From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [RFC]jbd2: use GFP_NOFS for blkdev_issue_flush
Date: Mon, 23 Apr 2012 21:53:23 -0400
Message-ID: <20120424015323.GC18865@thunk.org>
References: <4F878F17.2030900@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:57643 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754018Ab2DXBx1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Apr 2012 21:53:27 -0400
Content-Disposition: inline
In-Reply-To: <4F878F17.2030900@kernel.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 13, 2012 at 10:27:35AM +0800, Shaohua Li wrote:
> 
> flush request is issued in transaction commit code path, so looks using
> GFP_KERNEL to allocate memory for flush request bio falls into the classic
> deadlock issue.  I saw btrfs and dm get it right, but ext4, xfs and md are
> using GFP_KERNEL, which makes me confused. Hoping filesystem developers
> clarify.
> 
> Signed-off-by: Shaohua Li <shli@fusionio.com>

Thanks, applied.

					- Ted
