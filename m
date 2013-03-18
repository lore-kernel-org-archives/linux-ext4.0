From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Use EXT4_BOOT_LOADER_INO for boot loader GRUB?
Date: Mon, 18 Mar 2013 09:51:37 -0400
Message-ID: <20130318135137.GB8523@thunk.org>
References: <51023FEA.7000802@reinform.de>
 <20130126184927.GB20005@thunk.org>
 <op.wt48ybxow201t7@cnd0370px4.ent.rt.verigy.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Dr. Tilmann Bubeck" <t.bubeck@reinform.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:54085 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751419Ab3CRNvl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 18 Mar 2013 09:51:41 -0400
Content-Disposition: inline
In-Reply-To: <op.wt48ybxow201t7@cnd0370px4.ent.rt.verigy.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 18, 2013 at 02:26:25PM +0100, Dr. Tilmann Bubeck wrote:
> Ted,
> 
> I sent a patch implementing your idea from below at 2013-02-23 to
> the mailing list. It has received a
> 
> Reviewed-by: Andreas Dilger <adilger@dilger.ca>
> 
> Is there anything more to do to get this accepted? I am willing to
> do more cleanups, if you request them.

Sorry, I'm still working on stablizing and fixing bugs/regressions
from the last merge window, so I haven't started looking at patches
which introduce new features.  I'll hopefully get to it in the next
week or two....

							- Ted
