From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fsck: skip fixing UUID on a mounted filesystem with
 csums
Date: Sun, 23 Feb 2014 19:21:14 -0500
Message-ID: <20140224002114.GB27617@thunk.org>
References: <1390169374-1775-1-git-send-email-michael.marineau@coreos.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Michael Marineau <michael.marineau@coreos.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:33195 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750994AbaBXAVR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 23 Feb 2014 19:21:17 -0500
Content-Disposition: inline
In-Reply-To: <1390169374-1775-1-git-send-email-michael.marineau@coreos.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jan 19, 2014 at 02:09:34PM -0800, Michael Marineau wrote:
> This fix is similar to 66457fcb for tune2fs. When booting from a root
> filesystem with an empty UUID which fsck fixes the following remount
> step reliably fails, leaving the filesystem in an inconsistent state.
> Like the tune2fs fix this patch resolves the issue by simply refusing to
> update the UUID if the filesystem is mounted.
> 
> Signed-off-by: Michael Marineau <michael.marineau@coreos.com>

Applied, thanks!

					- Ted
