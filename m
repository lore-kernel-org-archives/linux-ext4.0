From: Andreas Schwab <schwab@linux-m68k.org>
Subject: Re: [PATCH] e2fsprogs: m68k bitops fixes
Date: Mon, 17 Dec 2012 19:15:30 +0100
Message-ID: <m2a9tc7dfh.fsf@igel.home>
References: <20685.53075.403265.997210@pilspetsen.it.uu.se>
	<20686.16276.932405.296864@pilspetsen.it.uu.se>
	<20121217144902.GC31563@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Mikael Pettersson <mikpe@it.uu.se>, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:50443 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753570Ab2LQSPg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 17 Dec 2012 13:15:36 -0500
In-Reply-To: <20121217144902.GC31563@thunk.org> (Theodore Ts'o's message of
	"Mon, 17 Dec 2012 09:49:02 -0500")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Ts'o <tytso@mit.edu> writes:

> It would be a good idea to check the m68k kernel, since it was cribbed
> from the kernel sources.

The kernel bitops always use signed bit numbers.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
