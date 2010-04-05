From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: memory leakage in ext4_mb_init()
Date: Sun, 04 Apr 2010 23:59:00 -0500
Message-ID: <4BB96E14.9010903@redhat.com>
References: <ac8f92701003210701j5926f2c4v843e36bc602a0444@mail.gmail.com>	 <20100322012758.GE11560@thunk.org>	 <ac8f92701003230547p3e56a9cdnff8ce874535db117@mail.gmail.com>	 <87sk7nv4sp.fsf@linux.vnet.ibm.com>	 <x2vac8f92701003280113k2458fcb6mefe6c04875c9b3a3@mail.gmail.com>	 <20100403165340.GA17819@thunk.org>	 <j2tac8f92701004031805s9b09d04csc5adf5199dc9b9a7@mail.gmail.com>	 <20100404180845.GG18524@thunk.org>	 <v2oac8f92701004042053p1738ece4u299dcb481b2fc3f2@mail.gmail.com>	 <4BB966AE.1060207@redhat.com> <t2pac8f92701004042151x3b0c27e2h805778b7b3aeefba@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu,
	"Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@sun.com>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: jing zhang <zj.barak@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20096 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750749Ab0DEE7J (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Apr 2010 00:59:09 -0400
In-Reply-To: <t2pac8f92701004042151x3b0c27e2h805778b7b3aeefba@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

jing zhang wrote:
> 2010/4/5, Eric Sandeen <sandeen@redhat.com>:
>> jing zhang wrote:
>>> 2010/4/5, tytso@mit.edu <tytso@mit.edu>:
>>>> On Sun, Apr 04, 2010 at 09:05:14AM +0800, jing zhang wrote:
>>>>
>>>> How much testing are you doing before submitting patches, out of
>>>> curiosity?
>>> Yes, Ted, it is curiosity that drives me to do hard works, including patch
>>> ext4.
>> It is the language barrier that is making some of this difficult,
>> but I'm not complaining - you speak English much better than I speak any
> 
> You are good guy:) Is English your native language? And, I am curious,
> what is the second language you are able to speak, Eric?

Only a little German.

>> second language.  :)
>>
>> Ted meant that -he- was curious about how much testing you were doing.
> 
> How do know what Ted meant, by iphone?

No, because I am a native English speaker and I understood the 
figure of speech.  ("out of curiosity")

> I am not good at testing, partially because it is hard to setup the
> required environment, sometimes several hard disks are needed, maybe a
> few boxes, but I try to analyse the C code while reading and
> understanding the works by great maintainers and developers of Linux
> kernel.

Testing really is critical to development; some things can be done by
inspection, but if you don't test it is hard to know if you made a
mistake.

You can always test inside a vm, or on a loopback file, on a single box.

Without testing, you are asking others to do testing for you
(unless the change is so obvious that it can be trusted) 

-Eric
 
>                 - zj


