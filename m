From: jing zhang <zj.barak@gmail.com>
Subject: Re: [PATCH] ext4: memory leakage in ext4_mb_init()
Date: Thu, 8 Apr 2010 00:34:12 +0800
Message-ID: <i2zac8f92701004070934qb74eef2ak4bd7455f4573f50a@mail.gmail.com>
References: <20100403165340.GA17819@thunk.org>
	 <20100404180845.GG18524@thunk.org>
	 <v2oac8f92701004042053p1738ece4u299dcb481b2fc3f2@mail.gmail.com>
	 <4BB966AE.1060207@redhat.com>
	 <t2pac8f92701004042151x3b0c27e2h805778b7b3aeefba@mail.gmail.com>
	 <4BB96E14.9010903@redhat.com>
	 <o2tac8f92701004042208l99c70297mf9955beacacd96bf@mail.gmail.com>
	 <20100405124223.GN18524@thunk.org>
	 <n2pac8f92701004060643q1702a1a4v8e8643cf35742559@mail.gmail.com>
	 <20100406142103.GI23670@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Eric Sandeen <sandeen@redhat.com>,
	"Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@sun.com>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: tytso@mit.edu, torvalds@linux-foundation.org, mingo@redhat.com,
	gregkh@suse.de, axboe@kernel.dk, ralf@linux-mips.org,
	health-science@washpost.com,
	linux-kernel <linux-kernel@vger.kern
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yx0-f171.google.com ([209.85.210.171]:43030 "EHLO
	mail-yx0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932723Ab0DGQeP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 7 Apr 2010 12:34:15 -0400
In-Reply-To: <20100406142103.GI23670@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2010/4/6, tytso@mit.edu <tytso@mit.edu>:
> On Tue, Apr 06, 2010 at 09:43:58PM +0800, jing zhang wrote:
>>
>> In my view, one of the important parts of a patch is that the patcher
>> is really concerning what is patched, another is whether the questions
>> listed in the patch do exist, and whether the solution, if provided by
>> the patcher, is correct.
>>
>> Even if the provide solution is ok, I think, it is the privilege,
>> responsibility and duty of maintainers to execute the final
>> submitting, and therefore it is not the duty of patchers to make sure
>> that the solution is 100% correct and perfect, testing is good or not.
>
> Well, the problem is there are many more patch submitters than there
> are maintainers, and so your proposal simply doesn't scale.  Consider
> that for some maintainers, there may be 10 or 20 or 30 or more patch
> submitters in their subsystem.  With that kind of
> submitter-to-maintainer ratio, the patch submitter simply has to do
> much more of the work, since otherwise the subsystem maintainer simply
> can't keep up.
>

If you are not able to deal with all patches received, the simple way
seems that you should share your burden with those maintainers who
like.

> Most maintainers actually spend much less time dealing with patch
> submitters than I have invested with you.  They simply send a NACK,
> and maybe 2-3 sentences explaning of what still needs fixing, and then
> it's up to the patch submitter to resubmit the patch.  Some patches
> are resubmitted 5, 6 times before the maintainer finally accepts it.

This seems one of the cool reasons that some subsystem, say in stable
stock kernel, is buggy, and end users have to face panic.

>
> I happen to believe that we need to encourage newcomers to the kernel
> developer community, and so I spend more time mentoring people who are
> new to the process.  But at the end of the day, I have only so many
> hours that I can spend on newcomers, and so after a while, I will
> start serving other patch submitters who are more capable of providing
> patches that are easy to review and integrate.
>

Newcomers, I think, are the cool gifts sent by Jesus and Buddha to
what is called GUN Linux, and the accepted patches do not remove the
buggy in the unaccepted patches, if the buggy does exist.

>> I like to be a maintainer of some subsystem of GNU Linux, since it is
>> my shame that end users experience panic, crash, bug, bug_on caused by
>> what is under my maintenance, that end users are treated as rats and
>> monkeys in laboratory even though I am not paid by any end user, and
>> the nice reputations of distributors, say red hat, of service
>> providers, say IBM.
>
> Sure, but that means the patches which are submitted has to be high
> quality.  If I get half-tested patches, or patches where you can't
> give me a reproduction case that demonstrates the BUG_ON, and it's not

The first action on the received patch to what is under my maintenance
is to check whether there is really buggy. If yes, I apologize to the
patcher as soon as possible. Second the correctness of the solution,
if provided in patch, is checked as tough as I can, simply because
that no case of reproduction can not tell me it is not buggy. Third it
is my duty to be responsible for the stability of the subsystem in
what is called stable stock kernel, with little to do with the safety
of any patch, and I would share my ideas with the original patcher.

> obvious whether or not the patch is safe, I have to worry about the
> possibility that applying your patch may make the the file system more
> likely to crash, not less.
>
> Ext4 is actually quite stable at this point.  Very large numbers of

How stable is it? Would you like to show which version of ext4 is free of buggy?

> people are using it, and most users are quite happy.  So at this

Is happy meaning ext4 is free of buggy?

> point, I have to weigh the risk that a patch might introduce a bug
> against the claim that it fixes the bug --- especially if the patch

It seems the day to day duty to review patches for any maintainer, but
I am not sure.

> submitter can't explain how the BUG_ON might have been triggered
> without their patch, and can't explain to me how much testing he or
> she has done before sumitting the patch to me.

I do not think his/her testing can ensure the safety of the patch, but
review is necessary.

>
> As far as your concern about end users getting treated as "rats and
> monkeys", they are certainly getting paid; they get to use very high
> quality software for free!  The tradeoff is that they won't get as

End users do get privilege for free from GNU, other than to be treated
as rats and monkeys for any reason, I think.

If you like to provide free ext4 as stable, first above all, you
should be sure it is free of buggy, or at least you have to info end
users, as much as you can, how buggy it is.

In other words, if you like to provide free bread, and claim the bread
is safe, you must ensure the bread is free of poison, or you have to
info, as much as you can, those who take your bread that the bread is
not  free of poison, how danger the bread is.

Is it murder with no info at all?

> much support compared to someone who is a paying customer of Red Hat
> or IBM.  For the right customer, when I worked at IBM, I would fly on
> site to a bank in New York City and fix their bug.  And I'm sure it's
> the same for Eric, if someone has a critical bug and they are a big
> Red Hat customer.  Those who pay our salaries, get the best support.

Those right customers seems pay too much for what is unnecessary, and
IBM is lucky enough, unlike Toyota. Indeed I first hear that, a cool
story:)  I would share it with my friends. Thanks.

> End users who aren't paying support to a big Linux company still get
> support, but it won't be as good, and that's just life.  End users who

So these end users who aren't paying do get treated as rats and monkeys by you?

> want to use the latest code, are in fact guinea pigs.  If they don't

No, no and no, in any way, end users are not pigs in Guinea but users
of GNU Linux, I believe. Jesus and Buddha, please, rescue me.

> want to guinea pigs, they can use Fedora kernels or OpenSuSE kernels.
>
>> > where decent comments and making sure the code is maintainable is
>> > critically important.  Since this takes other developer's time,
>> > especially senior developers like Eric and myself's time, which is
>>
>> I still concern how to correctly measure the lost, in the next half of
>> 2010, of time and value of end users, say 100, caused by what is buggy
>> in ext4. Are you sure no buggy, Eric and Ted?
>
> There is no such thing as code which is not buggy.  For any
> non-trivial program, it's almost certain there are bugs.  The only

So it is clear ext4 is not free of buggy but in stable linux-2.6.32.

> question is how easy it is for the someone to trigger the bugs, and
> what are the consequences if the bugs get triggered.  During ext4
> development, we've found bugs that were around in for over a decade in
> ext3, but it was simply something that no one had ever tripped over.

And you achieved a lot, but I think ext4 is another ext3.

> (It required a certain race condition getting hit, plus a power
> failure or other unclean shutdown very shortly after the race
> condition, and it was simply something which no one had ever noticed,
> or if they did trip over it, they assumed it was caused by a hardware
> problem.)
>
> Ext4 is not exempt from these fundamental laws of software
> engienering.  "Code is always buggy until the last user of the program
> dies".

Nobody want to die, it is a life not so hard.

>
> As far as the time value of users, remember that people who get free
> code, get what they pay for.  We all have our salaries paid by

GNU is free, Linux is also free, it sounds cool, for any user at least today.

> someone, and at the end of the day, our priorities are driven by our
> employers.  So I will track down a bug report from an end user because
> (a) that bug might affect the machines that I am paid to support, and
> (b) a larger ext4 user base is good for the community in general, and
> there are secondary benefits to my employer that accrue from that, and
> (c) Google is just a great company.  :-)
>
> (As is Red Hat, SuSE, Oracle, etc. :-)
>
> But please don't get fooled that the resources we have to work on
> problems from end users, or time that I can spend mentoring newcomers
> to the kernel developer community, is infinite.  Because it isn't.
> I'll spend some of my own time, and work late at nights, to help end
> users who are getting linux "for free", especially if they run into
> problems with ext4, because I like to help users as much as I can.

Nice words. And How about those users in Guinea?

> And I will help out newcomers like you because it's personally
> important to me.  But I do need to sleep, and I do have other
> priorities, like family and friends.  And at the end of the day,
> because I like food with my meals, the needs of my $DAYJOB, are going
> to get priority, at least during work hours.
>
> Finally, keep in mind that the maxim that code which is not buggy also
> applies to your patches.  At least some of your patches are definitely
> buggy, and which brings us back to the question whether things will be

My buggy is still not in the stable kernel, right?

> made better or worse if we were to apply all of your patches.  And in
> the meantime, there are patches from other patch submitters which are
> proven themselves to be much more likely to be correct, and easier to
> review and integrate.
>
> If you were a maintainer, faced with limited time and resources, and

My mind is changed, I should not be a maintainer like you who are
treating users differently.

> someone who floods you with a large number of patches that take extra
> time to review and comprehend, and that person refuses to help you
> make life easier by reworking their patches so that they are easier to
> review and comprehend, what would _you_ do?

My answer is simple, I would apologize to all patchers first.

good night
               - zj

>
> Best regards,
>
> 						- Ted
>
