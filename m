From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [PATCH 3/3] ext4: Deprecate barrier= and nobarrier mount options
Date: Wed, 26 Jan 2011 07:16:18 -0500
Message-ID: <4D401092.9060009@redhat.com>
References: <20110126071200.GE32261@tux1.beaverton.ibm.com> <20110126072329.GK27190@tux1.beaverton.ibm.com> <20110126093632.GB12520@htj.dyndns.org> <20110126104734.GA23245@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Tejun Heo <tj@kernel.org>, "Darrick J. Wong" <djwong@us.ibm.com>,
	Vivek Goyal <vgoyal@redhat.com>, axboe@kernel.dk,
	tytso@mit.edu, shli@kernel.org, neilb@suse.de,
	adilger.kernel@dilger.ca, snitzer@redhat.com,
	linux-kernel@vger.kernel.org, kmannth@us.ibm.com, cmm@us.ibm.com,
	linux-ext4@vger.kernel.org, hch@lst.de, josef@redhat.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12093 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751594Ab1AZMRZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Jan 2011 07:17:25 -0500
In-Reply-To: <20110126104734.GA23245@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 01/26/2011 05:47 AM, Jan Kara wrote:
>    Hello,
>
> On Wed 26-01-11 10:36:32, Tejun Heo wrote:
>> On Tue, Jan 25, 2011 at 11:23:29PM -0800, Darrick J. Wong wrote:
>>> As part of migrating the FLUSH/FUA knob to the block layer, remove the support
>>> code for the barrier-related mount options and remove the conditionals around
>>> flushes in favor of always issuing the flush.  The block layer will handle
>>> gracefully the situation where a FLUSH or FUA request is issued to a device
>>> that doesn't support it.  Modify the option parsing code to print a warning if
>>> someone tries to use the old mount option.
>>>
>>> Note: The nobarrier bit in the default mount flags is now useless.
>> The option is something which users are already quite familiar with.
>> I think we'll just have to carry this around.  What we can do, tho, is
>> moving the actual control mechanism to block layer -
>> ie. blkdev_skip_flush() or something like that which ignores flush
>> requests for the current exclusive opener.
>    Ted should have a final word about this but I believe it's possible to
> deprecate the mount options. Maybe with some transition period where
> deprecation message is shown but the option actually still works. That
> being said I'm not sure what we should do when someone has a disk with two
> partitions and one partition is mounted with barriers and another one
> without them - sure, one has to think hard to find a sane use case for this
> (possibly if user does not care about data after a crash on one of the
> partitions, in which case he should probably use nojournal mode) but it
> should probably work.
>
> 								Honza

I would also like to suggest that mount is the right time to change a per file 
system behaviour. We have well known paths (add the mount options to /etc/fstab) 
and sys admins understand it.

If we have to poke a file, what is the suggested mechanism for doing this? 
Another, new script or user space utility that needs to be run at mount time for 
each file system?

If we did want to deprecate the "barrier" name, I would leave it in place and 
replace it with something meaningful (at mount time!) to users like 
"data_safety" and "no_data_safety" modes :)

Ric



