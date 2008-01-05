From: "Paolo Ciarrocchi" <paolo.ciarrocchi@gmail.com>
Subject: Re: [PATCH] [Coding Style]: misc fixes for fs/ext{3,4}/acl.{c,h} from checkpatch.pl
Date: Sat, 5 Jan 2008 01:12:44 +0100
Message-ID: <4d8e3fd30801041612k2b4aaab1yee2be5eec03e9f07@mail.gmail.com>
References: <1199452896-20145-1-git-send-email-mathieu.segaud@regala.cx>
	 <20080104134458.GE17436@mit.edu> <p73hcht8sfr.fsf@bingen.suse.de>
	 <20080104190137.GJ17436@mit.edu>
	 <20080104194129.GA16962@one.firstfloor.org>
	 <4d8e3fd30801041203s2f017f20ld9fcbc82912468fe@mail.gmail.com>
	 <20080104223328.GB19248@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Theodore Tso" <tytso@mit.edu>,
	"Mathieu Segaud" <mathieu.segaud@regala.cx>,
	akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: "Andi Kleen" <andi@firstfloor.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.182]:44218 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753933AbYAEAMs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Jan 2008 19:12:48 -0500
Received: by wa-out-1112.google.com with SMTP id v27so10771892wah.23
        for <linux-ext4@vger.kernel.org>; Fri, 04 Jan 2008 16:12:45 -0800 (PST)
In-Reply-To: <20080104223328.GB19248@one.firstfloor.org>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jan 4, 2008 11:33 PM, Andi Kleen <andi@firstfloor.org> wrote:
[...]
> > I think that _one_ of the reasons that made a few people sent this kind of
> > patches to the list is because checkpatch.pl is far better then any other
> >  kerneljanitor scripts/easy task and _seems_ to be an easy way to start
> > understanding the code, creation of patches and process in general.
>
> The problem is that it has large hidden costs as pointed out. So while
> it might be easy for you it's not a cheap operation for the whole development
> process.

Isn't it a timing problem?
I mean, I guess that codying style fixes are OK if there is a good coordination
with the maintainer and patches are sent with the right timing in
order to not cause
problems in the process.
Do you agree?

May be, similar as you suggested, next time people should ask on the list
and fixing the codying style issues on the files suggested by the relevant
maintainers?

[...]
>
> How about if you're looking for simple work for a few hours you just
> send an email to l-k and ask if someone has an idea for something?
> I'm sure you'll get suggestions. Probably more than you can take.
>
> e.g. from the top of my hat what would be useful:
>
> - Go through Documentation/* files and check if the options etc. described
> in there are still in the code
>
> That will actually require you to find code in the source tree and understand
> it at least a little bit which are both very useful skills in general.
>
> - Or check for kerneldoc comments that do not appear in the kerneldoc output
> (because the files are missing in the DocBook templates)
>
> - Or build the kernel and check for any "deprecated" warnings and fix them
> [perhaps not 100% trivial, but should be doable by studying other code
> a bit -- i expect that people who attempt to write such patches have at least
> some knowledge of programming and C so that should be possible]

OK, thanks for the hints!

> > I mean, I now understand the rationales behind your complaints but I
> > don't think it's
> >  good idea to discourage people willing to perform easy task.
> > They just need guidance in order to be useful.
>
> Yes, the best way to get guidance is to ask.

Ciao,
-- 
Paolo
http://paolo.ciarrocchi.googlepages.com/
