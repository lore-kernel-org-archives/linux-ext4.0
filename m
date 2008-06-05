From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH -v2] ext4: Use inode preallocation with -o noextents
Date: Thu, 05 Jun 2008 12:24:55 -0600
Message-ID: <20080605182455.GV2961@webber.adilger.int>
References: <1211229262-11012-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <20080604022356.GA7094@mit.edu> <20080604040101.GA22348@skywalker>
 <20080605032220.GC10488@mit.edu> <20080605084329.GB8942@skywalker>
 <1212677741.3645.44.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Theodore Tso <tytso@mit.edu>, sandeen@redhat.com,
	linux-ext4@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:38785 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754089AbYFESZB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Jun 2008 14:25:01 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m55IP1Zc001307
	for <linux-ext4@vger.kernel.org>; Thu, 5 Jun 2008 11:25:01 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K2000F0155QP100@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Thu, 05 Jun 2008 11:25:01 -0700 (PDT)
In-reply-to: <1212677741.3645.44.camel@localhost.localdomain>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jun 05, 2008  07:55 -0700, Mingming Cao wrote:
> >  /**
> > - * ext4_new_blocks_old() -- core block(s) allocation function
> > + * ext4_orlov_new_blocks() -- core block(s) allocation function
> 
> what is orlov means? this is core function for non extent based without
> mballoc block allocation, right? 

Orlov is the name of the INODE allocator, not the block allocator.  I'm
not sure there is a name for the block allocator except "old" or "bitmap".
In the future I suspect we won't want to keep this version at all, using
the mballoc allocator even for block-mapped files, but it is useful for
now for performance comparisons.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

