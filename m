From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [RFC] ext4: block reservation allocation
Date: Mon, 27 Feb 2012 09:37:32 -0600
Message-ID: <4F4BA33C.1050303@redhat.com>
References: <20120227090901.GA13953@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43305 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751738Ab2B0Phe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 27 Feb 2012 10:37:34 -0500
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q1RFbYh0007471
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Mon, 27 Feb 2012 10:37:34 -0500
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id q1RFbWup032185
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 27 Feb 2012 10:37:34 -0500
In-Reply-To: <20120227090901.GA13953@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2/27/12 3:09 AM, Zheng Liu wrote:
> Hi list,
> 
> Now, in ext4, we have multi-block allocation and delay allocation. They work
> well for most scenarios. However, in some specific scenarios, they cannot help
> us to optimize block allocation. For example, the user may want to indicate some
> file set to be allocated at the beginning of the disk because its speed in this
> position is faster than its speed at the end of disk.

I agree with Lukas - please, no.

You can play tricks with your storage to accomplish much the same thing,
by making filesystems on faster & slower devices and mounting them on
directories which your application can recognize as faster/slower.

If you want "fast" for metadata, adilger has a recipe out there for using
lvm to interleave ssd blocks with spinning blocks to get metadata to line
up on the ssd.

A filesystem-specific hack for a custom application has no place in EXT4,
IMHO, sorry.

Essentially this would move allocation decisions to userspace, and I don't
think that sounds like a good idea.  If nothing else, the application shouldn't
assume that it "knows" anything at all about which regions of a filesystem may
be faster or slower...

-Eric


> I have done the following experiment. The experiment is on my own server, which
> has 16 Intel(R) Xeon(R) CPU E5620 @ 2.40GHz, 48G memory and a 1T sas disk. I
> split this disk into two partitions, one has 900G, and another has 100G. Then I
> use dd to get the speed of read/write. The result is as following.
> 
> [READ]
> # dd if=/dev/sdk1 of=/dev/null bs=128k count=10000 iflag=direct
> 1310720000 bytes (1.3 GB) copied, 9.41151 s, 139 MB/s
> 
> # dd if=/dev/sdk2 of=/dev/null bs=128k count=10000 iflag=direct
> 1310720000 bytes (1.3 GB) copied, 17.952 s, 73.0 MB/s
> 
> [WRITE]
> # dd if=/dev/zero of=/dev/sdk1 bs=128k count=10000 oflag=direct
> 1310720000 bytes (1.3 GB) copied, 8.46005 s, 155 MB/s
> 
> # dd if=/dev/zero of=/dev/sdk2 bs=128k count=10000 oflag=direct
> 1310720000 bytes (1.3 GB) copied, 15.8493 s, 82.7 MB/s
> 
> So filesystem can provide a new feature to let the user to indicate a value
> for reserving some blocks from the beginning of the disk. When the user needs
> to allocate some blocks for an important file that needs to be read/write as
> quick as possible, the user can use ioctl(2) and/or other ways to notify
> filesystem to allocate these blocks in the reservation area. Thereby, the user
> can obtain the higher performance for manipulating this file set.
> 
> This idea is very trivial. So any comments or suggestions are appreciated.
> 
> Regards,
> Zheng
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

