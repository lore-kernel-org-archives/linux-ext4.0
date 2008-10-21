From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH -v2] ext4: remove usage of Uptodate flag to initialize
	buddy after an online resize
Date: Tue, 21 Oct 2008 11:52:28 -0400
Message-ID: <20081021155228.GE15685@mit.edu>
References: <1222872243.11560.19.camel@frecb007923.frec.bull.fr> <1223036515.4075.11.camel@frecb007923.frec.bull.fr> <1224602191.3569.25.camel@frecb007923.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: =?iso-8859-1?Q?Fr=E9d=E9ric_Boh=E9?= <frederic.bohe@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:40679 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751933AbYJUPwc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 21 Oct 2008 11:52:32 -0400
Content-Disposition: inline
In-Reply-To: <1224602191.3569.25.camel@frecb007923.frec.bull.fr>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Frederic,

Thanks for posting the update to your patch; I take it you've solved
the race condition?  I haven't take a look at your updated patch yet,
but one thought that might make the potential race conditions much
simpler to analyze and prevent.

At the moment, the resize code, just before it calls to fix up the
mballoc data structures, calls ext4_free_blocks_sb() to mark the block
bitmap as being freed.  That call should really go away, as
ext4_free_blocs_sb() is a remnant from the legacy block allocator, and
in fact does a lot of extra stuff that is not needed by mballoc().
Perhaps the right answer is that we should have one function that
updates the block bitmap, as well as initializing the mballoc() data
structures, and it would *only* be called from the resize code.  If
the concern is protecting against multiple resizers running at the
same time, then let's either (a) not call unlock_super() until the
mballoc data structures are initialized, or (b) create a new mutex
that is explicit for use by the online resize code.

							- Ted
