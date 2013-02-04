From: qixuan wu <wuqixuan@gmail.com>
Subject: Re: Help to know the stable ver of ext4 for commercial app.
Date: Tue, 5 Feb 2013 01:53:29 +0800
Message-ID: <CAEjEV8CgGd2C_5ZiLaTcR+jj+vOFy_vQjbrpBeeKW=m8bM_p2A@mail.gmail.com>
References: <BB7C62C2B0732E4DA93834A501E8464544E6181A@SZXEML519-MBS.china.huawei.com>
	<20130202032307.GA16364@thunk.org>
	<BB7C62C2B0732E4DA93834A501E8464544E62844@SZXEML519-MBS.china.huawei.com>
	<20130202224305.GA1359@thunk.org>
	<BB7C62C2B0732E4DA93834A501E8464544E628A6@SZXEML519-MBS.china.huawei.com>
	<CAEjEV8DaMO8ayPq+uOuuyDD+tXq=bmMoNs5SRMpNUFkWWyweeA@mail.gmail.com>
	<20130203225256.GA8582@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: adilger@dilger.ca, Tao Ma <tm@tao.ma>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Li Zefan <lizefan@huawei.com>, linux-ext4@vger.kernel.org,
	wuqixuan <wuqixuan@huawei.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ie0-f173.google.com ([209.85.223.173]:50417 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420Ab3BDRxa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Feb 2013 12:53:30 -0500
Received: by mail-ie0-f173.google.com with SMTP id 9so6077900iec.32
        for <linux-ext4@vger.kernel.org>; Mon, 04 Feb 2013 09:53:29 -0800 (PST)
In-Reply-To: <20130203225256.GA8582@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 4, 2013 at 6:52 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Mon, Feb 04, 2013 at 01:39:58AM +0800, qixuan wu wrote:
>>
>> OK, I got. So generally feature maintainer submit patch to old stable
>> branch maintainer, and they decide to patch ? Am I correct ?
>
> That can happen, but what's much more common is that the subsystem
> maintainer will tag a bug fix commits with:
>
>     Cc: stable@vger.kernel.org
>
> in the commit description.  This is a hint that a particular commit
> should be grabbed by stable branch maintainers for consideration.

Totally clear. It's a better way to save subsystem maintainer's time. :)

>> Previously I did not realize that the patch backport also related with
>> VFS/IO/mm layer. I also previously simply thought we can almost
>> directly copying the 3.x ext4 to reply the folderin 2.6.34.x and
>> compile without less compiling error. Just because of those incorrect
>> thought, I simply thought most of patches can be backport easlily.
>> Hi Ted, how much the proportion or how much of such case is there from
>> your experience?
>
> The vast majority of patches do _not_ backport trivially.  Of the ones
> that don't just drop in, roughly a third are due to patch fuzz issues,
> i.e., other one-line fixes, or spelling or whitespace fixups.  Another
> third or so are relatively simple API changes (i.e., a new parameter
> added to a function).  The last third are the ones where pretty major
> changes have been made, and the patch may require a partial or
> complete rewrite, or a back port of one or more (possibly a dozen) of
> prerequisite patches, each of which might be a trivial backport, or
> one which requires a moderate amount of work, or might require massive
> amounts of work.
>
> And the older the kernel, the harder it gets.  So it's one thing if
> you're backporting to a 3.4 kernel, and it will get harder if you are
> trying to backport to a 3.0 kernel, and by the time you need to
> backport a lot of patches to 2.6.32, the proportion of trivial to
> really hard patches starts to shifting more to the really hard.

Seem one third patches backport are difficult. That means the ancient
kernel ext4 is very unstable.

>> But this problem also indicate that the interface of common layer of
>> kernel also continue to change more. I think that's not good thing.
>
> Yes, the common layer is constantly changing.  This is considered a
> good thing.  For a refutation of why you might think it's not a good
> thing, I recommend that you read "stable_api_nonsense.txt" in the
> Documentation directory of the Linux kernel sources.

Implementation of common layer changes constantly is not a problem.
But for interface's constantly change, it stands for design is not
good. If interface change less, then I can directly backport the whole
3.8 ext4 and modify less into my ancient 2.6.34.x kernel. But first I
will study "stable_api_nonsense.txt", maybe I am wrong. :)

>> 4)  But the commercial distribution like RHEL or Windriver should have
>> many internel backport and more stable.
>
> They _may_ have internal backports.  It depends on how supported a
> particular feature might be.  You need to ask them how much effort
> they have put into backporting patches related to a particular
> subsystem.  A particular embedded distributions (such as one used by
> Montavista and/or Wind Rivier) might not have focused on ext4 if none
> of their previous customers have required it.

Yes you are right, maybe for embedded distributions might not have
focused on ext4. If there are huge difference between ext4 of WR4.3
with Android 4.2 "Jelly Bean" kernel. Then maybe we will choose ext3.

> One thing that you might consider is using a more modern kernel from
> the Android git repositories.  The Android team makes a point of using
> a fairly recent kernel each time they start a new development cycle;
> so for example, Android 4.2 "Jelly Bean" uses a 3.4 kernel, and it
> already has ARM chipset and device drivers used in the Nexus 4, 7, and
> 10.  More importantly, they've been updating it for various bug fixes,
> and the Nexus devices use ext4, bug fixes for ext4 (at least which are
> noticed by Android users) do get back ported.  (I've worked with the
> Android kernel team folks in helping to identify ext4 bug fixes that
> needed to be backported into Android kernel git trees from time to
> time.)

Good news. I will compare WR4.3 ext4 with Android 4.2 "Jelly Bean"
kernel in Google's git repositories. But directly use may be
difficult, because of the difference of the ancient kernel and modern
module. So also it indicate that all the patches are not in 3.4
vanilla kernel, otherwise no need backport. Seems 3.4 vanilla kernel
is missing many bugfixes. Am I correct?

>> I know you also are difficult directly judge without app scenario. OK,
>> if let you select in WR4.3, what's your intuition or suggestion, ext3
>> or ext4? :)
>
> No idea; you should be asking Wind River.
>
> Either that, or perhaps Huawei should consider establishing a common
> kernel team which supports a Linux kernel for all of its products.
> (I've heard executives from Huawei talk about their commitment to
> Linux at various Linux conferences, so it wouldn't surprise me if
> there are kernel folks there already; it's just a matter of getting
> them to work together to support all of your various product teams.)

The common kernel absolutely will be based on the higher version newer
than 3.x after 1-2 years. But currently customer is urgently want to
release product to end-customer. If it's not stable, many people will
go the same way of Google/Redhat. That's a mire. But if ext4 is stable
on 2.6.34.x, later we just only need support one filesytem (ext4) in
current release and later common kernel. Otherwise, we need support
ext3(current release) and ext4(common kernel) for duplicating study
effort.

>> Another question, if I directly take from vanilla kernel for
>> commercial use, at least from which version do you suggestion?
>
> The 3.4 kernel is the most recent long-term supported stable kernel.
> Combined with the fact that you can also consult with the kernel git
> trees for Android Jelly Bean (version 4.2), it's a pretty compelling
> choice.  Of course, it may be that you have a requirement for some
> proprietary device driver which is holding you back to an ancient
> 2.6.34 kernel.  If that's the case, you might want to consider doing
> what many experienced product teams have done, which is to simply
> demand that your parts manufacturers supply device drivers that are
> integated into the upstream kernel --- and if they aren't willing to
> do that, that you'll chose some other parts provider.  This is
> something IBM and Dell have done for enterprise servers, and it's also
> something which manufacuters for consumer electronics products have
> started doing.  In the long term, it's a really bad idea to get stuck
> back at 2.6.34 vintage kernels.  This is why the Android team make a
> point of rebasing to a new upstream kernel at each new development
> cycle (i.e., when they went from Honeycomb, to Ice Cream Sandwich, to
> Jelly Bean, etc.)

I think google's strategy is correct, and common kernel will use the
same mode I think later. But before having the common kernel, we still
have to get stuck at one commercial Linux. This is the current policy
from executives, and not because of some perticular device driver.

Best Regards.
Wood.
