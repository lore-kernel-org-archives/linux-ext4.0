From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/5] fallocate() implementation in i86, x86_64 and powerpc
Date: Wed, 9 May 2007 21:31:02 +0530
Message-ID: <20070509160102.GA30745@amitarora.in.ibm.com>
References: <20070329115126.GB7374@amitarora.in.ibm.com> <20070329101010.7a2b8783.akpm@linux-foundation.org> <20070330071417.GI355@devserv.devel.redhat.com> <20070417125514.GA7574@amitarora.in.ibm.com> <20070418130600.GW5967@schatzie.adilger.int> <20070420135146.GA21352@amitarora.in.ibm.com> <20070420145918.GY355@devserv.devel.redhat.com> <20070424121632.GA10136@amitarora.in.ibm.com> <20070426175056.GA25321@amitarora.in.ibm.com> <20070426180332.GA7209@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com,
	cmm@us.ibm.com
To: torvalds@osdl.org, akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:42088 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125AbXEIQBT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 May 2007 12:01:19 -0400
Content-Disposition: inline
In-Reply-To: <20070426180332.GA7209@amitarora.in.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

I have the updated patches ready which take care of Andrew's comments.
Will run some tests and post them soon.

But, before submitting these patches, I think it will be better to finalize
on certain things which might be worth some discussion here:

1) Should the file size change when preallocation is done beyond EOF ?
   - Andreas and Chris Wedgwood are in favor of not changing the
     file size in this case. I also tend to agree with them. Does anyone
     has an argument in favor of changing the filesize ?
     If not, I will remove the code which changes the filesize, before I
     resubmit the concerned ext4 patch.

2) For FA_UNALLOCATE mode, should the file system allow unallocation
   of normal (non-preallocated) blocks (blocks allocated via
   regular write/truncate operations) also (i.e. work as punch()) ?
   - Though FA_UNALLOCATE mode is yet to be implemented on ext4, still
     we need to finalize on the convention here as a general guideline
     to all the filesystems that implement fallocate.

3) If above is true, the file size will need to be changed
   for "unallocation" when block holding the EOF gets unallocated.
   - If we do not "unallocate" normal (non-preallocated) blocks and we
     do not change the file size on preallocation, then this is a
     non-issue.

4) Should we update mtime & ctime on a successfull allocation/
   unallocation ?
   - David Chinner raised this question in following post:
     http://lkml.org/lkml/2007/4/29/407
     I think it makes sense to update the [mc]time for a successfull
     preallocation/unallocation. Does anyone feel otherwise ?
     It will be interesting to know how XFS behaves currently. Does XFS
     update [mc]time for preallocation ?


--
Regards,
Amit Arora
