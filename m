From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH v3 0/2] ext4: increase mbcache scalability
Date: Wed, 18 Sep 2013 09:19:10 -0500
Message-ID: <5239B65E.4060202@redhat.com>
References: <5229C939.8030108@hp.com> <62D71A85-C7EE-4F5F-B481-5329F0282044@dilger.ca> <20130910210250.GH29237@thunk.org> <522FDFCC.1070007@redhat.com> <20130911113001.GB13315@thunk.org> <52309F27.8060008@redhat.com> <alpine.DEB.2.02.1309111325270.5862@nftneq.ynat.uz> <5230D739.9010109@redhat.com> <20130911212523.GE13397@thunk.org> <5230D450.7000609@hp.com> <20130912122317.GC12918@thunk.org> <5232FF3E.7080604@hp.com> <5233609F.7060303@redhat.com> <523886CE.2070203@hp.com>
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
Received: from mx1.redhat.com ([209.132.183.28]:34748 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751511Ab3IROVu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Sep 2013 10:21:50 -0400
In-Reply-To: <523886CE.2070203@hp.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 9/17/13 11:43 AM, Thavatchai Makphaibulchoke wrote:
> On 09/13/2013 12:59 PM, Eric Sandeen wrote:
>> 
>> suggestions:
>> 
>> 1) send us dumpe2fs -h /dev/sdXX | grep "Inode size" for this
>> filesystem 2) print out the inode number in your printk's above 3)
>> stat one of those inodes in debugfs after the run (debugfs stat
>> <inodenumber>) - with <> around the inode nr
>> 
>> -Eric
>> 
> 
> I think I found out why we get into the mbcache path.  The test uses
> ramfss, which are mounted and unmounted at the start and end of the
> test.  Looks like a ramfs' default inode size is 128, causing all the
> mbcaching for the xattrs.  There seems to be nothing wrong with
> either SELinux or xattr.  Sorry for the confusion.

smaller filesystems go back to 128 byte inodes, IIRC.

That's why I asked for dumpe2fs long ago ;)

But glad to have the mystery solved!

Thanks,
-Eric

> Thanks, Mak.
> 

