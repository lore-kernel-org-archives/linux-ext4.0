From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: How is e2fsck's time_fudge supposed to behave?
Date: Wed, 18 Mar 2015 13:58:56 -0500
Message-ID: <5509CAF0.7030402@redhat.com>
References: <55036536.5030300@redhat.com> <20150317173227.GB6670@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56296 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755709AbbCRS7A (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Mar 2015 14:59:00 -0400
In-Reply-To: <20150317173227.GB6670@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 3/17/15 12:32 PM, Jan Kara wrote:
> On Fri 13-03-15 17:31:18, Eric Sandeen wrote:

...

>> So unless I'm missing something, the whole fudge_time dance does nothing
>> except change the message, and after reading lots of words in the e2fsck.conf
>> manpage ;) this bit seems relevant as to the intent:
>>
>>> So by default, we allow the superblock  times  to
>>> be  fudged  by  up to 24 hours.
>>
>> I had the impression that "allow" meant "ignore" but this still triggers
>> exactly the same action and correction.  Is that as intended?
>>
>> I'll send a patch do a printf and take no other action if inside the
>> fudge_time window, if that seems like the right thing to do.
>   The actions became the same after commit
> 87aca2ad028b9 (e2fsck: fix last mount time and last write time in preen
> mode). Previously only fudged values were allowed to be fixed in the preen
> mode. The question is whether we now want to change e2fsck to just ignore
> difference within fudge or whether we just stop doing that fudge thing.
> Either makes sense to me...

Oh, thanks, I had missed that.  Funny that OpenSUSE also set broken_system_clock;
Fedora had been doing that too.  For the same reasons.  o_O

The problem I'm still seeing is that if the clock is off by under 24h, we still
do fix_problem(), and set E2F_FLAG_PROBLEMS_FIXED, so check_if_skip() doesn't allow
a skip.  This happens on every single boot.

It sure seems like the intent was to completely ignore superblock time deltas under
24h... I guess I'll send a patch to do that, and see what Ted thinks.

Thanks,
-Eric


