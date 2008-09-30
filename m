From: Alex Tomas <bzzz@sun.com>
Subject: Re: Potential bug in mballoc --- reusing data blocks before txn	commit
Date: Tue, 30 Sep 2008 17:12:12 +0400
Message-ID: <48E225AC.9090208@sun.com>
References: <E1KjlCM-0002L7-SO@closure.thunk.org> <48E138B2.8080707@sun.com>
 <20080929205712.GH10831@mit.edu> <48E1AC89.6050803@sun.com>
 <20080930130247.GM10831@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=ISO-8859-1
Content-Transfer-Encoding: 7BIT
Cc: Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gmp-eb-inf-2.sun.com ([192.18.6.24]:46062 "EHLO
	gmp-eb-inf-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712AbYI3NMe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 30 Sep 2008 09:12:34 -0400
Received: from fe-emea-10.sun.com (gmp-eb-lb-2-fe3.eu.sun.com [192.18.6.12])
	by gmp-eb-inf-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m8UDCWdT028536
	for <linux-ext4@vger.kernel.org>; Tue, 30 Sep 2008 13:12:32 GMT
Received: from conversion-daemon.fe-emea-10.sun.com by fe-emea-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K8000H01EW70900@fe-emea-10.sun.com> (original mail from bzzz@sun.com)
 for linux-ext4@vger.kernel.org; Tue, 30 Sep 2008 14:12:32 +0100 (BST)
In-reply-to: <20080930130247.GM10831@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Tue, Sep 30, 2008 at 08:35:21AM +0400, Alex Tomas wrote:
>> why we need a tree? at least for the purpose of keeping blocks unavailable
>> we'd need just a list as at commit we free them all.
> 
> For ext4, the only reason to use a tree would be to allow us to merge
> deleted extents.  This might not be worth the complexity, though, I
> admit it.

strictly speaking, extents code should have merged them at allocation time.

>>> The other thing which I should check is that if we are using this
>>> scheme, I think we shouldn't need to keep the shadow copy of the block
>>> bitmap buffers any more.  I would imagine we still need them for the
>>> inode bitmaps, for the same reason, though.
>> shadow copy holds preallocated blocks
> 
> Are we talking about the same thing?  I was referring to the
> jh->b_committed_data, which isn't used by mballoc at all.

oops. I meant in-core bitmap mballoc generates. if there is intention
to get rid of old allocator (balloc.c), then we don't need b_committed_data.

btw, I've just remembered why I decided don't protect data from reallocation:
in data=writeback one can get block with stale data easily. and many people
(to my knowledge) were using data=writeback as performing better.

thanks, Alex

