From: tytso@mit.edu
Subject: Re: [PATCH] ext4: memory leakage in ext4_mb_init()
Date: Sun, 4 Apr 2010 14:08:45 -0400
Message-ID: <20100404180845.GG18524@thunk.org>
References: <ac8f92701003210701j5926f2c4v843e36bc602a0444@mail.gmail.com>
 <20100322012758.GE11560@thunk.org>
 <ac8f92701003230547p3e56a9cdnff8ce874535db117@mail.gmail.com>
 <87sk7nv4sp.fsf@linux.vnet.ibm.com>
 <x2vac8f92701003280113k2458fcb6mefe6c04875c9b3a3@mail.gmail.com>
 <20100403165340.GA17819@thunk.org>
 <j2tac8f92701004031805s9b09d04csc5adf5199dc9b9a7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@sun.com>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: jing zhang <zj.barak@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:44344 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753006Ab0DDSIs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 4 Apr 2010 14:08:48 -0400
Content-Disposition: inline
In-Reply-To: <j2tac8f92701004031805s9b09d04csc5adf5199dc9b9a7@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Apr 04, 2010 at 09:05:14AM +0800, jing zhang wrote:
> 
> Without the cool git, though I am learning how to take advantage of
> it, I could not manage all the patches delivered. In fact, I dig the
> patches with UltraEdit for modifying the C code, Cygwin for git and
> diff -Npu, and virtual machine for compiling. My kid, 11 years old
> boy, has to share the HP notebook with me playing games.

How much testing are you doing before submitting patches, out of
curiosity?

> I resolve conflicts and dependencies between patches in the way that
> they are carried out by independent guys, since I am told that git is
> cool enough. But indeed I created so many hard work for you, sorry.

Having independent patches is actually better --- but I think you're
misunderstanding what I was complaining about before.  Patches should
that are accepted into mainline should do one and only one thing.  So
if someone suggests that you make changes to your submitted patch,
ideally what you should do is to resubmit the patch with the fixes ---
and not submit a patch which is a delta to the previous one.

This is especially true if the original patch is buggy; one of the
things we try very hard to maintain is that the kernel tree compile
cleanly, and pass the regression test suite, between every single
commit.  In other words, we try to avoid knowingly introducing a
regression in a patch and fixing it in a subsequent patch.  This
allows things like "git bisect" to work, and it also makes it easier
for people to look at the commit history to understand why certain
changes were made, and especially when trying to find how a bug was
introduced into ext4.  Ultimately, this is about keeping the kernel
source code easily maintainable.  This means that incrased code
complexity has to be justified, and code and code changes have to be
meticulously documented.

Best regards,

					- Ted
