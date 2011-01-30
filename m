From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/3] ext4 : Pass GFP_KERNEL for transaction allocation
 if caller can handler failures
Date: Sun, 30 Jan 2011 14:42:51 -0500
Message-ID: <20110130194251.GE4258@thunk.org>
References: <AANLkTinVBicZyTthnp5SjOoHUWHcKc1Css46RjpfEEnh@mail.gmail.com>
 <20110125161745.GC4088@quack.suse.cz>
 <AANLkTiniUaD8SN53BKFC2ayku-4m=4EATKxBc148d51G@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, ext4 <linux-ext4@vger.kernel.org>
To: Manish Katiyar <mkatiyar@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:46398 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752433Ab1A3Tmy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 30 Jan 2011 14:42:54 -0500
Content-Disposition: inline
In-Reply-To: <AANLkTiniUaD8SN53BKFC2ayku-4m=4EATKxBc148d51G@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 25, 2011 at 12:05:07PM -0800, Manish Katiyar wrote:
> Thanks a lot Jan, I will have a look at the functions you mentioned
> and send an updated version.

Please do the cleanups as separate patches, each with a separate
commit description.

Thanks!!

					- Ted
