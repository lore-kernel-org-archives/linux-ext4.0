From: Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>
Subject: Re: [PATCH v3 0/2] ext4: increase mbcache scalability
Date: Fri, 18 Oct 2013 06:43:18 -0600
Message-ID: <52612CE6.9080609@hp.com>
References: <52309F27.8060008@redhat.com> <alpine.DEB.2.02.1309111325270.5862@nftneq.ynat.uz> <5230D739.9010109@redhat.com> <20130911212523.GE13397@thunk.org> <5230D450.7000609@hp.com> <20130912122317.GC12918@thunk.org> <5232FF3E.7080604@hp.com> <5233609F.7060303@redhat.com> <523886CE.2070203@hp.com> <5239B65E.4060202@redhat.com> <20130921185304.GB8606@thunk.org> <D59BF31F-934D-4DE6-9E5C-F92014F09C68@dilger.ca> <52432EB5.1090706@hp.com> <DDE42D4A-C3E4-4E63-ADDF-B45A7C7B1A7D@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
	"linux-ext4@vger.kernel.org List" <linux-ext4@vger.kernel.org>,
	"Chandramouleeswaran, Aswin" <aswin@hp.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from g1t0028.austin.hp.com ([15.216.28.35]:30832 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756800Ab3JRSrn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Oct 2013 14:47:43 -0400
In-Reply-To: <DDE42D4A-C3E4-4E63-ADDF-B45A7C7B1A7D@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10/03/2013 09:22 PM, Andreas Dilger wrote:

> 
> This is a pretty significant price to pay for SELinux in any case.
> I guess it is probably lower overhead with 256-byte inodes, but
> anything that adds 5-25% overhead shouldn't be taken for granted.
> 
> Cheers, Andreas
> 

So far we have determined that,

- With SELinux enabled a ramdisk filesytem, with default node size of 128 bytes, extended xattr is generated
- In one of the aim7 workload, mbcache has a hit ratio of about 65%

Seems like mbcache itself and the mbcache lock optimization attempt by the patch could actually improve performance for a real word system where extended xattr is employed.  I believe the patch should go in if there isn't any concern.

Please let me know if there is any comment or concern about the patch.

Thanks,
Mak.



