From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH v3 0/2] ext4: increase mbcache scalability
Date: Fri, 13 Sep 2013 13:59:43 -0500
Message-ID: <5233609F.7060303@redhat.com>
References: <5229C939.8030108@hp.com> <62D71A85-C7EE-4F5F-B481-5329F0282044@dilger.ca> <20130910210250.GH29237@thunk.org> <522FDFCC.1070007@redhat.com> <20130911113001.GB13315@thunk.org> <52309F27.8060008@redhat.com> <alpine.DEB.2.02.1309111325270.5862@nftneq.ynat.uz> <5230D739.9010109@redhat.com> <20130911212523.GE13397@thunk.org> <5230D450.7000609@hp.com> <20130912122317.GC12918@thunk.org> <5232FF3E.7080604@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger@dilger.ca>,
	T Makphaibulchoke <tmac@hp.com>,
	"linux-ext4@vger.kernel.org List" <linux-ext4@vger.kernel.org>,
	aswin@hp.com, aswin_proj@lists.hp.com
To: Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14574 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754772Ab3IMTCT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 13 Sep 2013 15:02:19 -0400
In-Reply-To: <5232FF3E.7080604@hp.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 9/13/13 7:04 AM, Thavatchai Makphaibulchoke wrote:
> On 09/12/2013 06:23 AM, Theodore Ts'o wrote:
>> (I've trimmed the cc list to stop spamming people who probably don't
>> care as much about this).
>>
>> So I've tried the following patch, and I've confirmed that for short
>> xattrs (i.e., that fit inside the inode body, assuming an inode size >
>> 128 bytes), the mbcache paths don't trigger at all.
>>
>> Could you try this patch and see if we can figure out why mbcache code
>> paths are triggering for you?
>>
>> 						- Ted
>>
> 
> I tried the patch.  First off, looks like the patch has a lot of warnings, it does produces tremendous non-stop warnings during aim7 run, particularly the one from line 1627.
> 
> Unfortunately, looks like with this patch we are still calling ext4_xattr_cache_find().

All the patch does is issue warnings, so no fixing was expected ;)

> I added more debugging code to print out the first few xattrs that get us into ex4_xattr_cache_find().  This is what I have,
> 
> [   80.540977] ext4_xattr_block_set: name  len 28.
> [  155.480692] ext4_xattr_block_set: name selinux len 32.
> [  155.486531] ext4_xattr_block_set: name selinux len 32.
> [  155.492283] ext4_xattr_block_set: name selinux len 32.
> [  155.497988] ext4_xattr_block_set: name selinux len 32.
> [  155.504064] ext4_xattr_block_set: name selinux len 32.
> [  155.509771] ext4_xattr_block_set: name selinux len 32.
> [  155.515475] ext4_xattr_block_set: name selinux len 32.
> [  155.521179] ext4_xattr_block_set: name selinux len 32.

ok, all small...

> I'll continue debugging and get back with any new finding.

suggestions:

1) send us dumpe2fs -h /dev/sdXX | grep "Inode size" for this filesystem
2) print out the inode number in your printk's above
3) stat one of those inodes in debugfs after the run (debugfs stat <inodenumber>) - with <> around the inode nr

-Eric
