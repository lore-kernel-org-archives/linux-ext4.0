From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Bug in delayed allocation: really bad block layouts!
Date: Mon, 11 Aug 2008 00:36:20 -0500
Message-ID: <489FCFD4.2050602@redhat.com>
References: <E1KSEkA-00009o-CV@closure.thunk.org> <489F2B38.3060104@redhat.com> <20080810182231.GB15353@mit.edu> <489F397A.1040709@redhat.com> <489F49B0.6020105@redhat.com> <20080811014646.GE15353@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:32958 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750839AbYHKFgY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Aug 2008 01:36:24 -0400
In-Reply-To: <20080811014646.GE15353@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> 1;1613;0cOn Sun, Aug 10, 2008 at 03:04:00PM -0500, Eric Sandeen wrote:
>> # find . -name \*.h | xargs filefrag | grep -v extents | awk -F :
>> '{print $2}' | sort | uniq -c
>>    2460  1 extent found
>>
>> so *really* everything.
>>
> 
> Um, no, because you filtered out "extents", and filefrag will print "2
> extents found", so that it gets the singular/plural correct.

Oh, heh, whoops! :)  But still:

[root@inode test]# find . -name \*.h | xargs filefrag | grep -v "extents
format" | awk -F : '{print $2}' | sort | uniq -c
   2461  1 extent found

and to be sure:

[root@inode test]# find . -name \*.h | xargs filefrag | grep "extents
found"
[root@inode test]#

> One of
> the things I've been meaning to do is to clean up the output of
> filefrag so that it's a bit easier to parse.  It's really stupid for
> it to print "file is in extents format" over and over again...

I'm not really even sure why it should print it at all, ever, at least
without -vvv or something.  (That's what I meant to filter the first
time ;)  If the tool is to report layout I'm not sure the trivia about
how the layout is tracked internally is all that interesting.  The
fiemap patches for filefrag that print it out more as a table format,
more like xfs_bmap does, should be a lot better.  But anyway...

> I've done some research on my laptop's filesystem, and I've found
> examples of files with the characteristic horrendous layout going back
> as far back to at least July 7th.  (See below)
> 
> This takes us back to about the time when we were stablizing the
> patches that went into 2.6.26, and before the most recent set of
> patches to fix the journal credits and delayed allocation patches.
> 
> Interestingly, I'm not seeing the bad layouts for files created June
> 30th, which is when I switched my laptop's root filesystem to ext4.
> So that gives us a pretty good time bound on the patches that might be
> involved.  (This is a great demonstration of what it's a real win to
> manage the ext4 patch queue using git, since we can see which patches
> were added during that week or so.)
> 
> In other news, I've added an enhancement to e2fsck which makes it much
> easier to spot these sorts of problems.  On the latest e2fsprogs git
> branch, you'll be able to do "e2fsck -E fragcheck /dev/thunk/root" and
> get a report which makes it really ease to see the problem.
> 
> 						- Ted

Hm... I wonder why I'm not seeing it?

-Eric
