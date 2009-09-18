From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH, RFC] mke2fs: get device topology values from blkid
Date: Fri, 18 Sep 2009 09:04:37 -0500
Message-ID: <4AB39375.6040506@redhat.com>
References: <4AB2B6B9.7010506@redhat.com> <20090918055547.GO2537@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25622 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753688AbZIROEj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Sep 2009 10:04:39 -0400
In-Reply-To: <20090918055547.GO2537@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger wrote:
> On Sep 17, 2009  17:22 -0500, Eric Sandeen wrote:
>> This is just a rough cut, due to the blkid header selection
>> issues I mentioned earlier on the list.  It'll also need
>> some config-fu to be sure we've got a blkid which has these
>> calls, but with it in place, we'll finally have automatic
>> selection of stride/stripe:
>>
>> # misc/mke2fs -b 4096 /dev/md0 
>> mke2fs 1.41.9 (22-Aug-2009)
>> Filesystem label=
>> OS type: Linux
>> Block size=4096 (log=2)
>> Fragment size=4096 (log=2)
>> Stride=16 blocks, Stripe width=32 blocks
>> ...
> 
> Cool.
> 
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>>  	printf(_("Fragment size=%u (log=%u)\n"), fs->fragsize,
>>  		s->s_log_frag_size);
>> +	printf(_("Stride=%u blocks, Stripe width=%u blocks\n"),
>> +	       s->s_raid_stride, s->s_raid_stripe_width);
> 
> I was going to say we should only print these if non-zero, but for
> Pete's sake we print the "Fragment size", which has never been useful,
> so I don't see any harm in this.  Maybe "RAID Stride ..."?
> 
>> +static errcode_t ext2fs_get_device_geometry(const char *file,
>> +					    struct ext2_super_block *fs_param)
>> +{
>> +	rc = blkid_probe_set_device(pr, fd, 0, 0);
> 
> Is this in the e2fsprogs blkid code yet?  I'm guessing not, since you

right, not yet.  I don't know what the long-term plan is for e2fsprogs 
blkid; keeping 2 trees in sync seems like a lot of work w/o much gain...

> are getting build problems, which means anyone building with something
> other than latest & greatest util-linux will also get failures.
> 
> Either this needs to be configured in, or you need to upgrade the
> blkid included with e2fsprogs to handle this.

Yep, that's why I said "It'll also need some config-fu to be sure we've 
got a blkid which has these calls...." :) and why I was asking about 
moving the in-tree headers slightly out of the way.

-Eric

> Cheers, Andreas
> --
> Andreas Dilger
> Sr. Staff Engineer, Lustre Group
> Sun Microsystems of Canada, Inc.
> 

