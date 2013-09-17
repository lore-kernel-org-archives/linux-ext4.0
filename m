From: Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>
Subject: Re: [PATCH v3 0/2] ext4: increase mbcache scalability
Date: Tue, 17 Sep 2013 10:43:58 -0600
Message-ID: <523886CE.2070203@hp.com>
References: <5229C939.8030108@hp.com> <62D71A85-C7EE-4F5F-B481-5329F0282044@dilger.ca> <20130910210250.GH29237@thunk.org> <522FDFCC.1070007@redhat.com> <20130911113001.GB13315@thunk.org> <52309F27.8060008@redhat.com> <alpine.DEB.2.02.1309111325270.5862@nftneq.ynat.uz> <5230D739.9010109@redhat.com> <20130911212523.GE13397@thunk.org> <5230D450.7000609@hp.com> <20130912122317.GC12918@thunk.org> <5232FF3E.7080604@hp.com> <5233609F.7060303@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger@dilger.ca>,
	T Makphaibulchoke <tmac@hp.com>,
	"linux-ext4@vger.kernel.org List" <linux-ext4@vger.kernel.org>,
	aswin@hp.com, aswin_proj@lists.hp.com
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:4803 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125Ab3IQWrI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 17 Sep 2013 18:47:08 -0400
In-Reply-To: <5233609F.7060303@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 09/13/2013 12:59 PM, Eric Sandeen wrote:
> 
> suggestions:
> 
> 1) send us dumpe2fs -h /dev/sdXX | grep "Inode size" for this filesystem
> 2) print out the inode number in your printk's above
> 3) stat one of those inodes in debugfs after the run (debugfs stat <inodenumber>) - with <> around the inode nr
> 
> -Eric
> 

I think I found out why we get into the mbcache path.  The test uses ramfss, which are mounted and unmounted at the start and end of the test.  Looks like a ramfs' default inode size is 128, causing all the mbcaching for the xattrs.  There seems to be nothing wrong with either SELinux or xattr.  Sorry for the confusion.

Thanks,
Mak.

