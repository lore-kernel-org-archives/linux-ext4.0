From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: check for zero length extent explicitly
Date: Thu, 14 May 2015 19:02:20 -0400
Message-ID: <20150514230220.GC3901@thunk.org>
References: <1430734468-31785-1-git-send-email-guaneryu@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eryu Guan <guaneryu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:37407 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422891AbbENXCV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 14 May 2015 19:02:21 -0400
Content-Disposition: inline
In-Reply-To: <1430734468-31785-1-git-send-email-guaneryu@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 04, 2015 at 06:14:28PM +0800, Eryu Guan wrote:
> The following commit introduced a bug when checking for zero length extent
> 
> 5946d08 ext4: check for overlapping extents in ext4_valid_extent_entries()
> 
> Zero length extent could pass the check if lblock is zero.
> 
> Adding the explicit check for zero length back.
> 
> Signed-off-by: Eryu Guan <guaneryu@gmail.com>

Thanks, applied.

					- Ted
