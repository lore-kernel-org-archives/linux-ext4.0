From: Andreas Dilger <adilger.kernel@dilger.ca>
Subject: Re: [PATCH 1/3] jbd2 : Make jbd2 transaction handle allocation to return errors and handle them gracefully.
Date: Mon, 24 Jan 2011 18:06:24 -0600
Message-ID: <AA32FD05-E9BD-40AB-8495-EAD0547B5E02@dilger.ca>
References: <AANLkTi=o-rcsbY1gOExGyWdQ41m7KWpJ7=UzX4306m=t@mail.gmail.com> <20110123054049.GC3237@thunk.org> <20110123062900.GA7436@noexit> <20110124133143.GA5058@quack.suse.cz>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Joel Becker <jlbec@evilplan.org>, Ted Ts'o <tytso@mit.edu>,
	Manish Katiyar <mkatiyar@gmail.com>,
	ext4 <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from hiltoncluster2.worldspice.net ([216.37.94.62]:4881 "EHLO
	hiltoncluster2.worldspice.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751521Ab1AYGXR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Jan 2011 01:23:17 -0500
In-Reply-To: <20110124133143.GA5058@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-01-24, at 06:31, Jan Kara wrote:
> On Sat 22-01-11 22:29:01, Joel Becker wrote:
>> On Sun, Jan 23, 2011 at 12:40:49AM -0500, Ted Ts'o wrote:
>>> Hmm, I wonder if it would be better to use
>>> 
>>> jbd2_journal_start(...)
>>> 
>>> and
>>> 
>>> jbd2_journal_start_nofail(...)
>> 
>> 	This API is markedly better to read.  Btw, does _nofail() mean no
>> possible failures, or just no memory errors?  If it is no failures, I'd
>> love to see the function become void.

I also prefer changing the function name instead of adding an argument.

>  jbd2_journal_start can always fail e.g. because the journal is aborted.
> So it really just means no memory failures...
> 
>>> The tradeoff is that long-term, the code is more readable (as opposed
>>> to having people look up what a random "true" or "false" value means).
>>> But short-term, while it will make the patch smaller, it also makes
>>> the patch harder audit, since we need to look at all of the places
>>> where we _haven't_ made a change to make sure those call sites can
>>> tolerate an error return.
>> 
>> 	I think we should start with jbd2_journal_start_can_fail() or
>> something like it, and change it back to jbd2_journal_start() in the
>> next window.  It's a silly name, but it catches exactly what you are
>> worried about.
> 
>  Yes, I think this would be nice for auditting (but for that matter
> current interface with additional argument isn't bad either and we can
> just do the rename to _nofail in the final patch...).

The reason I don't like the "true" and "false" arguments is that it isn't at all clear which functions have "false" because they cannot fail, and which ones just haven't been updated yet.

In that light, I'd prefer to add _two_ new functions, one that indicates the function needs to retry (as it does now), and one that indicates that the caller will handle the error.  That way it is clear which functions have been investigated, and which ones haven't been looked at yet.  Once all of the functions have been changed, we can remove the old jbd2_journal_start() function to catch any patches that have not been updated to the new functions.

Maybe jbd2_journal_start_canfail() and jbd2_journal_start_retry()?


Cheers, Andreas





