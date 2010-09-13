From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] break out of ext4_num_dirty_pages() when we hit
 max_pages
Date: Mon, 13 Sep 2010 17:24:10 -0400
Message-ID: <20100913212410.GA6312@thunk.org>
References: <4C892EEA.6090007@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:56326 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751460Ab0IMVYM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 Sep 2010 17:24:12 -0400
Content-Disposition: inline
In-Reply-To: <4C892EEA.6090007@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 09, 2010 at 02:00:58PM -0500, Eric Sandeen wrote:
> ext4_num_dirty_pages() will continue scanning after we accumulate
> max_pages, possibly for a very long time without doing anything
> useful at all.  When we hit max_pages, we should set done=1
> so that the break will release the pagevec, exit the loop, and
> return from the function.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Added to the ext4 tree, thanks.

					- Ted
