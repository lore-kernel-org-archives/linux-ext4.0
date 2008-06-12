From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH -v2] ext4: Use inode preallocation with -o noextents
Date: Thu, 12 Jun 2008 03:34:31 -0600
Message-ID: <20080612093431.GZ3726@webber.adilger.int>
References: <1211229262-11012-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <20080604022356.GA7094@mit.edu> <20080604040101.GA22348@skywalker>
 <20080605032220.GC10488@mit.edu> <20080605084329.GB8942@skywalker>
 <1212677741.3645.44.camel@localhost.localdomain>
 <20080605182455.GV2961@webber.adilger.int> <484F45C9.3030804@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Mingming Cao <cmm@us.ibm.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Theodore Tso <tytso@mit.edu>, sandeen@redhat.com,
	linux-ext4@vger.kernel.org
To: Shen Feng <shen@cn.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:49443 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbYFLJef (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Jun 2008 05:34:35 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m5C9YXxm021429
	for <linux-ext4@vger.kernel.org>; Thu, 12 Jun 2008 02:34:33 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K2C00101FWV7600@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Thu, 12 Jun 2008 02:34:33 -0700 (PDT)
In-reply-to: <484F45C9.3030804@cn.fujitsu.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jun 11, 2008  11:26 +0800, Shen Feng wrote:
> Andreas Dilger Wrote:
> > On Jun 05, 2008  07:55 -0700, Mingming Cao wrote:
> >>>  /**
> >>> - * ext4_new_blocks_old() -- core block(s) allocation function
> >>> + * ext4_orlov_new_blocks() -- core block(s) allocation function
> >> what is orlov means? this is core function for non extent based without
> >> mballoc block allocation, right? 
> > 
> > Orlov is the name of the INODE allocator, not the block allocator.  I'm
> > not sure there is a name for the block allocator except "old" or "bitmap".
> > In the future I suspect we won't want to keep this version at all, using
> > the mballoc allocator even for block-mapped files, but it is useful for
> > now for performance comparisons.
> > 
> 
> Is that true?
> 
> I got the following from the kernel ext4 documentation.
> orlov		(*)	This enables the new Orlov block allocator. It is
> 			enabled by default.
> 
> oldalloc		This disables the Orlov block allocator and enables
> 			the old block allocator.  Orlov should have better
> 			performance - we'd like to get some feedback if it's
> 			the contrary for you.

The documentation is incorrect then.  The Orlov allocator is for inodes:

ialloc.c:
/*
 * Orlov's allocator for directories.
 
struct inode *ext3_new_inode(handle_t *handle, struct inode * dir, int mode)
{
        if (S_ISDIR(mode)) {
		if (test_opt (sb, OLDALLOC))
			group = find_group_dir(sb, dir);
		else
			group = find_group_orlov(sb, dir);


Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

