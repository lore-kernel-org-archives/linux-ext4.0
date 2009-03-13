From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] fix bogus BUG_ONs in in mballoc code
Date: Thu, 12 Mar 2009 21:08:02 -0500
Message-ID: <49B9C002.9090008@redhat.com>
References: <49B93E44.8070109@ph.tum.de> <49B958A1.6060805@redhat.com> <20090313010940.GO17104@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Thiemo Nagel <thiemo.nagel@ph.tum.de>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:39582 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754271AbZCMCIJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Mar 2009 22:08:09 -0400
In-Reply-To: <20090313010940.GO17104@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Thu, Mar 12, 2009 at 01:46:57PM -0500, Eric Sandeen wrote:
>> Thiemo Nagel reported that:
>>
>> # dd if=/dev/zero of=image.ext4 bs=1M count=2
>> # mkfs.ext4 -v -F -b 1024 -m 0 -g 512 -G 4 -I 128 -N 1 \
>>   -O large_file,dir_index,flex_bg,extent,sparse_super image.ext4
>> # mount -o loop image.ext4 mnt/
>> # dd if=/dev/zero of=mnt/file
>>
>> oopsed, with a BUG_ON in ext4_mb_normalize_request because
>> size == EXT4_BLOCKS_PER_GROUP
>>
>> It appears to me (esp. after talking to Andreas) that the BUG_ON
>> is bogus; a request of exactly EXT4_BLOCKS_PER_GROUP should
>> be allowed, though larger sizes do indicate a problem.
>>
>> Fix that an another (apparently rare) codepath with a similar check.
> 
> Hmm.... is this at all likely to happen with a standard ext4
> filesystem parameters?  Or was this triggered because of the
> artifially set -g 512 parameter?  The question is whether we should
> try pushing this to Linus at this point, or let this wait until the
> merge window opens.
> 
> Opinions?
> 
> 						= Ted
> <

I wondered the same thing, and will admit to probably not digging deep
enough on this one.  I think the fix is ok as is but you are asking the
right questions.  Maybe a clusterfs mballoc expert can chime in and save
us some time? :)

-=Eric
