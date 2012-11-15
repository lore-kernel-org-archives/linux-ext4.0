From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [PATCH] ext4: check incompatible mount options when mounting
 ext2/3
Date: Thu, 15 Nov 2012 15:03:56 -0500
Message-ID: <50A54AAC.8050100@redhat.com>
References: <1351798331-14456-1-git-send-email-cmaiolino@redhat.com> <20121108170202.GB19977@thunk.org> <50A023B9.4020609@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21044 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423636Ab2KOUD7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 Nov 2012 15:03:59 -0500
In-Reply-To: <50A023B9.4020609@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 11/11/2012 05:16 PM, Eric Sandeen wrote:
> On 11/8/12 11:02 AM, Theodore Ts'o wrote:
>> On Thu, Nov 01, 2012 at 05:32:11PM -0200, Carlos Maiolino wrote:
>>> I have not added all mount options I believe need to raise a
>>> warning, just those with a flag set on superblock, but I expect to
>>> generate a discussion here about which mount options should be
>>> warned and get suggestions about how to deal with argumented options
>>> (ex: commit= opt), to be included in a V2 of this patch.
>> Let's take a step back, and see if we can be explicit about why it
>> would be useful to warn when a user uses mount options that we were
>> not present with the implementation of the file system drivers found
>> in fs/ext2 and fs/ext3.  While we're at it, we can also examine the
>> same question with respect to file system features --- i.e., if
>> someone mounts a file system with an extent feature enabled using
>> mount -t ext2, what if anything should we do.  What are we trying to
>> achieve, or conversely what are we trying to prevent?
>>
>> Suppose the user does something like this:
>>
>>     mount -t ext3 -o delalloc /dev/sdb /u1
>>
>> Yes, the traditional ext3 driver code doesn't understand the delalloc
>> mount option, but what's the concern that is leading us to want to
>> print a warning message to the log (that the user may or may not even
>> see).  Are we worried that what should happen is not sufficiently
>> well-defined?  Are we worried that while it might work with a
>> particular kernel which is compiled a certain way, it might not work
>> with another kernel?  Is it part of the larger question of wanting to
>> warn if the user is using a set of not-well-tested combination of
>> mount options and/or file system features?
>>
>> If it is the latter, what is the right approach?  At Barcelona, I was
>> chatting with Ric Wheeler and Ralf Flaxa, and they had differing
>> opinions about what the right thing to do for features which are not
>> supported.  Ralf felt that warning in the syslog might be sufficient.
>> I sugested setting a new kernel taint flag, to make it easier for the
>> supper desk to twig to the fact that the user was doing something
>> unusual.  Ric offerred his opinion that it was better to hard-fail the
>> mount.  And of course, this is with distro kernels; for the upstream
>> kernel, I think our goal is to (a) warn the user that they are doing
>> something unusual, and (b) ask them to tell us (at linux-ext4) what
>> they are doing and why, so we have a better understanding of what
>> users want, so we can either add it to our test matrix, or perhaps
>> warn the user off.
> The overarching reason is to cut down the test matrix if possible, I think.
> This has advantages for both distros & upstream, and might even lead
> to code simplification if we can exclude some corner-case behaviors.

This is my key goal - make sure that we get tested and sane mount options out to 
the users.  And we normally only test a handful of things, certainly it is not 
reasonable to test all combinations of things you could do.

>
> But the other question that might need answering is this:
>
> If a user has asked ext4.ko to mount an ext3 device, should it behave
> as closely as possible to what the ext3.ko driver used to do?  And I'd
> say yes.  Therefore things like -t ext3 -o delalloc should be hard-failed.
>
> If you really want your old ext3 filesystem to be mounted with delalloc,
> then I think the right way would be to use mount -t ext4 /dev/ext3-dev.
> Then you get the runtime behaviors such as delalloc, and ext4 should
> not write anything which is not ext3-compatible.
>
> Perhaps we need to go through in fine detail, but I think mount -t
> ext3 should reject any options not applicable to ext3.ko.  If you want
> the newer ext4 behaviors, then use mount -t ext4.

I agree with that. At some point, that is probably what the user actually meant 
(just did not know it at the time :)).

>
>> So not only do we need to decide which mount options and file system
>> features we want to support, or warn against etc., it's also useful to
>> think about what we want to do when the user does something a little
>> out of the norm.
>>
>> And since I very much doubt that upstream, Red Hat, SuSE, Canonical,
>> etc., will ever agree on the right thing is, this is probably one of
>> those things where we want to have a scheme where it is relatively
>> easy for distributors to set their own policy, which may differ for a
>> community versus enterprise distro kernel.
> Perhaps, but a well-thought-out rationale for what combinations make
> sense might just fly everywhere.
>
> A complex scheme of configuration policy sounds like potentially another
> layer of knobs on an already vast layer of knobs.  ;)
>
> (That said, distros may well want to just nuke things like data=writeback
> from orbit)
>
> (And that said, I'm of the opinion that upstream should too ;))
>
> Anyway, back to my main point:  As a guiding principle I think I would
> say that mount -t ext3 with ext4.ko should hard-reject any option not
> understood by ext3.ko.  It's clear and predictable, and should make for
> a decent first cut.
>
> -Eric

Agreed (sounds almost like we had coordinated our answers before I spoke to Ted 
in Barcelona!).

Ric

>
>> But in order to make sure we don't end up talking past each other, I
>> think it's useful to be very explicit about why we want to do this,
>> before we try to figure what's and the how's.
>>
>>

