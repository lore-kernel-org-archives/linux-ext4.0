From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [RFC] Heads up on sys_fallocate()
Date: Mon, 05 Mar 2007 15:41:00 -0600
Message-ID: <45EC8E6C.6040403@redhat.com>
References: <20070117094658.GA17390@amitarora.in.ibm.com> <20070225022326.137b4875.akpm@linux-foundation.org> <20070301183445.GA7911@amitarora.in.ibm.com> <20070301142537.b5950cd7.akpm@linux-foundation.org> <1172788855.26078.294.camel@edge> <20070301145256.3e999932.akpm@linux-foundation.org> <45E86CBA.3070905@us.ibm.com> <20070305122742.GA11486@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Mingming Cao <cmm@us.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>, nscott@aconex.com,
	"Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, suparna@in.ibm.com, alex@clusterfs.com,
	suzuki@in.ibm.com, Ulrich Drepper <drepper@redhat.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:33901 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933646AbXCEVp7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Mar 2007 16:45:59 -0500
In-Reply-To: <20070305122742.GA11486@atrey.karlin.mff.cuni.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Jan Kara wrote:

>> I am wondering if it is useful to add another mode to advise block 
>> allocation policy? Something like indicating which physical block/block 
>> group to allocate from (goal), and whether ask for strict contigous 
>> blocks. This will help preallocation or reservation to choose the right 
>> blocks for the file.
>   Yes, I also think this would be useful so you can "guide"
> preallocation for things like defragmentation (e.g. preallocate space
> for the file being defragmented and move the file to it).

Hints & policies for allocation would certainly be useful, but I think
they belong outside this interface.  i.e. you could flag an inode for
whatever allocation you choose, and -then- call posix_fallocate so that
the allocator will take the hints you've given it.

See also this blurb from the posix_fallocate definition:

"It is implementation-defined whether a previous posix_fadvise() call
influences allocation strategy."

FWIW I don't see a lot of point in asking for "strict contiguous blocks"
- the allocator will presumeably try to do this in any case, and I'm not
sure when you would want to fail if you get more than one extent...?

-Eric
