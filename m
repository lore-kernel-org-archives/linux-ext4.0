From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH][BUG] ext4: dx_map_entry cannot support over 64KB block
	size
Date: Tue, 23 Jun 2009 11:28:11 -0400
Message-ID: <20090623152811.GD26079@mit.edu>
References: <20090605165049.e8bd9c74.toshi.okajima@jp.fujitsu.com> <20090605212000.GV9002@webber.adilger.int> <20090608163055.0eab9737.toshi.okajima@jp.fujitsu.com> <20090621035731.GA6719@mit.edu> <4A3EE269.3020704@jp.fujitsu.com> <20090622024757.GB26079@mit.edu> <4A404CC0.9050202@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org
To: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:32794 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755094AbZFWP2l (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 23 Jun 2009 11:28:41 -0400
Content-Disposition: inline
In-Reply-To: <4A404CC0.9050202@jp.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 23, 2009 at 12:32:16PM +0900, Toshiyuki Okajima wrote:
> No, I am not. But I have considered that POWERPC system has been
> supported over 64KB page size after I examined all Kconfig's in kernel
> source. Therefore I thought this bug should be fixed in kernel side.

I hadn't ealized that PowerPC had support for 256k page sizes.  Looks
like it only works on a specialized embedded (AMCC) processor, with a
patched set of binutils, and all of the binaries have to be rebuilt to
accomodate having the ELF sections aligned on something greater than
64k boudaries (i.e. standard PPC distributions won't work).  So it's
not likely that I'm going to be able to get access to something that
will support such large pagesizes in the near future.

> I don't think this feature (over 64KB block size support) to be
> necessary immediately. Because I have been investigating ext4 for my
> customers in order that I may provide them greater quality and
> performance but they don't want it now.

That's my assessment on interest in >64k block size support as well; I
will prioritize accordingly.  I just wanted to make sure there wasn't
some customers interested in some unusual use case that I wasn't aware
of.

Regards,

							- Ted
