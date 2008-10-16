From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: jbd/jbd2 performance improvements
Date: Thu, 16 Oct 2008 08:06:55 -0400
Message-ID: <48F72E5F.2050409@redhat.com>
References: <E1KnCO6-0001qG-SV@closure.thunk.org>	<48F62893.9060606@redhat.com> <18678.55651.556822.187508@frecb006361.adech.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Eric Sandeen <sandeen@redhat.com>
To: Solofo.Ramangalahy@bull.net
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:57667 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752959AbYJPMHt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 Oct 2008 08:07:49 -0400
In-Reply-To: <18678.55651.556822.187508@frecb006361.adech.frec.bull.fr>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Solofo.Ramangalahy@bull.net wrote:
> Hi Ric,
>
>   
>>>>>> On Wed, 15 Oct 2008 13:29:55 -0400, Ric Wheeler <rwheeler@redhat.com> said:
>>>>>>             
>     Ric> We are going to try and poke at this - do you suspect a single or 
>     Ric> multi-threaded test would work best?
>
> I've performed some tests:
> http://www.bullopensource.org/ext4/20081013-2.6.27-rc9-ext4-1-akpm-fix-run6/
> http://www.bullopensource.org/ext4/20081013-2.6.27-rc9-ext4-1-akpm-fix-run6/results_sorted.txt.html
>
> I now realize that the results may not be valid since I used kvm, but
> they do show variation wrt. the number of threads.
>
> So you may want to test both single and multi-threaded.
>
>   
A very thorough test, but the results don't seem to point to a 
consistent winner.

I agree that running without KVM in the picture might be very 
interesting. Eric has some similar tests underway, I think that his 
results were also inconclusive so far...

Ric


