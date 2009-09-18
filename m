From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH, RFC] mke2fs: get device topology values from blkid
Date: Fri, 18 Sep 2009 09:30:27 -0500
Message-ID: <4AB39983.1000001@redhat.com>
References: <4AB2B6B9.7010506@redhat.com> <20090918055547.GO2537@webber.adilger.int> <4AB39375.6040506@redhat.com> <20090918142024.GU2537@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54326 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752501AbZIROa2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Sep 2009 10:30:28 -0400
In-Reply-To: <20090918142024.GU2537@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger wrote:
> On Sep 18, 2009  09:04 -0500, Eric Sandeen wrote:
>> Andreas Dilger wrote:
>>>> +	rc = blkid_probe_set_device(pr, fd, 0, 0);
>>> Is this in the e2fsprogs blkid code yet?  I'm guessing not, since you
>> right, not yet.  I don't know what the long-term plan is for e2fsprogs  
>> blkid; keeping 2 trees in sync seems like a lot of work w/o much gain...
> 
> I thought that was Ted's plan?  We usually recommend people to update to
> the latest e2fsprogs, yet not everyone will be able to upgrade to the
> latest util-linux, especially if it is pulling in other libraries that
> can cause package conflicts (e.g. with xfstools or similar).

It doesn't much matter to me personally since my distro ;) seems pretty 
well committed to using the blkid & libuuid now in util-linux-ng.

I guess I'm not thinking too much about a world where people are pulling 
down tarballs & doing make install; I'm sure that still goes on but 
those folks are smart enough to handle things moving around, or should be.

*shrug*

As long as we can teach the e2fsprogs build to optionally pull libblkid 
& libuuid headers from the system rather than the e2fsprogs tree, it'll 
give the flexibility we need.

-Eric
