From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] fix header check in ext4_ext_search_right() for deep
 extent trees.
Date: Mon, 09 Mar 2009 11:13:08 -0500
Message-ID: <49B54014.1030805@redhat.com>
References: <49B18CAB.5020605@redhat.com> <20090309113619.GH5578@mit.edu> <20090309160135.GA30654@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>,
	David Dindorp <ddi@dubex.dk>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:59086 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752873AbZCIQN2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 Mar 2009 12:13:28 -0400
In-Reply-To: <20090309160135.GA30654@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Aneesh Kumar K.V wrote:
> On Mon, Mar 09, 2009 at 07:36:19AM -0400, Theodore Tso wrote:
>> On Fri, Mar 06, 2009 at 02:50:51PM -0600, Eric Sandeen wrote:
>>> This should resolve kernel.org bugzilla 12821
>>>
>>> I've not actually crafted a workload to exercise this code; 
>>> this is from inspection...
>> Hmm, so I've been trying to create a test case, but the test cases
>> I've created (which e2fsck say are fine) aren't causing complaints by
>> the kernel.
>>
>> Please see:
>>
>>        http://master.kernel.org/~tytso/deep-tree/
>>
>> deep-tree.img.gz contains an extent tree of depth 3, and
> 
> With depth 3 we would have path->p_depth = 2 and with middle
> index block would have eh->eh_depth = 1 and depth variable also
> will be having value 1. (also path->p_depth - depth)

>> deep-tree-2.img.gz contains an extent tree of depth 4....
>>

I think this jives w/ what the reporter had, although in the e2image the
problematic inode only had depth 3 (at the time)

for 4 levels, p_depth would be 3, so for

depth		eh_depth	p_depth-depth
0		3		3
1		2		2
2		1		1  <----check got 2, expected 1
3		0		0

he got:

ext4_ext_search_right: bad header in inode #2621457: unexpected eh_depth
- magic f30a, entries 340, max 340(0), depth 1(2)

> So what is the logical block number with which you trying to allocate
> blocks in deep-tree-2.img.gz 

yep that's the key :)

-Eric

> -aneesh

