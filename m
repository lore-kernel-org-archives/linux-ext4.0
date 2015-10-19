From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] ext4: explicit mount options parsing cleanup
Date: Sun, 18 Oct 2015 23:57:21 -0400
Message-ID: <20151019035721.GR2678@thunk.org>
References: <1444381799-10566-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:58176 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752320AbbJSD5Y (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 18 Oct 2015 23:57:24 -0400
Content-Disposition: inline
In-Reply-To: <1444381799-10566-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 09, 2015 at 01:09:58PM +0400, Dmitry Monakhov wrote:
> Currently MOPT_EXPLICIT treated as EXPLICIT_DELALLOC which may be changed
> in future. Let's fix it now.
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>

Applied, thanks.

					- Ted
