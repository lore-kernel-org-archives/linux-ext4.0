From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH v3 0/2] ext4: increase mbcache scalability
Date: Sat, 19 Oct 2013 18:06:27 -0500
Message-ID: <52631073.3060503@redhat.com>
References: <52309F27.8060008@redhat.com> <alpine.DEB.2.02.1309111325270.5862@nftneq.ynat.uz> <5230D739.9010109@redhat.com> <20130911212523.GE13397@thunk.org> <5230D450.7000609@hp.com> <20130912122317.GC12918@thunk.org> <5232FF3E.7080604@hp.com> <5233609F.7060303@redhat.com> <523886CE.2070203@hp.com> <5239B65E.4060202@redhat.com> <20130921185304.GB8606@thunk.org> <D59BF31F-934D-4DE6-9E5C-F92014F09C68@dilger.ca> <52432EB5.1090706@hp.com> <DDE42D4A-C3E4-4E63-ADDF-B45A7C7B1A7D@dilger.ca> <52612CE6.9080609@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@dilger.ca>,
	"Theodore Ts'o" <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org List" <linux-ext4@vger.kernel.org>,
	"Chandramouleeswaran, Aswin" <aswin@hp.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
To: Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2497 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750767Ab3JSXGy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 19 Oct 2013 19:06:54 -0400
In-Reply-To: <52612CE6.9080609@hp.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10/18/13 7:43 AM, Thavatchai Makphaibulchoke wrote:
> On 10/03/2013 09:22 PM, Andreas Dilger wrote:
> 
>>
>> This is a pretty significant price to pay for SELinux in any case.
>> I guess it is probably lower overhead with 256-byte inodes, but
>> anything that adds 5-25% overhead shouldn't be taken for granted.
>>
>> Cheers, Andreas
>>
> 
> So far we have determined that,
> 
> - With SELinux enabled a ramdisk filesytem, with default node size of 128 bytes, extended xattr is generated
> - In one of the aim7 workload, mbcache has a hit ratio of about 65%
> 
> Seems like mbcache itself and the mbcache lock optimization attempt
> by the patch could actually improve performance for a real word
> system where extended xattr is employed. I believe the patch should
> go in if there isn't any concern.

But the 128-byte inode size is not common, so in general, mbcache isn't
exercised that often.

(still, it is there, and if there's a nice scalability patch for it,
it's probably worth it).

-Eric

> Please let me know if there is any comment or concern about the patch.
> 
> Thanks,
> Mak.
> 
> 
> 

