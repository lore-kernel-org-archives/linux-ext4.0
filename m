From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Work on ext4
Date: Fri, 25 Jul 2014 11:07:35 -0500
Message-ID: <53D280C7.1080904@redhat.com>
References: <CAPDOMVi_qXwY3R2fYiSwu9Bs2fA4kwamt3TKzVEZOZmuaLkbMA@mail.gmail.com> <20140725145946.GT1865@thunk.org> <CAPDOMVgmkoXQxGODzVaYWYykPWVmpG=jyKNbGv5=3BZ=XQnGrg@mail.gmail.com> <20140725154142.GU1865@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>, Nick Krause <xerofoify@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27130 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753246AbaGYQHj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Jul 2014 12:07:39 -0400
In-Reply-To: <20140725154142.GU1865@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 7/25/14, 10:41 AM, Theodore Ts'o wrote:

...

> This will hopefully get you started on the testing side of things,
> which is also a good way to start learning about how ext4 works.
> 
> Cheers,
> 
> 						- Ted

The old adage on IRC is "Don't ask to ask; ask."  In
development-land, it's more like "Don't ask to help; help."

The trick is knowing what constitutes "help."  Asking for
detailed instruction is not "help."

Over on the btrfs-list, Hugo had a good set of suggestions as
well; some are btrfs-specific, but in general, good advice for
anyone trying to get engaged with an upstream project:

>From Hugo -

...

>    My recommendations for you, if you want to work on btrfs, are:
> 
>  * Build and install the latest kernel from Linus's git repo
> 
>  * Read and understand the user documentation [2]
> 
>  * Create one or several btrfs filesystems with different
>    configurations and learn how they work in userspace -- what are the
>    features, what are the problems you see? Actually use at least one
>    of the filesystems you created for real data in daily use (with
>    backups)
> 
>  * Build the userspace tools from git
> 
>  * Pick up one of the userspace projects from [3] and implement that.
>    If you pick the right one(s), you'll have to learn about some of
>    the internal structures of the FS anyway. Compile and test your
>    patch. If you're adding a new feature, write an automated xfstest
>    for it as well.
> 
>  * Get that patch accepted. This will probably involve a sequence of
>    revisions to it, multiple versions over a period of several weeks
>    or more, with a review process. You should also send your test to
>    xfstests and get that accepted.
> 
>  * Do the above again, until you get used to the processes involved,
>    and have demonstrated that you can work well with the other people
>    in the subsystem, and are generally producing useful and sane code.
>    It's all about trust -- can you be trusted to mostly do the right
>    thing? (So far on linux-kernel, you've rather demonstrated the
>    opposite: your intentions are good, but your execution leaves a lot
>    to be desired)
> 
>  * Use the documentation at [4], and the output of btrfs-debug-tree to
>    understand the internal structure of the FS
> 
>  * Pick up one of the smaller, more self-contained ideas from the
>    projects page [5] (say, [6] or [7]) and try to implement it. Again:
>    build, write test code, test thoroughly, submit patch for review,
>    modify as suggested by reviewers, and repeat as often as necessary
> 
>    Hugo.


