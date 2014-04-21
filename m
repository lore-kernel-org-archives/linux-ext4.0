From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2 2/2] ext4: disable COLLAPSE_RANGE for bigalloc
Date: Mon, 21 Apr 2014 09:31:19 -0400
Message-ID: <20140421133119.GD14869@thunk.org>
References: <000d01cf5b8b$5b149110$113db330$@samsung.com>
 <20140419221221.GD13492@thunk.org>
 <001101cf5d1d$7f6bce00$7e436a00$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: 'linux-ext4' <linux-ext4@vger.kernel.org>,
	=?utf-8?B?J0x1a8OhxaE=?= Czerner' <lczerner@redhat.com>
To: Namjae Jeon <namjae.jeon@samsung.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51657 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751982AbaDUNbY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Apr 2014 09:31:24 -0400
Content-Disposition: inline
In-Reply-To: <001101cf5d1d$7f6bce00$7e436a00$@samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 21, 2014 at 01:52:28PM +0900, Namjae Jeon wrote:
> > 
> > What's the status of the "[2/3] ext4: fix ZERO_RANGE test failure in
> > data journalling mode" patch.  Is it no longer needed?
> It is needed. Currently, I am considering your suggestion of introducing
> EXT4_I(inode)->i_write_mutex which can also include ext4_aio_mutex.

OK; I've already pushed a set of patches to Linus because it's getting
fairly late in the development cycle, and we really want to get as
much of the bug fixes into -rc3 (having missed -rc2 by a few hours,
sigh).

By the way, in doing some final testing, it appears that we are still
failing generic/127 with a 1k blocksize.  If I block COLLAPSE_RANGE
using the patch that everyone but me seems to hate :-), the problem
goes away.  So we have at least one other issue that needs to be
looked at.

You can reproduce by grabbing the dev branch from the ext4.git tree,
and then cherry-picking the top commit from the unstable branch.

Then run "kvm-xfstests -c 1k generic/127", with and without the
following in config.custom:

EXTRA_ARG="ext4.fallocate_mode_block=0x08"

Cheers,

						- Ted
