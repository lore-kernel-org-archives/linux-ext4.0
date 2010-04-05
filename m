From: jing zhang <zj.barak@gmail.com>
Subject: Re: [PATCH] ext4: memory leakage in ext4_mb_init()
Date: Mon, 5 Apr 2010 11:53:48 +0800
Message-ID: <v2oac8f92701004042053p1738ece4u299dcb481b2fc3f2@mail.gmail.com>
References: <ac8f92701003210701j5926f2c4v843e36bc602a0444@mail.gmail.com>
	 <20100322012758.GE11560@thunk.org>
	 <ac8f92701003230547p3e56a9cdnff8ce874535db117@mail.gmail.com>
	 <87sk7nv4sp.fsf@linux.vnet.ibm.com>
	 <x2vac8f92701003280113k2458fcb6mefe6c04875c9b3a3@mail.gmail.com>
	 <20100403165340.GA17819@thunk.org>
	 <j2tac8f92701004031805s9b09d04csc5adf5199dc9b9a7@mail.gmail.com>
	 <20100404180845.GG18524@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@sun.com>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:39642 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754035Ab0DEDxu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 4 Apr 2010 23:53:50 -0400
Received: by gwb19 with SMTP id 19so1020602gwb.19
        for <linux-ext4@vger.kernel.org>; Sun, 04 Apr 2010 20:53:49 -0700 (PDT)
In-Reply-To: <20100404180845.GG18524@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2010/4/5, tytso@mit.edu <tytso@mit.edu>:
> On Sun, Apr 04, 2010 at 09:05:14AM +0800, jing zhang wrote:
>
> How much testing are you doing before submitting patches, out of
> curiosity?

Yes, Ted, it is curiosity that drives me to do hard works, including patch ext4.
I already told you that I am happy to patch ext4.
I also like to share/deliver my patches to the developers and
maintainers of ext4, simply because I find something not correct or
perfect in the version I got at kernel.org, and because I am not 100%
sure. And review is necessary, as described in Andi Kleen's "On
submitting kernel patches", which I read last night. And I got that on
cmdline,

           git --stat --summary  a/x.c  b/x.c  >  x-01.diff

may get nice output, correct?

It is hard work for me, a newbie, though curious, to do perfect patch,
and I try my best to describe the patch in English, which is not my
native language but one of the most beautiful languages on earth.

What is behind my curiosity is the belief that I will be freed both by
Jesus in West and by Buddha in East, today or tomorrow, if I deliver
what I can to those who need.

And after operations on cmdline, I compile the modified, modprobe, dd,
and rmmod with virtual machine. It is not hard.

> Having independent patches is actually better --- but I think you're
> misunderstanding what I was complaining about before.  Patches should

Whatever you complain, I try to be a good listener every time:)
GNU Linux is free, is MIT free?
And I am free to change, to be responsible for what I did, or maybe
freed by you.

> that are accepted into mainline should do one and only one thing.  So
> if someone suggests that you make changes to your submitted patch,
> ideally what you should do is to resubmit the patch with the fixes ---
> and not submit a patch which is a delta to the previous one.
>
> This is especially true if the original patch is buggy; one of the
> things we try very hard to maintain is that the kernel tree compile
> cleanly, and pass the regression test suite, between every single
> commit.  In other words, we try to avoid knowingly introducing a
> regression in a patch and fixing it in a subsequent patch.  This
> allows things like "git bisect" to work, and it also makes it easier
> for people to look at the commit history to understand why certain
> changes were made, and especially when trying to find how a bug was
> introduced into ext4.  Ultimately, this is about keeping the kernel
> source code easily maintainable.  This means that incrased code
> complexity has to be justified, and code and code changes have to be
> meticulously documented.

I think what is called ext4 will change, and more will be freed by the
change, since it is under your maintenance, at least currently, a
model of maintainer, especially of strict requirement and kind
patience to patches received.

Good weekend, and please review my new patches next week.

Thank you, Ted.

                       - zj
