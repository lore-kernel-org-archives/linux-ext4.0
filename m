From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [2.6 patch] fs/jbd/journal.c: cleanups
Date: Mon, 18 Feb 2008 17:22:26 +0100
Message-ID: <20080218162226.GB4148@elte.hu>
References: <20080217081935.GN3848@cs181133002.pp.htv.fi> <20080218070439.GG3029@webber.adilger.int> <20080218071229.GA1459@elte.hu> <20080218114936.GM8905@mit.edu> <20080218131209.GB21080@cs181133002.pp.htv.fi> <20080218133140.GA21635@elte.hu> <20080218151119.GC25098@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Tso <tytso@mit.edu>, Adrian Bunk <bunk@kernel.org>,
	Andreas Dilger <adilger@sun.com>, sct@redhat.com,
	akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx3.mail.elte.hu ([157.181.1.138]:35236 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751650AbYBRQXS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 18 Feb 2008 11:23:18 -0500
Content-Disposition: inline
In-Reply-To: <20080218151119.GC25098@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


* Theodore Tso <tytso@mit.edu> wrote:

> On Mon, Feb 18, 2008 at 02:31:40PM +0100, Ingo Molnar wrote:
> > i guess this explains what static code metrics already suggest:
> 
> Am I right in assuming that code-quality is just a program which runs 
> checkpatch.pl and measures the number of warnings and calls them 
> errors?

no, it picks the checkpatch.pl errors and calls them errors. The script 
ignores checkpatch.pl warnings. (although even the checkpatch.pl 
warnings tend to be correct in like 90% of the cases - YMMV)

but yes, i'd agree with you if you said this was an arbitrary metric 
that does not map to the functional qualities of the code in a provable 
way.

(other than the fact that any of these style errors are valid reasons to 
reject new code that is being offered into the kernel. I.e. if the ext4 
codebase was submitted as a new, unknown filesystem right now, it would 
probably have a hard time getting accepted with all those silly style 
problems in it. Why should "old" subsystems have a lower threshold to 
meet than newer subsystems? Isnt that unfair? )

And fact is that i've yet to see really crappy code with an excellent 
checkpatch score, and really good code with a very poor checkpatch 
score. So i think you have to accept that there's _some_ correlation.

And i believe this comes from the simple fact that mental carelessness 
is contagious: lack of attention to details on the thinking level 
subsconsciously slips over into the style space as well. It's hard 
(impossible) to measure "true" code quality, but the style space is 
interrelated with the "true quality" space and is easier to measure. I 
just had a look at the errors and warnings that checkpatch --file emits 
on fs/ext3/*.c, and if i was maintaining those files i'd be fixing over 
50% of them - because they are just style inconsistencies often _within 
the same function_ which would be constant distraction when adding new 
code.

In fact, the more critical a piece of code, the more strategic it is to 
users, the less acceptable it is IMO to have "style noise" and similar 
visual distractions in it. One unusual indentation or spacing, although 
silly to even mention in isolation, _can_ trick the human eye into 
glossing over just one critical piece of information to find or avoid a 
bug. And as a bonus, consistent source code style is also an attractive 
aesthetic experience to any first-time visitor of your subsystem. BYMMV.

	Ingo
