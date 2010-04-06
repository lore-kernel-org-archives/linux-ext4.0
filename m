From: jing zhang <zj.barak@gmail.com>
Subject: Re: [PATCH] ext4: memory leakage in ext4_mb_init()
Date: Tue, 6 Apr 2010 21:43:58 +0800
Message-ID: <n2pac8f92701004060643q1702a1a4v8e8643cf35742559@mail.gmail.com>
References: <87sk7nv4sp.fsf@linux.vnet.ibm.com>
	 <20100403165340.GA17819@thunk.org>
	 <j2tac8f92701004031805s9b09d04csc5adf5199dc9b9a7@mail.gmail.com>
	 <20100404180845.GG18524@thunk.org>
	 <v2oac8f92701004042053p1738ece4u299dcb481b2fc3f2@mail.gmail.com>
	 <4BB966AE.1060207@redhat.com>
	 <t2pac8f92701004042151x3b0c27e2h805778b7b3aeefba@mail.gmail.com>
	 <4BB96E14.9010903@redhat.com>
	 <o2tac8f92701004042208l99c70297mf9955beacacd96bf@mail.gmail.com>
	 <20100405124223.GN18524@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Eric Sandeen <sandeen@redhat.com>,
	"Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@sun.com>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yw0-f172.google.com ([209.85.211.172]:49279 "EHLO
	mail-yw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755881Ab0DFNoB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 6 Apr 2010 09:44:01 -0400
Received: by ywh2 with SMTP id 2so3084346ywh.33
        for <linux-ext4@vger.kernel.org>; Tue, 06 Apr 2010 06:44:00 -0700 (PDT)
In-Reply-To: <20100405124223.GN18524@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2010/4/5, tytso@mit.edu <tytso@mit.edu>:
> On Mon, Apr 05, 2010 at 01:08:58PM +0800, jing zhang wrote:
>>
>> Before linux-2.6.32 is released, would you like tell me, how is ext4
>> tested?
>> Is tough testing able to catch all bugs?
>
> For one thing, we use the XFSQA (aka xfstests) test suite.  I usually
> run the "quick" set of tests between each commit, and I run a much
> longer "auto" test suite before submitting a set of patches to Linus.
>
> For specific patches, we also like to be able to test it specifically.
> So often we'll create a small filesystem image and then see what the
> file system does with and without the patch.  For example, if we're
> worried that a specific file system corruption will cause a BUG_ON,
> we'll create a small file system, corrupt it using the debugfs tool,
> and then demonstrate that without the patch, we get the BUG_ON.  With
> the patch applied, the BUG_ON should go away.
>
> So the patch-specific tests are there so we can make sure the patch
> does what we think it should, and it fixes the problem it claims to
> fix.  The XFSQA test suite is to there to make sure that we don't
> accidentally introduce bugs while trying to improve the file system.
>
> And of course, the final safeguard is patch review by others.  This is


First, Mr. Theodore Ts'o, your reply is a great honor to me.

And I learn more about ext4 and its maintainers and developers,
specially that testing is important to ext4. Thanks.

In my view, one of the important parts of a patch is that the patcher
is really concerning what is patched, another is whether the questions
listed in the patch do exist, and whether the solution, if provided by
the patcher, is correct.

Even if the provide solution is ok, I think, it is the privilege,
responsibility and duty of maintainers to execute the final
submitting, and therefore it is not the duty of patchers to make sure
that the solution is 100% correct and perfect, testing is good or not.

I like to be a maintainer of some subsystem of GNU Linux, since it is
my shame that end users experience panic, crash, bug, bug_on caused by
what is under my maintenance, that end users are treated as rats and
monkeys in laboratory even though I am not paid by any end user, and
the nice reputations of distributors, say red hat, of service
providers, say IBM.

To be a maintainer, I will apologize on my homepage once a patch
received, if the questions listed in the patch do exist, simply
because I abuse my duty and time.


> where decent comments and making sure the code is maintainable is
> critically important.  Since this takes other developer's time,
> especially senior developers like Eric and myself's time, which is

I still concern how to correctly measure the lost, in the next half of
2010, of time and value of end users, say 100, caused by what is buggy
in ext4. Are you sure no buggy, Eric and Ted?

> rather valuable and hard to find, it's why patch submitters need
> shoulder more of the work in terms of refining patches and
> resubmitting new versions of the patches.
>
> 						- Ted
>
> P.S.  Yes, Eric was absolutely correct.  I wanted to know how much

Do you like opera, Mr. Theodore Ts'o?

If you like, I invite you Beijing Opera and tea, and I pay the air
ticket, double trip, from Los Angeles to Beijing. And please info me
your time schedule if you accept my invitation.

> testing you had been doing on your patches before submitting them.  At
> least few of your patches have caused me to wonder whether the patches
> had gone through sufficient testing.
>

If end users of ext4 can not be treated, for any reason, as rats and
monkeys, lets go ahead, please, focusing upon patch.

           - zj
