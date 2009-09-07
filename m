From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] resize2fs: fix minimum resize size calculation with
	flex_bg
Date: Mon, 7 Sep 2009 14:21:31 -0400
Message-ID: <20090907182131.GC22901@mit.edu>
References: <1252055740-9993-1-git-send-email-bergwolf@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>
To: Peng Tao <bergwolf@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:43058 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752118AbZIGSVd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 Sep 2009 14:21:33 -0400
Content-Disposition: inline
In-Reply-To: <1252055740-9993-1-git-send-email-bergwolf@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 04, 2009 at 05:15:40PM +0800, Peng Tao wrote:
> When flex_bg is on, calculate_minimum_resize_size() should add more meta
> blocks for newly added flex_bg.
> 
> Addresses-Red-Hat-Bug: #519131
> Signed-off-by: Peng Tao <bergwolf@gmail.com>

Applied to the maint branch, thanks.

					- Ted
