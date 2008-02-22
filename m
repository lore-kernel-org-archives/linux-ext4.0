From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] e2fsprogs: error checking in blkid/devname.c
Date: Fri, 22 Feb 2008 10:16:53 -0600
Message-ID: <47BEF575.40908@redhat.com>
References: <47BDF6C9.8090009@redhat.com> <20080222131622.GK20118@mit.edu> <47BEE420.8030105@redhat.com> <20080222154404.GP20118@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	pspencer@fields.utoronto.ca
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:35443 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754169AbYBVQRQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Feb 2008 11:17:16 -0500
In-Reply-To: <20080222154404.GP20118@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Fri, Feb 22, 2008 at 09:02:56AM -0600, Eric Sandeen wrote:
>> Theodore Tso wrote:
>>> This looks good, but I assume that the bug was caused by some race
>>> condition where if you try to call dm_task_get_info() while some other
>>> process is creating or removing a snapshot, dm_task_get_info() is
>>> returning some kind of EAGAIN, or some other "Try again; we're busy"
>>> error, right?
>>>
>>> If that is the case, can you try to find out what error is being
>>> returned?  It may be the right thing to do is to check to see if we
>>> are getting a "resource is locked; try again in a sec" error message,
>>> and retry the dm_task_get_info(), instead of just returning a failure.
>> well, dm_task_get_info just returns either 0 or 1; unless there is some
>> other contextual piece of information to use, I don't know if we can
>> differentiate between error types.  I'll ask agk...
> 
> Maybe the right thing is to try 3 times before giving up, maybe with a
> nanosleep in between, or some such?  Hopefully agk can give us some
> hints about what's the right way to handle errors from all of the
> dm_task* calls.

>From a quick chat with agk, it sounds like outright failure is
appropriate.  Sounds like most of the calls fail for reasons like ENOMEM
(but it might be nice if it returned that, eh?)

-Eric
