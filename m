From: David Turner <novalis@novalis.org>
Subject: Re: [PATCH] ext4: explain encoding of 34-bit a,c,mtime values
Date: Sun, 10 Nov 2013 02:56:54 -0500
Message-ID: <1384070214.8994.47.camel@chiang>
References: <1383808590.23882.13.camel@chiang>
	 <20131107160341.GA3850@quack.suse.cz> <1383864864.23882.33.camel@chiang>
	 <20131107231445.GG2054@quack.suse.cz> <1383866807.23882.41.camel@chiang>
	 <D8C465B6-15A7-473A-BA26-8037AF9CE739@dilger.ca>
	 <1383981551.8994.27.camel@chiang>
	 <CADQUmxULoLgXRyoPpJJMJLqJPsZ8M4oPP8ScGxWp+Np8-efq3g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@dilger.ca>, Jan Kara <jack@suse.cz>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>
To: Mark Harris <mhlk@osj.us>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from caiajhbdcaid.dreamhost.com ([208.97.132.83]:48812 "EHLO
	homiemail-a21.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750769Ab3KJH44 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 10 Nov 2013 02:56:56 -0500
In-Reply-To: <CADQUmxULoLgXRyoPpJJMJLqJPsZ8M4oPP8ScGxWp+Np8-efq3g@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, 2013-11-09 at 15:51 -0800, Mark Harris wrote:
> 
> The problem with the existing encoding is that pre-1970 dates are
> encoded with extra bits 1,1 in 64-bit kernels with ext4, but on 32-bit
> kernels and inodes that were originally written as ext3 the extra bits
> will be 0,0.  Currently, both are decoded as pre-1970 dates.
> 
> With your patch, only the 1,1 format used by 64-bit ext4 will decode
> as a pre-1970 date.  Dates previously written by ext3 or a 32-bit
> kernel will no longer be decoded as expected.  Also the patch does
> not update ext4_encode_extra_time to use this format for pre-1970
> dates in 32-bit mode.

You're right -- I missed the complexity here.

> Possible solutions were discussed here, but no decision was made:
> http://thread.gmane.org/gmane.comp.file-systems.ext4/26087/focus=26406

To summarize, the previous discussion offered four possible solutions,
of which two were thought good:

b. Use Andreas's encoding, which is incompatible with pre-1970 files
written on 64-bit systems.

c. Use an encoding which is compatible with all pre-1970 files, but
incompatible with 64-bit post-2038 files, and which encodes a smaller
range of time and is more complicated. 

-------
I don't care about currently-existing post-2038 files, because I believe
that nobody has a valid reason to have such files.  However, I do
believe that pre-1970 files are probably important to someone.

Despite this, I prefer option (b), because I think the simplicity is
valuable, and because I hate to give up date ranges (even ones that I
think we'll "never" need). Option (b) is not actually lossy, because we
could correct pre-1970 files with e2fsck; under Andreas's encoding,
their dates would be in the far future (and thus cannot be legitimate).

Would a patch that does (b) be accepted?  I would accompany it with a
patch to e2fsck (which I assume would also go to the ext4 developers
mailing list?).

