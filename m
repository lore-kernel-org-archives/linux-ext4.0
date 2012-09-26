From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix double unlock buffer mess during fs-resize
Date: Tue, 25 Sep 2012 23:26:29 -0400
Message-ID: <20120926032629.GB11468@thunk.org>
References: <1347012884-29484-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, djwong@us.ibm.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:52375 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751410Ab2IZD0k (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Sep 2012 23:26:40 -0400
Content-Disposition: inline
In-Reply-To: <1347012884-29484-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 07, 2012 at 02:14:44PM +0400, Dmitry Monakhov wrote:
> bh_submit_read() is responsible for unlock bh on endio
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>

Thanks, applied.  

BTW, I was checking the call sites for ext4_get_bitmap() in
fs/ext/resize.c, and we doing some extra work in
ext4_set_bitmap_checksums(); if the bitmap is uninitialized, then
there's no point in generating a checksum for it.

Something we can fix later, since it's harmless, although it is extra
unnecessary work.

					- Ted
