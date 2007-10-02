From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Ext4 devel interlock meeting minutes (October 1, 2007)
Date: Tue, 02 Oct 2007 09:23:38 -0500
Message-ID: <4702546A.1050802@redhat.com>
References: <47017053.9060005@linux.vnet.ibm.com> <20071002055831.GH5702@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Avantika Mathur <mathur@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:33353 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752129AbXJBOXu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Oct 2007 10:23:50 -0400
In-Reply-To: <20071002055831.GH5702@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Andreas Dilger wrote:
> On Oct 01, 2007  15:10 -0700, Avantika Mathur wrote:
>> Delayed Allocation:
>> - There has been an lkml thread about these patches.
>> - We have and approach that works for ext4, implemented at the vfs 
>> level, but unless we can prove it can work for other filesystems, it 
>> will not be accepted.  
>> - Christoph Hellwig has commented that these patches will not work for 
>> XFS.  
> 
> Hmm, but I thought that Christoph also agreed that it would be OK to
> get the ext4 delalloc code merged separately, so long as it doesn't
> need big/any changes to the VFS to implement it.  It might be that the
> ext4 and XFS code is different enough that they cannot share the
> delayed allocation code.

IIRC there is only one change to the VFS, a test for buffer_delay() in
__block_write_full_page().  XFS is the only current caller of
set_buffer_delay, and XFS does not even use the block_write_full_page path.

The rest was a huge chunk dropped into mpage.c, but not interfering with
anything else.

So, I don't see any conflict.

-Eric
