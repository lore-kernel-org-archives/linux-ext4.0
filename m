From: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: 2.6.25-git2: BUG: unable to handle kernel paging request at ffffffffffffffff
Date: Fri, 25 Apr 2008 09:42:43 +0200
Message-ID: <48118B73.6000700@gmail.com>
References: <c4e36d110804230150n796c2733x5880b8e24ebc9da8@mail.gmail.com>	<alpine.LFD.1.10.0804230746480.2779@woody.linux-foundation.org>	<4811090A.9030809@gmail.com> <20080424.183558.96469288.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: torvalds@linux-foundation.org, zdenek.kabelac@gmail.com,
	mingo@elte.hu, rjw@sisk.pl, paulmck@linux.vnet.ibm.com,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	linux-ext4@vger.kernel.org, herbert@gondor.apana.org.au,
	penberg@cs.helsinki.fi, clameter@sgi.com
To: David Miller <davem@davemloft.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:30951 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757519AbYDYHmt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 25 Apr 2008 03:42:49 -0400
Received: by fg-out-1718.google.com with SMTP id l27so3488995fgb.17
        for <linux-ext4@vger.kernel.org>; Fri, 25 Apr 2008 00:42:47 -0700 (PDT)
In-Reply-To: <20080424.183558.96469288.davem@davemloft.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 04/25/2008 03:35 AM, David Miller wrote:
> From: Jiri Slaby <jirislaby@gmail.com>
> Date: Fri, 25 Apr 2008 00:26:18 +0200
> 
>> ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadccf0 
> 
> 0xf0...  Is this a 4-cpu machine?

It's a 2 cores machine.

> I doubt it, because this is on a laptop as far as I can tell,
> but I thought I'd ask. :-)

Well, it's not :), it's a desktop.

		Jiri
