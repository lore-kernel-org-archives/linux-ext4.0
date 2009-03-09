From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] fix header check in ext4_ext_search_right() for deep
 extent trees.
Date: Mon, 09 Mar 2009 10:53:10 -0500
Message-ID: <49B53B66.50806@redhat.com>
References: <49B18CAB.5020605@redhat.com> <20090309113619.GH5578@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	David Dindorp <ddi@dubex.dk>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:47247 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752548AbZCIPx1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 Mar 2009 11:53:27 -0400
In-Reply-To: <20090309113619.GH5578@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Fri, Mar 06, 2009 at 02:50:51PM -0600, Eric Sandeen wrote:
>> This should resolve kernel.org bugzilla 12821
>>
>> I've not actually crafted a workload to exercise this code; 
>> this is from inspection...
> 
> Hmm, so I've been trying to create a test case, but the test cases
> I've created (which e2fsck say are fine) aren't causing complaints by
> the kernel.
> 
> Please see:
> 
>        http://master.kernel.org/~tytso/deep-tree/
> 
> deep-tree.img.gz contains an extent tree of depth 3, and
> deep-tree-2.img.gz contains an extent tree of depth 4....
> 
> 		   	       	      - Ted

I've had no trouble creating a deep tree, but I have had trouble making
it actually exercise the code in that loop.

I think the initial ext4_ext_find_extent() needs to land us in just the
right place such that the search_right must traverse back up & back down
the tree to get the nearest right allocation... I haven't sorted that
out yet.

I'd feel better w/ a testcase to demonstrate correctness too, but I'm
99.9% sure that the fix is correct by inspection, and would rather see
it get into .29 sooner than later unless you have strong misgivings.

-Eric
