From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] ext4: Prevent panic for destroyed devices
Date: Fri, 19 Feb 2016 00:13:34 -0500
Message-ID: <20160219051334.GC12743@thunk.org>
References: <1455618965-26699-1-git-send-email-dmonakhov@openvz.org>
 <87d1ru2wex.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:54798 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895AbcBSFNh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 19 Feb 2016 00:13:37 -0500
Content-Disposition: inline
In-Reply-To: <87d1ru2wex.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 18, 2016 at 12:35:34PM +0300, Dmitry Monakhov wrote:
> Hm...
> Actually there are many places where we submit BHs w/o checks
> nojournal code is full of such places.
> It looks like we need some sort of AOP_TRUNCATE_PAGE error code
> for generic buffer submission path

Might it be enough to simply return have submit_bh check for the
unmapped buffer and return EIO?  I'm not sure we need a magic error
code....

That being said, I've always wished that there was a struct super
operation, s_block_device_gone() that would allow information about
the status of the block device to be communicated up the storage
stack.  Another useful thing that might be useful is an indication
that for whatever reason, the storage device has turned read-only on
us (so we might as well remounte the file system read-only instead of
letting userspace continue to dirty pages that have no hope of getting
written out).

					- Ted
