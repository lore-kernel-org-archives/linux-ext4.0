From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: return ENOMEM rather than EIO when find_###_page()
 fails
Date: Thu, 10 Apr 2014 23:05:45 -0400
Message-ID: <20140411030545.GC23620@thunk.org>
References: <534516D8.9010803@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Younger Liu <younger.liucn@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52735 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754386AbaDKDFr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 Apr 2014 23:05:47 -0400
Content-Disposition: inline
In-Reply-To: <534516D8.9010803@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 09, 2014 at 05:46:00PM +0800, Younger Liu wrote:
> 
>   Return ENOMEM rather than EIO when find_get_page() fails in 
> ext4_mb_get_buddy_page_lock() and find_or_create_page() fails in
> ext4_mb_load_buddy().
> 
> Signed-off-by: Younger Liu <younger.liucn@gmail.com>

Thanks, applied.

						- Ted
