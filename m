From: jing zhang <zj.barak@gmail.com>
Subject: Re: [PATCH] ext4: memory leakage in ext4_mb_init()
Date: Mon, 5 Apr 2010 12:51:52 +0800
Message-ID: <t2pac8f92701004042151x3b0c27e2h805778b7b3aeefba@mail.gmail.com>
References: <ac8f92701003210701j5926f2c4v843e36bc602a0444@mail.gmail.com>
	 <20100322012758.GE11560@thunk.org>
	 <ac8f92701003230547p3e56a9cdnff8ce874535db117@mail.gmail.com>
	 <87sk7nv4sp.fsf@linux.vnet.ibm.com>
	 <x2vac8f92701003280113k2458fcb6mefe6c04875c9b3a3@mail.gmail.com>
	 <20100403165340.GA17819@thunk.org>
	 <j2tac8f92701004031805s9b09d04csc5adf5199dc9b9a7@mail.gmail.com>
	 <20100404180845.GG18524@thunk.org>
	 <v2oac8f92701004042053p1738ece4u299dcb481b2fc3f2@mail.gmail.com>
	 <4BB966AE.1060207@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: tytso@mit.edu,
	"Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@sun.com>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:34597 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835Ab0DEEvx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 5 Apr 2010 00:51:53 -0400
Received: by gyg13 with SMTP id 13so1865432gyg.19
        for <linux-ext4@vger.kernel.org>; Sun, 04 Apr 2010 21:51:52 -0700 (PDT)
In-Reply-To: <4BB966AE.1060207@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2010/4/5, Eric Sandeen <sandeen@redhat.com>:
> jing zhang wrote:
>> 2010/4/5, tytso@mit.edu <tytso@mit.edu>:
>>> On Sun, Apr 04, 2010 at 09:05:14AM +0800, jing zhang wrote:
>>>
>>> How much testing are you doing before submitting patches, out of
>>> curiosity?
>>
>> Yes, Ted, it is curiosity that drives me to do hard works, including patch
>> ext4.
>
> It is the language barrier that is making some of this difficult,
> but I'm not complaining - you speak English much better than I speak any

You are good guy:) Is English your native language? And, I am curious,
what is the second language you are able to speak, Eric?

> second language.  :)
>
> Ted meant that -he- was curious about how much testing you were doing.

How do know what Ted meant, by iphone?

>
> ...
>
>> And after operations on cmdline, I compile the modified, modprobe, dd,
>> and rmmod with virtual machine. It is not hard.
>
> More testing than this would be good; dd is very minimal.
>
> One of our new standard tests for et4 is the xfstests test suite from
> http://git.kernel.org/?p=fs/xfs/xfstests-dev.git;a=summary
>
> It is a collection of many tests developed for xfs, but many tests are
> generic and can run on ext4 as well.  I would suggest that after you have
> several patches ready, you should at least run through the tests in this
> collection.  It won't catch every mistake but it runs a large variety of
> tests, much more stressful than dd.

Thanks for your good advice.

>
> Thanks for your email, and thanks for clearly spending time looking for
> ways to improve ext4.  I think that with practice, you will be a good
> contributor.
>
> Ted can certainly be a patient maintainer - read his suggestions and the
> kernel patch submission guidelines, and I think you will get better at this.
>
> Do your best to explain the reasons for your patches, and any testing you
> have done, and describe any test which can show a bug that you find -
> and we can help to clarify changelogs if they need it.
>

I am not good at testing, partially because it is hard to setup the
required environment, sometimes several hard disks are needed, maybe a
few boxes, but I try to analyse the C code while reading and
understanding the works by great maintainers and developers of Linux
kernel.

                - zj
