From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: async commit & write barrier code
Date: Tue, 23 Sep 2008 19:16:45 -0400
Message-ID: <48D978DD.8080103@redhat.com>
References: <48D7D3DF.70505@redhat.com> <48D9545E.8040302@redhat.com> <20080923223505.GA11346@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"Stephen C. Tweedie" <sct@redhat.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:39840 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752211AbYIWXRQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 23 Sep 2008 19:17:16 -0400
In-Reply-To: <20080923223505.GA11346@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Tue, Sep 23, 2008 at 03:41:02PM -0500, Eric Sandeen wrote:
>   
>> I agree; with async commit, ext4/jbd2 is running with *no* barrier
>> writes in jbd code. (FWIW, on the fsync front, fsync calls
>> blkdev_issue_flush in ext4 so that part may actually be ok in the end).
>>
>> But at a minimum, I think that for data=ordered, there is now *no*
>> guarantee that the associated file data actually hits disk before the
>> size updates, is there?
>>     
>
> I think the theory behind this was that the journal checksums would
> protect us against misordered writes.  But yes, this means that we
> would effectively have data=writeback, and not data=ordered.  More
> seriously, when I started using my root filesystem with async commit,
> when the system crashed after suspend/resumes, I was seeing filesystem
> corruptions which caused data loss and which required e2fsck to fix.
> I've commented the patch out of the series file for now, until we can
> do some more testing of async commit.
>
> 							- Ted
>   

I think that is definitely the right thing to do at this point. In 
addition to testing, we should try to be very clear on how async 
interacts with barriers, data integrity, etc.

What worries me is how arbitrary the semantics can be given that storage 
devices (without flush or similar operations) can totally reorder IO 
requests. Specific worries include things like medium to large IO's can 
often bypass the write cache entirely, using the write cache itself only 
for small writes. That means that those small writes associated with the 
commit record can stay around for a long time in volatile write cache 
memory and go away on power loss (or suspend to disk!).

What are the basic  assumptions (wish lists?) that we have for ordering 
and persistence of the write sequence for our existing journal code?

Ric

