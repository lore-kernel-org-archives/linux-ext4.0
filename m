From: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: 2.6.25-git2: BUG: unable to handle kernel paging request at ffffffffffffffff
Date: Fri, 25 Apr 2008 00:26:18 +0200
Message-ID: <4811090A.9030809@gmail.com>
References: <alpine.LFD.1.10.0804201410090.2779@woody.linux-foundation.org>  <480D1CF1.7010300@gmail.com> <480D208A.9050909@gmail.com>  <200804220254.45251.rjw@sisk.pl>  <alpine.LFD.1.10.0804211759030.2779@woody.linux-foundation.org>  <480DB493.6080004@gmail.com> <20080422095315.GA28014@elte.hu>  <c4e36d110804221135v1dbfaf1bn4557052d1ead6060@mail.gmail.com>  <alpine.LFD.1.10.0804221144130.2779@woody.linux-foundation.org> <c4e36d110804230150n796c2733x5880b8e24ebc9da8@mail.gmail.com> <alpine.LFD.1.10.0804230746480.2779@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Zdenek Kabelac <zdenek.kabelac@gmail.com>,
	Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
	paulmck@linux.vnet.ibm.com, David Miller <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, herbert@gondor.apana.org.au,
	Pekka Enberg <penberg@cs.helsinki.fi>,
	Christoph Lameter <clameter@sgi.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:31031 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754226AbYDXW0Z (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Apr 2008 18:26:25 -0400
Received: by fg-out-1718.google.com with SMTP id l27so3282428fgb.17
        for <linux-ext4@vger.kernel.org>; Thu, 24 Apr 2008 15:26:21 -0700 (PDT)
In-Reply-To: <alpine.LFD.1.10.0804230746480.2779@woody.linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 04/23/2008 05:53 PM, Linus Torvalds wrote:
>> (SPIN LOCK already disabled is my personal trace ooops which is just
>> checking if the spin_lock_irq is already called with disabled irq - in
>> this place probably irqsave version should be used instead, otherwice
>> it's not properly restored)
> 
> Yes, that's interesting to see.

And this too :/:

#include <err.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#define MAGIC 0xff00aa00deadcc22ULL

int main()
{
         unsigned int a, b, c = 0;
         unsigned long long *ch;

         while (1) {
                 ch = malloc(1000000000);
                 if (!ch)
                         err(1, "malloc");

                 for (a = 0; a < 1000000000/sizeof(*ch); a++)
                         ch[a] = MAGIC;

                 printf("alloced %u\n", c);
                 sleep(10);

                 for (a = 0; a < 1000000000/sizeof(*ch); a++)
                         if (ch[a] != MAGIC) {
                                 printf("WHAT THE HELL (%.8lx):\n", a * 
sizeof(*ch));
                                 for (b = a - a % 10; b < (a - a % 10) + 100; b++) {
                                         printf("%.16llx ", ch[b]);
                                         if (!((b + 1) % 10))
                                                 puts("");
                                 }
                                 exit(1);
                         }
                 free(ch);
                 printf("freed %u\n", c);
                 sleep(10);
                 c++;
         }

         return 0;
}

20 arpings running on wlan0 (don't know if this is related so far), suspend, 
resume, right after resume:

freed 114
alloced 115
freed 115
alloced 116
WHAT THE HELL (000a3ff8):
ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 
ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadccf0 
ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadccf0 ff00aa00deadcc22 ff00aa00deadcc22 
ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 
ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 
ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 
ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 
ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 
ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 
ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 
ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 
ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 
ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 
ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 
ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 
ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 
ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 
ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 
ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 
ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 
ff00aa00deadcc22 ff00aa00deadcc22

Again those fuc*ing 0xf0s...

Shouldn't be 2.6.25 uttered as broken until this is solved to not corrupt 
anyone's data? I'm going to play with that testing program further in the meantime.
