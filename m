From: Theodore Tso <tytso@mit.edu>
Subject: Re: [RFC][PATCH 0/3]ext4: online defrag (ver 2.0)
Date: Sat, 13 Jun 2009 00:27:47 -0400
Message-ID: <20090613042747.GI24336@mit.edu>
References: <4A164EC9.3070405@rs.jp.nec.com> <87f94c370906111603l4ed1c383tf0d725cb5ac95eaf@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Akira Fujita <a-fujita@rs.jp.nec.com>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:51477 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751249AbZFME1t (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 13 Jun 2009 00:27:49 -0400
Content-Disposition: inline
In-Reply-To: <87f94c370906111603l4ed1c383tf0d725cb5ac95eaf@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 11, 2009 at 07:03:32PM -0400, Greg Freemyer wrote:
> Ted / Akira,
> 
> What's the status of this.  I certainly like the ABI much better now
> than on the previous try.
> 
> I don't know the ext4 code internally so I can't speak to the
> implementation quality, but I know this has been floating around for a
> long time and seems to just be getting better and better.
> 
> Any chance of it being merged soon?

Sorry, I've been pretty busy trying to fix some rather critical and
nasty ext4 bugs, and then getting things ready for the merge window.

I've dropped Akira's patch into unstable portion of the ext4 patch
queue for testing.  I want to take a closer look at the ABI, but I
agree it is much better.  If the ABI is good, I'm likely to try
merging it this merge window, on the grounds that any implementation
issues can be cleaned up later, since it is a relatively
self-contained patch.

						- Ted
