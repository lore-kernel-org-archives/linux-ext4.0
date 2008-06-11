From: Shen Feng <shen@cn.fujitsu.com>
Subject: Re: [PATCH -v2] ext4: Use inode preallocation with -o noextents
Date: Wed, 11 Jun 2008 11:44:12 +0800
Message-ID: <484F4A0C.1080801@cn.fujitsu.com>
References: <1211229262-11012-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>	 <20080604022356.GA7094@mit.edu> <20080604040101.GA22348@skywalker>	 <20080605032220.GC10488@mit.edu>  <20080605084329.GB8942@skywalker> <1212677741.3645.44.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Theodore Tso <tytso@mit.edu>, sandeen@redhat.com,
	linux-ext4@vger.kernel.org
To: cmm@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:57280 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755336AbYFKDrs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Jun 2008 23:47:48 -0400
In-Reply-To: <1212677741.3645.44.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



Mingming Cao Wrote:
> On Thu, 2008-06-05 at 14:13 +0530, Aneesh Kumar K.V wrote:
>> On Wed, Jun 04, 2008 at 11:22:20PM -0400, Theodore Tso wrote:
>>> when I moved this patch to the beginning of the unstable patch queue,
>>> it didn't apply.  When I tried to look at it, my head started
>>> spinning.  The patch applied to the wrong function, apparently,
>>> because there is so much code duplication "patch" got confused.  I
>>> can't blame it, though, because *I* got confused.  
>>>
>>> fs/ext4/balloc.c is a complete disaster right now.  We have:
>>>
>>> ext4_new_blocks_old()
>>> ext4_new_meta_block()
>>> ext4_new_meta_blocks()
>>> ext4_new_blocks()
>>>
>>> ... and without any comments, it is extremely impenetrable.  Someone
>>> needs to document what the heck all of the various functions have to
>>> do with each other, when they get used (i.e., with which mount options). 
>>>
> 
> One more thing, I feel we should clean up inode.c, move the functions
> related to non extent file allocation from inode.c into balloc.c, and
> try to keep balloc.c the single file to handle allocation for non extent
> files. 
> 

I don't agree this.
balloc.c is for non mballoc allocation, not for non extent files.
Maybe we need a noextent.c for non extent file allocation, now it's done
in inode.c.

-Shen Feng
