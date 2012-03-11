From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/4] e2fsck: Do not discard when in read only mode
Date: Sun, 11 Mar 2012 15:35:30 -0400
Message-ID: <20120311193530.GF1048@thunk.org>
References: <1330933776-2696-1-git-send-email-lczerner@redhat.com>
 <1330933776-2696-3-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, sandeen@redhat.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:36482 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347Ab2CKTfc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 11 Mar 2012 15:35:32 -0400
Content-Disposition: inline
In-Reply-To: <1330933776-2696-3-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 05, 2012 at 08:49:35AM +0100, Lukas Czerner wrote:
> When argument '-n' was specified and should run in read-only mode, we
> should not attempt to discard anything. In order to do that we have to
> check for E2F_OPT_NO flag and clear E2F_OPT_DISCARD flag if E2F_OPT_NO
> is set.
> 
> This commit fixes the problem when we would mark inode tables as zeroed
> (EXT2_BG_INODE_ZEROED) even when e2fsck is running in read-only mode. We
> also move the check for E2F_OPT_NO so we can clear E2F_OPT_DISCARD as
> early as possible.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Applied, thanks.

						- Ted
