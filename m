From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH v3 0/2] ext4: increase mbcache scalability
Date: Thu, 3 Oct 2013 21:22:09 -0600
Message-ID: <DDE42D4A-C3E4-4E63-ADDF-B45A7C7B1A7D@dilger.ca>
References: <52309F27.8060008@redhat.com> <alpine.DEB.2.02.1309111325270.5862@nftneq.ynat.uz> <5230D739.9010109@redhat.com> <20130911212523.GE13397@thunk.org> <5230D450.7000609@hp.com> <20130912122317.GC12918@thunk.org> <5232FF3E.7080604@hp.com> <5233609F.7060303@redhat.com> <523886CE.2070203@hp.com> <5239B65E.4060202@redhat.com> <20130921185304.GB8606@thunk.org> <D59BF31F-934D-4DE6-9E5C-F92014F09C68@dilger.ca> <52432EB5.1090706@hp.com>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Theodore Ts'o <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
	"linux-ext4@vger.kernel.org List" <linux-ext4@vger.kernel.org>,
	aswin@hp.com
To: Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:64828 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741Ab3JDDWM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Oct 2013 23:22:12 -0400
Received: by mail-pd0-f172.google.com with SMTP id z10so3368295pdj.3
        for <linux-ext4@vger.kernel.org>; Thu, 03 Oct 2013 20:22:12 -0700 (PDT)
In-Reply-To: <52432EB5.1090706@hp.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2013-09-25, at 12:43 PM, Thavatchai Makphaibulchoke wrote:
> On 09/21/2013 05:12 PM, Andreas Dilger wrote:
>> I just noticed that we have a patch for Lustre that adds a "no_mbcache" mount option to disable mbcache on a per-filesystem basis.
>> 
>> The newest patch we have is based on FC19 (3.10 kernel), is this something that would be of interest if we submitted it upstream?
>> 
>> http://review.whamcloud.com/#/c/7263/8/ldiskfs/kernel_patches/patches/fc19/ext4-disable-mb-cache.patch
>> 
>> Cheers, Andreas
>> 
> 
> Here are some of the improvement I saw with SELinux disabled.

To confirm, is this data on your "128-byte inode on ramdisk" config,
or is this on a system with a real disk and 256-byte inodes?

> On an 80 core machine,
> 
> custom 15.5%
> disk 27.81
> fserver 5.33%
> new_dbase 9.06%
> new_fserver 5.45%
> 
> 
> On an 8 core machine,
> 
> alltests 5.24
> custom 2.26
> shared 9.32
> short 24.08
> 
> The rest is not noticably different.

This is a pretty significant price to pay for SELinux in any case.
I guess it is probably lower overhead with 256-byte inodes, but
anything that adds 5-25% overhead shouldn't be taken for granted.

Cheers, Andreas





