From: Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>
Subject: Re: [PATCH v3 0/2] ext4: increase mbcache scalability
Date: Wed, 25 Sep 2013 12:43:01 -0600
Message-ID: <52432EB5.1090706@hp.com>
References: <52309F27.8060008@redhat.com> <alpine.DEB.2.02.1309111325270.5862@nftneq.ynat.uz> <5230D739.9010109@redhat.com> <20130911212523.GE13397@thunk.org> <5230D450.7000609@hp.com> <20130912122317.GC12918@thunk.org> <5232FF3E.7080604@hp.com> <5233609F.7060303@redhat.com> <523886CE.2070203@hp.com> <5239B65E.4060202@redhat.com> <20130921185304.GB8606@thunk.org> <D59BF31F-934D-4DE6-9E5C-F92014F09C68@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
	T Makphaibulchoke <tmac@hp.com>,
	"linux-ext4@vger.kernel.org List" <linux-ext4@vger.kernel.org>,
	"aswin@hp.com" <aswin@hp.com>,
	"aswin_proj@lists.hp.com" <aswin_proj@lists.hp.com>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from g4t0017.houston.hp.com ([15.201.24.20]:48163 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833Ab3IZAqb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 25 Sep 2013 20:46:31 -0400
In-Reply-To: <D59BF31F-934D-4DE6-9E5C-F92014F09C68@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 09/21/2013 05:12 PM, Andreas Dilger wrote:
> I just noticed that we have a patch for Lustre that adds a "no_mbcache" mount option to disable mbcache on a per-filesystem basis.
> 
> The newest patch we have is based on FC19 (3.10 kernel), is this something that would be of interest if we submitted it upstream?
> 
> http://review.whamcloud.com/#/c/7263/8/ldiskfs/kernel_patches/patches/fc19/ext4-disable-mb-cache.patch
> 
> Cheers, Andreas
> 

Here are some of the improvement I saw with SELinux disabled.

On an 80 core machine,

custom 15.5%
disk 27.81
fserver 5.33%
new_dbase 9.06%
new_fserver 5.45%


On an 8 core machine,

alltests 5.24
custom 2.26
shared 9.32
short 24.08

The rest is not noticably different.

Thanks,
Mak.


