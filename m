From: Theodore Tso <tytso@mit.edu>
Subject: Re: Potential bug in mballoc --- reusing data blocks before txn
	commit
Date: Tue, 30 Sep 2008 10:15:59 -0400
Message-ID: <20080930141559.GO10831@mit.edu>
References: <E1KjlCM-0002L7-SO@closure.thunk.org> <48E138B2.8080707@sun.com> <20080929205712.GH10831@mit.edu> <48E1AC89.6050803@sun.com> <20080930130247.GM10831@mit.edu> <48E225AC.9090208@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org
To: Alex Tomas <bzzz@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:47906 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751927AbYI3OQD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 30 Sep 2008 10:16:03 -0400
Content-Disposition: inline
In-Reply-To: <48E225AC.9090208@sun.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 30, 2008 at 05:12:12PM +0400, Alex Tomas wrote:
>> For ext4, the only reason to use a tree would be to allow us to merge
>> deleted extents.  This might not be worth the complexity, though, I
>> admit it.
>
> strictly speaking, extents code should have merged them at allocation time.

Sorry, I wasn't being clear enough.  I was thinking of the scenario
where the user runs "rm -r" and deletes a directory hierarchy with
lots of small files.  So the merging I was talking about was between
blocks belonging to different files, so we can send a single large
"trim" command to the disk.  And since we can delete a large number of
files in 5 seconds with "rm -r", and the blocks will likely be very
close together if the allocator is doing a good job and the filesystem
is relatively unfragmented, it would also save memory if we can merge
extents belonging to different files instead of keeping them
separately on the linked list.

> oops. I meant in-core bitmap mballoc generates. if there is intention
> to get rid of old allocator (balloc.c), then we don't need b_committed_data.

Yes, I sent a patch on Sunday night proposing to do exactly that, as a
way of simplifying the code and reducing the test matrix for ext4.

> btw, I've just remembered why I decided don't protect data from reallocation:
> in data=writeback one can get block with stale data easily. and many people
> (to my knowledge) were using data=writeback as performing better.

Well, data=ordered is the default, so there would be many more people
using data=ordered.  If we think there is a significant advantage in
not protecting data from reallocation besides the memory utilization,
I suppose we could make protecting data being conditional on
data=writeback.  Perhaps having the additional data blocks available
to the block allocator could allow it to make better decisions.  Not
sure it's worth it, though.   Any thoughts?

							- Ted
