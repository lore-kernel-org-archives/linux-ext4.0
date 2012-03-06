From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 4/4 v2] ext4: Do not discard group with BLOCK_UNINIT set
Date: Tue, 6 Mar 2012 17:18:15 -0500
Message-ID: <20120306221815.GA5472@thunk.org>
References: <1330690318-22627-1-git-send-email-lczerner@redhat.com>
 <1330690318-22627-4-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:58695 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030811Ab2CFWSS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 Mar 2012 17:18:18 -0500
Content-Disposition: inline
In-Reply-To: <1330690318-22627-4-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 02, 2012 at 01:11:58PM +0100, Lukas Czerner wrote:
> Because the BLOCK_UNINIT is only set on mke2fs time and cleared when
> allocation from that group takes place we know that when set, there was
> not anything allocated from that group, hence there should not be anything
> to discard from the file system point of view.

There's a really good reason to set BLOCK_UNINIT once we have noticed
that all of the blocks in the block group have been released....

If you have a 3TB HDD, running e2fsck takes 4 times as long if all of
the block groups have BLOCK_UNINIT cleared, compared to a freshly
mkfs'ed file system.  As a result of my getting really annoyed at how
long it took in this case, I'm planning on making e2fsck clear
BLOCK_UNINIT if possible, so that subsequent e2fsck's (and dumpe2fs
and debugfs invocations) can also be fast.

					- Ted
