From: jing zhang <zj.barak@gmail.com>
Subject: Re: [PATCH] ext4: memory leakage in ext4_mb_init()
Date: Sun, 4 Apr 2010 09:05:14 +0800
Message-ID: <j2tac8f92701004031805s9b09d04csc5adf5199dc9b9a7@mail.gmail.com>
References: <ac8f92701003210701j5926f2c4v843e36bc602a0444@mail.gmail.com>
	 <20100322012758.GE11560@thunk.org>
	 <ac8f92701003230547p3e56a9cdnff8ce874535db117@mail.gmail.com>
	 <87sk7nv4sp.fsf@linux.vnet.ibm.com>
	 <x2vac8f92701003280113k2458fcb6mefe6c04875c9b3a3@mail.gmail.com>
	 <20100403165340.GA17819@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@sun.com>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yx0-f191.google.com ([209.85.210.191]:40869 "EHLO
	mail-yx0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754659Ab0DDBFP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 3 Apr 2010 21:05:15 -0400
Received: by yxe29 with SMTP id 29so1569832yxe.4
        for <linux-ext4@vger.kernel.org>; Sat, 03 Apr 2010 18:05:14 -0700 (PDT)
In-Reply-To: <20100403165340.GA17819@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2010/4/4, tytso@mit.edu <tytso@mit.edu>:
> Hi Jing,
>
> If you're wondering why I'm taking a long time to respond to your
> patches, it is because they are very ill-formed.  They don't conform
> to the submitting patches guidelines, the patch comments don't
> adequately explain the why the patch is needed, and what testing has
> been done, and you tend to throw in patches that aren't correctly
> submitted in the middle of comments, and in some cases it's not clear
> whether this patch is suppose to be in addition to the previous patch,
> and combined into a separate commit, or kept as two separate patches,
> etc.
>

Sorry again, Ted.

There are so much for a newbie to learn to do cool work, especially to
meet your requirements. I am happy, any way, to patch ext4 under your
direction.

> As a result, it takes, much, MUCH, MUCH longer for me to review the
> patches for correctness.  I will eventually get to them, but I may end
> up working on other patches which are better formed and easier for me
> to evaluate for correctness and quality.
>
> If you do submit new patches, especially in this thread where you have
> already submitted so many different patches, I would appreicate it if
> you could explicitly state that a particular patch has been superceded

Without the cool git, though I am learning how to take advantage of
it, I could not manage all the patches delivered. In fact, I dig the
patches with UltraEdit for modifying the C code, Cygwin for git and
diff -Npu, and virtual machine for compiling. My kid, 11 years old
boy, has to share the HP notebook with me playing games.

And please laugh at me, I am not living in stone age.

I resolve conflicts and dependencies between patches in the way that
they are carried out by independent guys, since I am told that git is
cool enough. But indeed I created so many hard work for you, sorry.

Is it possible for me to patch not based upon the stock version I
downloaded at kernel.org, but upon the patched version, say the latest
git tree?


> by another, or has been withdrawn.  I will try to keep score on the
> patchwork web site (for example, I rejected your bb_free_cache patch),
> but you've been so prolific with patches, some of which haven't been
> very well explained, that I may have lost track of all of your
> submissions.
>
> Please bear with me.

No problem. I like ext4, maybe still the native file system of GNU
Linux, and the cool guys such as Alen Cox, Andy Clin, Ingo Molnar,
Rusty Russell, Jens Axboe, Alexey N. Kuznetsov (where r u now, ANK?),
Mike Haertel, Avi Kivity, Ted, Reiser, and their cool works which help
many newbies to understand Linux, to apply the cool ideas and methods
they learned in Linux to their everyday work, to earn bread and salt
in this hard time.

One of the amazing cools of Linux, I believe, besides free, is to
change ideas and lives of individuals, and to change what should be
changed in the society in which individuals live.

I am being changed to do patch in appreciated way.

Thanks
               - zj

>
> Best regards,
>
> 					- Ted
