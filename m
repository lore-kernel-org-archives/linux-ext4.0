From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Help to know the stable ver of ext4 for commercial app.
Date: Sun, 3 Feb 2013 17:52:56 -0500
Message-ID: <20130203225256.GA8582@thunk.org>
References: <BB7C62C2B0732E4DA93834A501E8464544E6181A@SZXEML519-MBS.china.huawei.com>
 <20130202032307.GA16364@thunk.org>
 <BB7C62C2B0732E4DA93834A501E8464544E62844@SZXEML519-MBS.china.huawei.com>
 <20130202224305.GA1359@thunk.org>
 <BB7C62C2B0732E4DA93834A501E8464544E628A6@SZXEML519-MBS.china.huawei.com>
 <CAEjEV8DaMO8ayPq+uOuuyDD+tXq=bmMoNs5SRMpNUFkWWyweeA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger@dilger.ca, Tao Ma <tm@tao.ma>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Li Zefan <lizefan@huawei.com>, linux-ext4@vger.kernel.org,
	wuqixuan <wuqixuan@huawei.com>
To: qixuan wu <wuqixuan@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:46813 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753841Ab3BCXKl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 3 Feb 2013 18:10:41 -0500
Content-Disposition: inline
In-Reply-To: <CAEjEV8DaMO8ayPq+uOuuyDD+tXq=bmMoNs5SRMpNUFkWWyweeA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 04, 2013 at 01:39:58AM +0800, qixuan wu wrote:
> 
> OK, I got. So generally feature maintainer submit patch to old stable
> branch maintainer, and they decide to patch ? Am I correct ?

That can happen, but what's much more common is that the subsystem
maintainer will tag a bug fix commits with:

    Cc: stable@vger.kernel.org

in the commit description.  This is a hint that a particular commit
should be grabbed by stable branch maintainers for consideration.

> Previously I did not realize that the patch backport also related with
> VFS/IO/mm layer. I also previously simply thought we can almost
> directly copying the 3.x ext4 to reply the folderin 2.6.34.x and
> compile without less compiling error. Just because of those incorrect
> thought, I simply thought most of patches can be backport easlily.
> Hi Ted, how much the proportion or how much of such case is there from
> your experience?

The vast majority of patches do _not_ backport trivially.  Of the ones
that don't just drop in, roughly a third are due to patch fuzz issues,
i.e., other one-line fixes, or spelling or whitespace fixups.  Another
third or so are relatively simple API changes (i.e., a new parameter
added to a function).  The last third are the ones where pretty major
changes have been made, and the patch may require a partial or
complete rewrite, or a back port of one or more (possibly a dozen) of
prerequisite patches, each of which might be a trivial backport, or
one which requires a moderate amount of work, or might require massive
amounts of work.

And the older the kernel, the harder it gets.  So it's one thing if
you're backporting to a 3.4 kernel, and it will get harder if you are
trying to backport to a 3.0 kernel, and by the time you need to
backport a lot of patches to 2.6.32, the proportion of trivial to
really hard patches starts to shifting more to the really hard.

> But this problem also indicate that the interface of common layer of
> kernel also continue to change more. I think that's not good thing.

Yes, the common layer is constantly changing.  This is considered a
good thing.  For a refutation of why you might think it's not a good
thing, I recommend that you read "stable_api_nonsense.txt" in the
Documentation directory of the Linux kernel sources.

> 4)  But the commercial distribution like RHEL or Windriver should have
> many internel backport and more stable.

They _may_ have internal backports.  It depends on how supported a
particular feature might be.  You need to ask them how much effort
they have put into backporting patches related to a particular
subsystem.  A particular embedded distributions (such as one used by
Montavista and/or Wind Rivier) might not have focused on ext4 if none
of their previous customers have required it.

One thing that you might consider is using a more modern kernel from
the Android git repositories.  The Android team makes a point of using
a fairly recent kernel each time they start a new development cycle;
so for example, Android 4.2 "Jelly Bean" uses a 3.4 kernel, and it
already has ARM chipset and device drivers used in the Nexus 4, 7, and
10.  More importantly, they've been updating it for various bug fixes,
and the Nexus devices use ext4, bug fixes for ext4 (at least which are
noticed by Android users) do get back ported.  (I've worked with the
Android kernel team folks in helping to identify ext4 bug fixes that
needed to be backported into Android kernel git trees from time to
time.)

> I know you also are difficult directly judge without app scenario. OK,
> if let you select in WR4.3, what's your intuition or suggestion, ext3
> or ext4? :)

No idea; you should be asking Wind River.

Either that, or perhaps Huawei should consider establishing a common
kernel team which supports a Linux kernel for all of its products.
(I've heard executives from Huawei talk about their commitment to
Linux at various Linux conferences, so it wouldn't surprise me if
there are kernel folks there already; it's just a matter of getting
them to work together to support all of your various product teams.)

> Another question, if I directly take from vanilla kernel for
> commercial use, at least from which version do you suggestion?

The 3.4 kernel is the most recent long-term supported stable kernel.
Combined with the fact that you can also consult with the kernel git
trees for Android Jelly Bean (version 4.2), it's a pretty compelling
choice.  Of course, it may be that you have a requirement for some
proprietary device driver which is holding you back to an ancient
2.6.34 kernel.  If that's the case, you might want to consider doing
what many experienced product teams have done, which is to simply
demand that your parts manufacturers supply device drivers that are
integated into the upstream kernel --- and if they aren't willing to
do that, that you'll chose some other parts provider.  This is
something IBM and Dell have done for enterprise servers, and it's also
something which manufacuters for consumer electronics products have
started doing.  In the long term, it's a really bad idea to get stuck
back at 2.6.34 vintage kernels.  This is why the Android team make a
point of rebasing to a new upstream kernel at each new development
cycle (i.e., when they went from Honeycomb, to Ice Cream Sandwich, to
Jelly Bean, etc.)

Regards,

						- Ted
