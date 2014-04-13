From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/3] ext4: always check ext4_ext_find_extent result
Date: Sun, 13 Apr 2014 18:06:01 -0400
Message-ID: <20140413220601.GE8122@thunk.org>
References: <1397403361-20459-1-git-send-email-dmonakhov@openvz.org>
 <1397403361-20459-2-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53677 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859AbaDMWGD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 13 Apr 2014 18:06:03 -0400
Content-Disposition: inline
In-Reply-To: <1397403361-20459-2-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Apr 13, 2014 at 07:36:00PM +0400, Dmitry Monakhov wrote:
> Where are some places where logic guaranties us that extent we are
> searching exits, but this may not be true due to on-disk data
> corruption. If such corruption happens we must prevent possible
> null pointer dereferences.
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>

Thanks, applied.

					- Ted
