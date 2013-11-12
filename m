From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: explain encoding of 34-bit a,c,mtime values
Date: Mon, 11 Nov 2013 19:30:18 -0500
Message-ID: <20131112003018.GA30281@thunk.org>
References: <1383808590.23882.13.camel@chiang>
 <20131107160341.GA3850@quack.suse.cz>
 <1383864864.23882.33.camel@chiang>
 <20131107231445.GG2054@quack.suse.cz>
 <1383866807.23882.41.camel@chiang>
 <D8C465B6-15A7-473A-BA26-8037AF9CE739@dilger.ca>
 <1383981551.8994.27.camel@chiang>
 <CADQUmxULoLgXRyoPpJJMJLqJPsZ8M4oPP8ScGxWp+Np8-efq3g@mail.gmail.com>
 <1384070214.8994.47.camel@chiang>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mark Harris <mhlk@osj.us>, Andreas Dilger <adilger@dilger.ca>,
	Jan Kara <jack@suse.cz>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: David Turner <novalis@novalis.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:57027 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752657Ab3KLMnZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 Nov 2013 07:43:25 -0500
Content-Disposition: inline
In-Reply-To: <1384070214.8994.47.camel@chiang>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Nov 10, 2013 at 02:56:54AM -0500, David Turner wrote:
> b. Use Andreas's encoding, which is incompatible with pre-1970 files
> written on 64-bit systems.
>
> I don't care about currently-existing post-2038 files, because I believe
> that nobody has a valid reason to have such files.  However, I do
> believe that pre-1970 files are probably important to someone.
> 
> Despite this, I prefer option (b), because I think the simplicity is
> valuable, and because I hate to give up date ranges (even ones that I
> think we'll "never" need). Option (b) is not actually lossy, because we
> could correct pre-1970 files with e2fsck; under Andreas's encoding,
> their dates would be in the far future (and thus cannot be legitimate).
> 
> Would a patch that does (b) be accepted?  I would accompany it with a
> patch to e2fsck (which I assume would also go to the ext4 developers
> mailing list?).

I agree, I think this is the best way to go.  I'm going to drop your
earlier patch, and wait for an updated patch from you.  It may miss
this merge window, but as Andreas has pointed out, we still have a few
years to get this right.  :-)

Thanks!!

					- Ted
