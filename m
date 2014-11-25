From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: fuzz testing a KVM machine (x86) with ext4fs forces much more
 often the oom killer than btrfs
Date: Mon, 24 Nov 2014 22:15:12 -0500
Message-ID: <20141125031512.GE31339@thunk.org>
References: <547390CC.2050306@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:48995 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751216AbaKYDPQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 24 Nov 2014 22:15:16 -0500
Content-Disposition: inline
In-Reply-To: <547390CC.2050306@gmx.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

No idea; can you grab /proc/slabinfo and /proc/meminfo every minute or
so until it oom kills trinity?  Maybe that will give us a hint of at
least where the memory is getting consumed.

It could be the extent status tree cache, for which the need for a
better shrinker is a known bug that we're working on, but that's just
a wild guess.

Thanks,

						- Ted
