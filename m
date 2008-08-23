From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] libext2fs : Fix memory leak in ext2fs_initialize().
Date: Sat, 23 Aug 2008 07:56:26 -0400
Message-ID: <20080823115626.GH5485@mit.edu>
References: <ea11fea30808230441h680100d6k1e4524710e6d2d4c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Manish Katiyar <mkatiyar@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:51999 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752579AbYHWL42 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 23 Aug 2008 07:56:28 -0400
Content-Disposition: inline
In-Reply-To: <ea11fea30808230441h680100d6k1e4524710e6d2d4c@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Aug 23, 2008 at 05:11:07PM +0530, Manish Katiyar wrote:
> Below patch ensures that cleanup is done properly in ext2fs_initialize
> from all return paths in case of errors.

Thanks, applied.

						- Ted
