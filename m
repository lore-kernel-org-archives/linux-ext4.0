From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 4/4] e2fsck: Do not discard itable if discard doen't
 zero data
Date: Sun, 11 Mar 2012 15:39:30 -0400
Message-ID: <20120311193930.GG1048@thunk.org>
References: <1330933776-2696-1-git-send-email-lczerner@redhat.com>
 <1330933776-2696-4-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, sandeen@redhat.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:48160 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751583Ab2CKTjc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 11 Mar 2012 15:39:32 -0400
Content-Disposition: inline
In-Reply-To: <1330933776-2696-4-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 05, 2012 at 08:49:36AM +0100, Lukas Czerner wrote:
> We do not want to discard inode table if the underlying device does not
> return zeros when reading non-provisioned blocks. The reason is that if
> the inode table is not zeroed yet, then discard would not help us since
> we would have to zero it anyway. In the case that inode table was
> already zeroed, then the discard would cause subsequent reads to contain
> non-deterministic data so we would not be able to assume that the inode
> table was zeroed and we would need to zero it again, which does not
> really make sense.
> 
> This commit adds check to prevent inode table from being discarded if
> the discard does not zero data.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Applied, thanks.

				- Ted
