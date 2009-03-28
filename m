From: Theodore Tso <tytso@mit.edu>
Subject: Re: Once more: Recovering a damaged ext4 fs?
Date: Sat, 28 Mar 2009 08:30:35 -0400
Message-ID: <20090328123035.GD2155@mit.edu>
References: <p0624058dc5f2d7be08cc@[130.161.115.44]> <20090327224616.GD5176@mit.edu> <p0624058ec5f30b501efb@[130.161.115.44]>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "J.D. Bakker" <jdb@lartmaker.nl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:36888 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751173AbZC1Mak (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 28 Mar 2009 08:30:40 -0400
Content-Disposition: inline
In-Reply-To: <p0624058ec5f30b501efb@[130.161.115.44]>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Mar 28, 2009 at 12:47:19AM +0100, J.D. Bakker wrote:
>
>> P.S.  You were using a completely stock kernel, correct?  No other
>> patches installed?
>
> Yes.
>

Hi J.D.,

Can you verify exactly what kernel version you are using?  This issue
is being discussed at:

https://bugs.launchpad.net/ubuntu/+source/linux/+bug/330824

... and one person has said it was fixed in 2.6.28-rc8, and at least
one, possibly two people have reported that it has been fixed in
2.6.29.  I think you're running some version of 2.6.28 or 2.6.28.y,
correct?

If these report is correct, the problem may be fixed already in
mainline, but I'd like to figure out *which* patch made the problem go
away, so we can get it backported into various distribution kernels
and into the 2.6.28.* and and possibly the 2.6.27.* stable series.

Thanks,

						- Ted
