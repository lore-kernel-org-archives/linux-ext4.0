From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] resize2fs: handle exactly-16T filesystems in resize2fs
Date: Thu, 16 Dec 2010 19:18:02 -0500
Message-ID: <20101217001802.GF4455@thunk.org>
References: <4D09978E.5050302@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:34082 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752234Ab0LQASD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 Dec 2010 19:18:03 -0500
Content-Disposition: inline
In-Reply-To: <4D09978E.5050302@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Dec 15, 2010 at 10:37:34PM -0600, Eric Sandeen wrote:
> Before we go whole-hog on 64-bit e2fsprogs, I wonder if this
> is worth considering as a last-minute addition to the 1.41
> stream.  Currently, mke2fs will shave a block off an exactly-16T
> device to fit*, but resize2fs does not do the same, leading
> to some asymmetry.  This patch fixes that up, and allows 16T
> devices to be handled more gracefully in offline resize.
> (in fact resize2fs will not even open a 16T device, today).
> 
> *commit 37d17a65ecb4615546b417038190a41bafca7c51
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Thanks, added to the maint branch.

						- Ted
