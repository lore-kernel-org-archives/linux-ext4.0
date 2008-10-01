From: Andreas Dilger <adilger@sun.com>
Subject: Re: Potential bug in mballoc --- reusing data blocks before txn	commit
Date: Wed, 01 Oct 2008 00:17:03 -0700
Message-ID: <20081001071703.GH3160@webber.adilger.int>
References: <E1KjlCM-0002L7-SO@closure.thunk.org> <48E138B2.8080707@sun.com>
 <20080929205712.GH10831@mit.edu> <48E1AC89.6050803@sun.com>
 <20080930130247.GM10831@mit.edu> <48E225AC.9090208@sun.com>
 <20080930141559.GO10831@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Alex Tomas <bzzz@sun.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:41219 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbYJAHRP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Oct 2008 03:17:15 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m917HFIi007073
	for <linux-ext4@vger.kernel.org>; Wed, 1 Oct 2008 00:17:15 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K8100201THQ5G00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Wed, 01 Oct 2008 00:17:15 -0700 (PDT)
In-reply-to: <20080930141559.GO10831@mit.edu>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> Yeah, I know Andrian Bunk strikes again....  but the right answer is
> to ressurect that code and add it back.

I submitted our patch to re-add this support yesterday.

On Sep 30, 2008  10:15 -0400, Theodore Ts'o wrote:
> On Tue, Sep 30, 2008 at 05:12:12PM +0400, Alex Tomas wrote:
> >> For ext4, the only reason to use a tree would be to allow us to merge
> >> deleted extents.  This might not be worth the complexity, though, I
> >> admit it.
> >
> > strictly speaking, extents code should have merged them at allocation time.
> 
> Sorry, I wasn't being clear enough.  I was thinking of the scenario
> where the user runs "rm -r" and deletes a directory hierarchy with
> lots of small files.  So the merging I was talking about was between
> blocks belonging to different files, so we can send a single large
> "trim" command to the disk.

I agree that this is probably most efficient.  There would be an rbtree
per transaction, and would mostly be sparse.

> > btw, I've just remembered why I decided don't protect data from reallocation:
> > in data=writeback one can get block with stale data easily. and many people
> > (to my knowledge) were using data=writeback as performing better.
> 
> Well, data=ordered is the default, so there would be many more people
> using data=ordered.  If we think there is a significant advantage in
> not protecting data from reallocation besides the memory utilization,
> I suppose we could make protecting data being conditional on
> data=writeback.  Perhaps having the additional data blocks available
> to the block allocator could allow it to make better decisions.  Not
> sure it's worth it, though.   Any thoughts?

I think for minimum complexity we should keep the rbtree all the time.
We would need it for the TRIM support in any case.

Having it enabled for ordered mode is fairly important, and I didn't
know that this little surprise was in the mballoc code at all.  It may
explain some rare problems we've seen in the past.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

