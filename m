From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH -v2] ext4: Use inode preallocation with -o noextents
Date: Wed, 4 Jun 2008 23:22:20 -0400
Message-ID: <20080605032220.GC10488@mit.edu>
References: <1211229262-11012-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20080604022356.GA7094@mit.edu> <20080604040101.GA22348@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:50803 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751216AbYFEDWr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Jun 2008 23:22:47 -0400
Content-Disposition: inline
In-Reply-To: <20080604040101.GA22348@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

when I moved this patch to the beginning of the unstable patch queue,
it didn't apply.  When I tried to look at it, my head started
spinning.  The patch applied to the wrong function, apparently,
because there is so much code duplication "patch" got confused.  I
can't blame it, though, because *I* got confused.  

fs/ext4/balloc.c is a complete disaster right now.  We have:

ext4_new_blocks_old()
ext4_new_meta_block()
ext4_new_meta_blocks()
ext4_new_blocks()

... and without any comments, it is extremely impenetrable.  Someone
needs to document what the heck all of the various functions have to
do with each other, when they get used (i.e., with which mount options). 

Why aren't we factoring out the last three into a single function?  
    
						- Ted
