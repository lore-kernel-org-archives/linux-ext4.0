From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 2/2 take 2] ext4: fix a bug accessing freed memory in
	ext4_abort
Date: Mon, 27 Oct 2008 14:05:30 -0400
Message-ID: <20081027180530.GA23111@mit.edu>
References: <19f34abd0810250422t17990222x78fcf0fad2e6f04b@mail.gmail.com> <49056D29.2010700@hitachi.com> <49056FA5.7070202@hitachi.com> <20081027104325.GA13641@elte.hu> <4905A99F.8000605@hitachi.com> <4905AAF2.8020302@hitachi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>,
	Vegard Nossum <vegard.nossum@gmail.com>,
	Jan Kara <jack@ucw.cz>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Al Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Pekka Enberg <penberg@cs.helsinki.fi>,
	linux-kernel@vger.kernel.org,
	sugita <yumiko.sugita.yf@hitachi.com>,
	Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>
To: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:42289 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751360AbYJ0SGM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Oct 2008 14:06:12 -0400
Content-Disposition: inline
In-Reply-To: <4905AAF2.8020302@hitachi.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Many thanks, Kawai-san, it looks good.  I'll get this queued for
mainline.

		   	 	     	 - Ted
