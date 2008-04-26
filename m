From: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH 1/1] x86: fix text_poke
Date: Sat, 26 Apr 2008 13:16:16 +0200
Message-ID: <48130F00.5010408@gmail.com>
References: <20080425.021301.193689806.davem@davemloft.net> <1209343883-7991-1-git-send-email-jirislaby@gmail.com> <alpine.LFD.1.10.0804250759260.2779@woody.linux-foundation.org> <20080425151747.GA3265@one.firstfloor.org> <Pine.LNX.4.64.0804251235550.6337@schroedinger.engr.sgi.com> <20080426095938.GB17905@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Christoph Lameter <clameter@sgi.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	David Miller <davem@davemloft.net>, zdenek.kabelac@gmail.com,
	rjw@sisk.pl, paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
	linux-ext4@vger.kernel.org, herbert@gondor.apana.org.au,
	penberg@cs.helsinki.fi, linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	pageexec@freemail.hu, "H. Peter Anvin" <hpa@zytor.com>,
	Jeremy Fitzhardinge <jeremy@goop.org>,
	Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:46549 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556AbYDZLQ1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 26 Apr 2008 07:16:27 -0400
Received: by fg-out-1718.google.com with SMTP id l27so4012585fgb.17
        for <linux-ext4@vger.kernel.org>; Sat, 26 Apr 2008 04:16:26 -0700 (PDT)
In-Reply-To: <20080426095938.GB17905@one.firstfloor.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 04/26/2008 11:59 AM, Andi Kleen wrote:
> On Fri, Apr 25, 2008 at 12:36:33PM -0700, Christoph Lameter wrote:
>> On Fri, 25 Apr 2008, Andi Kleen wrote:
>>
>>>> And we should really add a lot more sanity checking there.
>>> A debug mode for virt_to_page(),__pa,__va et.al. would probably make sense
>>> and would have caught it.
>>>
>>> I used to have that partly in the x86-64 port with VIRTUAL_BUG_ON.
>> Good idea! Do you have a patch?
> 
> Yes. Appended. But it just enables the old NUMA VIRTUAL_BUG_ON()s, more 
> work could be done e.g. by instrumenting pa/va and the non NUMA and i386 
> case too.

Is anybody working on that? I would volunteer to do it.

> --- linux.orig/include/asm-x86/mmzone_64.h
> +++ linux/include/asm-x86/mmzone_64.h
> @@ -7,7 +7,11 @@
>  
>  #ifdef CONFIG_NUMA
>  
> +#ifdef CONFIG_DEBUG_VIRTUAL
> +#define VIRTUAL_BUG_ON(x) BUG_ON(x)
> +#else
>  #define VIRTUAL_BUG_ON(x)
> +#endif
>  
>  #include <asm/smp.h>
