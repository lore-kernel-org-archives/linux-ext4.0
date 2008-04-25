From: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: 2.6.25-git2: BUG: unable to handle kernel paging request at ffffffffffffffff
Date: Fri, 25 Apr 2008 02:57:24 +0200
Message-ID: <48112C74.8000405@gmail.com>
References: <alpine.LFD.1.10.0804201410090.2779@woody.linux-foundation.org>  <480D1CF1.7010300@gmail.com> <480D208A.9050909@gmail.com>  <200804220254.45251.rjw@sisk.pl>  <alpine.LFD.1.10.0804211759030.2779@woody.linux-foundation.org>  <480DB493.6080004@gmail.com> <20080422095315.GA28014@elte.hu>  <c4e36d110804221135v1dbfaf1bn4557052d1ead6060@mail.gmail.com>  <alpine.LFD.1.10.0804221144130.2779@woody.linux-foundation.org> <c4e36d110804230150n796c2733x5880b8e24ebc9da8@mail.gmail.com> <alpine.LFD.1.10.0804230746480.2779@woody.linux-foundation.org> <4811090A.9030809@gmail.com> <alpine.LFD.1.10.0804241539150.2779@woody.linux-foundation.org>
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
Received: from ug-out-1314.google.com ([66.249.92.173]:12310 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131AbYDXW53 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Apr 2008 18:57:29 -0400
Received: by ug-out-1314.google.com with SMTP id z38so884964ugc.16
        for <linux-ext4@vger.kernel.org>; Thu, 24 Apr 2008 15:57:27 -0700 (PDT)
In-Reply-To: <alpine.LFD.1.10.0804241539150.2779@woody.linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 04/25/2008 12:41 AM, Linus Torvalds wrote:
> 
> On Fri, 25 Apr 2008, Jiri Slaby wrote:
>> 20 arpings running on wlan0 (don't know if this is related so far), suspend,
>> resume, right after resume:
>>
>> freed 114
>> alloced 115
>> freed 115
>> alloced 116
>> WHAT THE HELL (000a3ff8):
>> ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22
> 
> Very interesting indeed.
> 
>> Shouldn't be 2.6.25 uttered as broken until this is solved to not corrupt
>> anyone's data? I'm going to play with that testing program further in the
>> meantime.
> 
> Do you actually see this with _plain_ 2.6.25? So far I've assumed that all 
> the reports are about post-2.6.25 issues.

Blah, sorry, I lived in a theory, that Rafael got one from 2.6.25 and no, 
really, he had -git2 applied. Mea culpa, anyway I'll test 2.6.25 too, just for sure.

> Also, it does seem like you can re-create this at will in ways that others 
> can not. Could you try to bisect it a bit? Right now we have no real clue 
> what it is all about, except that it seems to be related to suspend/resume 
> and there are some indications that it's about networking (and _perhaps_ 
> wireless in particular).

Not really. I have no idea what triggers it. Seems like suspend is some kind of 
catalyzer not working every time. I can't get it to crash for 1 whole day. 
Probably with the program (I hacked it a hour ago or so) it would be easier to 
reveal the error far before the crash itself. Will keep you informed. Now going 
to catch some sleep.
