From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: jbd/jbd2 performance improvements
Date: Thu, 16 Oct 2008 07:39:04 -0500
Message-ID: <48F735E8.7060803@redhat.com>
References: <E1KnCO6-0001qG-SV@closure.thunk.org>	<48F62893.9060606@redhat.com> <18678.55651.556822.187508@frecb006361.adech.frec.bull.fr> <48F72E5F.2050409@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Solofo.Ramangalahy@bull.net, "Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:44480 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752293AbYJPMkA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 Oct 2008 08:40:00 -0400
In-Reply-To: <48F72E5F.2050409@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ric Wheeler wrote:
> Solofo.Ramangalahy@bull.net wrote:
>> Hi Ric,
>>
>>   
>>>>>>> On Wed, 15 Oct 2008 13:29:55 -0400, Ric Wheeler <rwheeler@redhat.com> said:
>>>>>>>             
>>     Ric> We are going to try and poke at this - do you suspect a single or 
>>     Ric> multi-threaded test would work best?
>>
>> I've performed some tests:
>> http://www.bullopensource.org/ext4/20081013-2.6.27-rc9-ext4-1-akpm-fix-run6/
>> http://www.bullopensource.org/ext4/20081013-2.6.27-rc9-ext4-1-akpm-fix-run6/results_sorted.txt.html
>>
>> I now realize that the results may not be valid since I used kvm, but
>> they do show variation wrt. the number of threads.
>>
>> So you may want to test both single and multi-threaded.
>>
>>   
> A very thorough test, but the results don't seem to point to a 
> consistent winner.
> 
> I agree that running without KVM in the picture might be very 
> interesting. Eric has some similar tests underway, I think that his 
> results were also inconclusive so far...

Yep, I've yet to find an fs_mark invocation, at least, which shows a
clear winner.  I also ran w/ akpm's suggested io_schedule watcher patch
and never see us waiting on this lock (I did set it to 1s though, which
is probably too long for my storage).

-Eric
