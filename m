From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: journal recovery problems with metadata_csum, *non-64bit*
Date: Fri, 8 Aug 2014 20:21:31 -0400
Message-ID: <20140809002131.GR25145@thunk.org>
References: <BLU436-SMTP84585FAA628776E190822AFDEE0@phx.gbl>
 <20140808214732.GN25145@thunk.org>
 <BLU436-SMTP222E1BBA304D4F1F10EC4A6FDEE0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: TR Reardon <thomas_reardon@hotmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51804 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751288AbaHIAVg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 8 Aug 2014 20:21:36 -0400
Content-Disposition: inline
In-Reply-To: <BLU436-SMTP222E1BBA304D4F1F10EC4A6FDEE0@phx.gbl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 08, 2014 at 06:29:40PM -0400, TR Reardon wrote:
> 
> Using master @ de25d9c8c48c7474828e9452184e204b18b8e090, which was the
> 1.42.11 release.  The current master and next have same problem.

What's going on is that the "master" and "next" branches on the
e2fsprogs git tree are development branches which will eventually be
the 1.43.0 release.  The "maint" branch is where the 1.42.x releases
are cut.

The maint branch does not have metadata_csum and inline_data support
at all.  It's not a matter of it being disabled, that code is simply
not there.

So I'm not sure what you mean by "master @
de25d9c8c48c7474828e9452184e204b18b8e090".  Your local git tree may
have assigned master to that git commit id, but then it wouldn't have
any metadata_csum support at all.


> I'd rather use debian versions, but metadata_csum is disabled there.
> debian does not sync with git master, so what exactly does it sync
> with?  ie, how are the metadata_csum patches dropped, since they exist
> in master?

See above.  The reason why debian doesn't support metadata_csum is
because it's not ready yet.  If you'd like to help us debug it, we
will be very grateful, but please understand it's still a work in
progress.

There's a big difference between "it mostly works", and "it's ready
for it to be used in production".  When I have time I might drop a
1.43-WIP ("work in progress") into debian experimental, but Debian
Jessie is going to be targetting 3.16, and we will need to make sure
that all of the necessary kernel bits for metadata_csum and
inline_data are working flawlessly before I'll want to let a 1.43
release into Debian testing --- and that's assuming we can get the
1.43 userspace bits fully stablized as well before Jessie date of
November 5, 2014.

Cheers,

					- Ted
