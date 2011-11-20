From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fsck: return more status if fsck aborts
Date: Sun, 20 Nov 2011 15:56:40 -0500
Message-ID: <20111120205640.GA14568@thunk.org>
References: <4EB02D2C.3090809@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:58169 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751620Ab1KTU4r (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 20 Nov 2011 15:56:47 -0500
Content-Disposition: inline
In-Reply-To: <4EB02D2C.3090809@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 01, 2011 at 12:32:28PM -0500, Eric Sandeen wrote:
> If we abort fsck (due to ENOMEM for example) we exit
> with only the FSCK_ERROR flag.  It seems useful
> to do the same sorts of checks as we do on normal
> exit, and return whether the filesystem was modified,
> whether there are still uncorrected errors, etc, even
> in the abort case.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Thanks, applied.

					- Ted
