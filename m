From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Ext4 slow on links
Date: Wed, 20 Jun 2012 09:07:23 -0500
Message-ID: <4FE1D91B.8020707@redhat.com>
References: <20120620002014.GA25471@gamma.logic.tuwien.ac.at> <4FE14034.6070800@redhat.com> <20120620002014.GA25471@gamma.logic.tuwien.ac.at> <20120620021912.GA26323@thunk.org> <20120620033831.GA2395@gamma.logic.tuwien.ac.at> <BA050E9A-2385-4FF9-B41A-3A25F3FF066A@redhat.com> <20120620051844.GA7829@gamma.logic.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Ted Ts'o" <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Norbert Preining <preining@logic.at>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31232 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751799Ab2FTOHd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 20 Jun 2012 10:07:33 -0400
In-Reply-To: <20120620051844.GA7829@gamma.logic.tuwien.ac.at>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 6/20/12 12:18 AM, Norbert Preining wrote:
> Hi Eric,
> 
> On Di, 19 Jun 2012, Eric Sandeen wrote:
>> blktrace of the actions would show you something interesting as well.
> 
> I tried to understand the output, but didn't get any information
> that tells me something.
> 
> I rebooted into single user mode, started blktrace on sda, then run
> time ls -l /..../dir/with/links/ >/dev/null, stopped the blktrace.
> 
> Then I run blkparse and btt etc to generate a variety of data.

...

> 
> I don't know if that shows anything of interest, but if you need more,
> and want to waste a bit of time looking at the data, I have uploaded
> everything created into
> 	http://www.logic.at/people/preining/BlkParse.tar.gz

Here are the overall stats:

Total (sda):
 Reads Queued:       8,864,   35,456KiB	 Writes Queued:          90,    7,980KiB
 Read Dispatches:    8,864,   35,456KiB	 Write Dispatches:       49,    7,980KiB
 Reads Requeued:         0		 Writes Requeued:         0
 Reads Completed:    8,864,   35,456KiB	 Writes Completed:       59,    7,980KiB
 Read Merges:            0,        0KiB	 Write Merges:           41,      164KiB
 IO unplugs:            81        	 Timer unplugs:           0

so almost all reads, and no read merges; almost 35 megabytes read and every
one was a small 4k IO.

It's doing about 120 seeks/second.  I'm a little surprised that there was no read
merging...

Let me think about this. :)

-Eric
