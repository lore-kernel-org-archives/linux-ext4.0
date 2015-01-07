From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4_da_update_reserve_space warning fix not in stable
Date: Wed, 7 Jan 2015 14:53:24 -0500
Message-ID: <20150107195324.GN7291@thunk.org>
References: <54AD772B.2050003@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca, jack@suse.cz
To: Josh Hunt <johunt@akamai.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:57313 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753628AbbAGTx2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 7 Jan 2015 14:53:28 -0500
Content-Disposition: inline
In-Reply-To: <54AD772B.2050003@akamai.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 07, 2015 at 12:12:59PM -0600, Josh Hunt wrote:
> We are hitting the following warning in the field pretty frequently on the
> latest 3.10 stable kernel:
> [11708.763067] WARNING: at fs/ext4/inode.c:363
> ext4_da_update_reserve_space+0x261/0x280 [ext4]()
> 
> The issue was resolved via "ext4: fix warning in
> ext4_da_update_reserve_space()" (7d7345322d60ed), but the fix was not
> submitted as a stable update for 3.10. I was wondering if there's a reason
> why this was not done, or if it was just overlooked?
> 
> The patch appears to have a dependency on "quota: provide interface for
> readding allocated space into reserved space" (1c8924eb106c1ac), so I think
> both would need to be submitted if you feel it's possible.

Have you tried backporting these two commits, and does it fix the
problem for you?

I think it was mostly an oversight, although it might have also been
my thinking that it was only a warning, so it wasn't that critical to
backport.  To be honest, I can't really recall exactly what happened
with that patch at this point.

If it does seen to work for you, I'm happy to suggest to the 3.10
stable kernel maintainers to have it be backported.

						- Ted
						
