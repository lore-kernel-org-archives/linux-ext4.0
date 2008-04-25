From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH 1/1] x86: fix text_poke
Date: Fri, 25 Apr 2008 16:37:17 -0400
Message-ID: <20080425203717.GB25950@Krystal>
References: <20080425152650.GA894@elte.hu> <alpine.LFD.1.10.0804250830200.2779@woody.linux-foundation.org> <20080425154854.GC3265@one.firstfloor.org> <alpine.LFD.1.10.0804250904560.2779@woody.linux-foundation.org> <20080425161916.GD3265@one.firstfloor.org> <20080425163035.GE9503@Krystal> <481209F2.4050908@zytor.com> <20080425170929.GA16180@Krystal> <20080425183748.GB16180@Krystal> <48123C9B.9020306@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Andi Kleen <andi@firstfloor.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>, Jiri Slaby <jirislaby@gmail.com>,
	David Miller <davem@davemloft.net>, zdenek.kabelac@gmail.com,
	rjw@sisk.pl, paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
	linux-ext4@vger.kernel.org, herbert@gondor.apana.org.au,
	penberg@cs.helsinki.fi, clameter@sgi.com,
	linux-kernel@vger.kernel.org, pageexec@freemail.hu,
	Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from tomts16.bellnexxia.net ([209.226.175.4]:60173 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764695AbYDYUhU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Apr 2008 16:37:20 -0400
Content-Disposition: inline
In-Reply-To: <48123C9B.9020306@zytor.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* H. Peter Anvin (hpa@zytor.com) wrote:
> Mathieu Desnoyers wrote:
>> This epilogue should then be used on both branches of the condition,
>> like this :
>> if (unlikely(imv_cond(var))) {
>>   imv_cond_end();
>>   ...
>> } else {
>>   imv_cond_end();
>>    ...
>> }
>> Where imv_cond_end() would look like this :
>> +/*
>> + * Puts a test and branch make sure the %al register and ZF are not live
>> + * anymore.
>> + * All asm statements clobbers the flags, but add "cc" clobber just to be 
>> sure.
>> + * Clobbers %al.
>> + */
>> +#define imv_cond_end()                                                 \
>> +       do {                                                            \
>> +               asm (".section __imv_cond_end,\"a\",@progbits\n\t"      \
>> +                               _ASM_PTR "1f\n\t"                       \
>> +                               ".previous\n\t"                         \
>> +                               "1:\n\t"                                \
>> +                               : : : "a", "cc");                       \
>> +       } while (0)
>> +
>
> As far as this is concerned, all you accomplish here is that gcc, if it 
> wants to re-use the %al value, will copy it into another register before 
> doing your imv_conv_end().
>

Exactly, and by doing so, it will have to add instructions (mov, push..)
in the instruction pattern I am looking for and therefore I will detect
this and fall back on standard immediate values.

Mathieu

> 	-hpa

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
