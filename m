From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext3: wait on all pending commits in ext3_sync_fs
Date: Tue, 23 Dec 2008 09:56:36 -0600
Message-ID: <49510A34.10102@redhat.com>
References: <4908C951.2000309@redhat.com> <20081103184426.GA31894@ajones-laptop.nbttech.com> <20081103113318.35b0c266.akpm@linux-foundation.org> <20081103201428.GB30565@ajones-laptop.nbttech.com> <20081218231707.GB20092@atrey.karlin.mff.cuni.cz> <494ADEB3.8010109@redhat.com> <20081219002752.GE8424@duck.suse.cz> <494AFA16.2010004@redhat.com> <494FE73E.5000802@redhat.com> <20081222225757.GV5000@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Ric Wheeler <rwheeler@redhat.com>, Jan Kara <jack@suse.cz>,
	Arthur Jones <ajones@riverbed.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"sct@redhat.com" <sct@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:34040 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750927AbYLWP4q (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 23 Dec 2008 10:56:46 -0500
In-Reply-To: <20081222225757.GV5000@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger wrote:
> On Dec 22, 2008  14:15 -0500, Ric Wheeler wrote:
>> Without having dived into the patch in detail, one worry I would have is  
>> that we still might care to spin up a drive for empty transactions in  
>> order to invalidate the drive's write cache.
>>
>> For example, if we have the following sequence:
>>
>>    (1) user app performs series of writes to file A
>>    (2) pages dirtied from writes to A are destaged to the disk over time
>>    (3) user app issues fsync(file A) to make sure that the data will  
>> survive a power outage
>>
>> At this point in time, would this change prevent us from spinning up the  
>> drive and invalidating the disk write cache for that fsync() ?
> 
> Well, if the writes themselves didn't spin up the drive, it is uncertain
> whether the write of the journal commit block would be any more helpful
> in getting that to happen.

So, ext4_sync_file() calls blkdev_issue_flush() which would should do
the right thing even if the drive is spun down, I think (rather than
hoping that some other journal activity would flush this out...)

I guess I don't know for sure what blkdev_issue_flush does on a
spun-down drive but I'd hope it does the right thing.

Pretty sure I sent a patch for ext3 to do the same, but it was
ignored/dropped/forgotten along with the barriers-by-default patch.
Suppose I could try again.

-Eric
