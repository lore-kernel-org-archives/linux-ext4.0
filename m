From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fsck: show size requested when memory allocation fails
Date: Tue, 8 Jan 2013 10:41:42 -0500
Message-ID: <20130108154142.GF27837@thunk.org>
References: <50EB4212.9080601@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:42336 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756675Ab3AHPlp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Jan 2013 10:41:45 -0500
Content-Disposition: inline
In-Reply-To: <50EB4212.9080601@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 07, 2013 at 03:45:54PM -0600, Eric Sandeen wrote:
> "e2fsck: Can't allocate dx_block info array"
> is only so helpful - it'd be nice to know how much it tried to allocate.
> 
> In particular, since I think malloc(0) can return NULL,
> it'd be nice to know if maybe we passed in an uninitialized (or
> 0-initialized) size.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Thanks, applied.

					- Ted
