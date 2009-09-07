From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] resize2fs: calculate minimal fs size only once
Date: Mon, 7 Sep 2009 14:21:18 -0400
Message-ID: <20090907182118.GB22901@mit.edu>
References: <1252048959-7936-1-git-send-email-bergwolf@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Peng Tao <bergwolf@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:43050 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751886AbZIGSVV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 Sep 2009 14:21:21 -0400
Content-Disposition: inline
In-Reply-To: <1252048959-7936-1-git-send-email-bergwolf@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 04, 2009 at 03:22:39PM +0800, Peng Tao wrote:
> When running resize2fs -M, no need to recalculate the minimal fs size.
> 
> Signed-off-by: "Peng Tao" <bergwolf@gmail.com>

Applied to the maint branch, thanks.

					- Ted
