From: David Miller <davem@davemloft.net>
Subject: Re: 2.6.25-git2: BUG: unable to handle kernel paging request at
 ffffffffffffffff
Date: Thu, 24 Apr 2008 18:35:58 -0700 (PDT)
Message-ID: <20080424.183558.96469288.davem@davemloft.net>
References: <c4e36d110804230150n796c2733x5880b8e24ebc9da8@mail.gmail.com>
	<alpine.LFD.1.10.0804230746480.2779@woody.linux-foundation.org>
	<4811090A.9030809@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: torvalds@linux-foundation.org, zdenek.kabelac@gmail.com,
	mingo@elte.hu, rjw@sisk.pl, paulmck@linux.vnet.ibm.com,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	linux-ext4@vger.kernel.org, herbert@gondor.apana.org.au,
	penberg@cs.helsinki.fi, clameter@sgi.com
To: jirislaby@gmail.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42453
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753774AbYDYBgC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 24 Apr 2008 21:36:02 -0400
In-Reply-To: <4811090A.9030809@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jiri Slaby <jirislaby@gmail.com>
Date: Fri, 25 Apr 2008 00:26:18 +0200

> ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadccf0 

0xf0...  Is this a 4-cpu machine?

I doubt it, because this is on a laptop as far as I can tell,
but I thought I'd ask. :-)

So the clue is setting some byte at ((offset % 8) == 0) into a
structure with 0xf0...


