From: David Miller <davem@davemloft.net>
Subject: Re: 2.6.25-git2: BUG: unable to handle kernel paging request at
 ffffffffffffffff
Date: Fri, 25 Apr 2008 02:13:01 -0700 (PDT)
Message-ID: <20080425.021301.193689806.davem@davemloft.net>
References: <4811090A.9030809@gmail.com>
	<alpine.LFD.1.10.0804241539150.2779@woody.linux-foundation.org>
	<4812108D.6020103@gmail.com>
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
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36151
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758819AbYDYJNB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Apr 2008 05:13:01 -0400
In-Reply-To: <4812108D.6020103@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jiri Slaby <jirislaby@gmail.com>
Date: Fri, 25 Apr 2008 19:10:37 +0200

> I'm going to bisect it, will be back in few hours ;).

Thanks for all of this hard work and investigation Jiri!
