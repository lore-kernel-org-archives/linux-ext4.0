From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/3] ext4 : Pass GFP_KERNEL for transaction allocation
 if caller can handler failures
Date: Sun, 30 Jan 2011 15:07:12 -0500
Message-ID: <20110130200712.GF4258@thunk.org>
References: <AANLkTinVBicZyTthnp5SjOoHUWHcKc1Css46RjpfEEnh@mail.gmail.com>
 <20110125161745.GC4088@quack.suse.cz>
 <AANLkTiniUaD8SN53BKFC2ayku-4m=4EATKxBc148d51G@mail.gmail.com>
 <20110130194251.GE4258@thunk.org>
 <AANLkTik8_iO=LF=HqmZyNGC=t5TVqEHzb=G78M-NWMHR@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, ext4 <linux-ext4@vger.kernel.org>
To: Manish Katiyar <mkatiyar@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:39052 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753770Ab1A3UHM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 30 Jan 2011 15:07:12 -0500
Content-Disposition: inline
In-Reply-To: <AANLkTik8_iO=LF=HqmZyNGC=t5TVqEHzb=G78M-NWMHR@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jan 30, 2011 at 11:44:25AM -0800, Manish Katiyar wrote:
> 
> Do you mean separate patch for each of the changed functions ?

Unless the cleanups for a set of functions are all the same issue,
yes.  The idea is that commit description should apply to all of the
patch hunks in the commit.

That way if there is a problem, it becomes easier to bisect and then
determine what's going on by reading the commit description.  It also
becomes easier to review the changes, as well.

Does that make sense?

Thanks,

					- Ted
