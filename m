From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH, RFC] mke2fs: get device topology values from blkid
Date: Fri, 18 Sep 2009 08:20:24 -0600
Message-ID: <20090918142024.GU2537@webber.adilger.int>
References: <4AB2B6B9.7010506@redhat.com>
 <20090918055547.GO2537@webber.adilger.int> <4AB39375.6040506@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:37218 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbZIROUU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Sep 2009 10:20:20 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n8IEKOdL005574
	for <linux-ext4@vger.kernel.org>; Fri, 18 Sep 2009 07:20:24 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KQ6004007QHRI00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Fri,
 18 Sep 2009 07:20:24 -0700 (PDT)
In-reply-to: <4AB39375.6040506@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sep 18, 2009  09:04 -0500, Eric Sandeen wrote:
> Andreas Dilger wrote:
>>> +	rc = blkid_probe_set_device(pr, fd, 0, 0);
>>
>> Is this in the e2fsprogs blkid code yet?  I'm guessing not, since you
>
> right, not yet.  I don't know what the long-term plan is for e2fsprogs  
> blkid; keeping 2 trees in sync seems like a lot of work w/o much gain...

I thought that was Ted's plan?  We usually recommend people to update to
the latest e2fsprogs, yet not everyone will be able to upgrade to the
latest util-linux, especially if it is pulling in other libraries that
can cause package conflicts (e.g. with xfstools or similar).

>> Either this needs to be configured in, or you need to upgrade the
>> blkid included with e2fsprogs to handle this.
>
> Yep, that's why I said "It'll also need some config-fu to be sure we've  
> got a blkid which has these calls...." :) and why I was asking about  
> moving the in-tree headers slightly out of the way.

Sigh, it helps if I read the whole email, I guess... :-)

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

