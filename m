From: Alex Tomas <bzzz@sun.com>
Subject: Re: Potential bug in mballoc --- reusing data blocks before txn	commit
Date: Tue, 30 Sep 2008 08:35:21 +0400
Message-ID: <48E1AC89.6050803@sun.com>
References: <E1KjlCM-0002L7-SO@closure.thunk.org> <48E138B2.8080707@sun.com>
 <20080929205712.GH10831@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=ISO-8859-1
Content-Transfer-Encoding: 7BIT
Cc: Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gmp-eb-inf-1.sun.com ([192.18.6.21]:46407 "EHLO
	gmp-eb-inf-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbYI3Efj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 30 Sep 2008 00:35:39 -0400
Received: from fe-emea-09.sun.com (gmp-eb-lb-2-fe2.eu.sun.com [192.18.6.11])
	by gmp-eb-inf-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m8U4Zb2a024481
	for <linux-ext4@vger.kernel.org>; Tue, 30 Sep 2008 04:35:38 GMT
Received: from conversion-daemon.fe-emea-09.sun.com by fe-emea-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K7Z00G01R613H00@fe-emea-09.sun.com> (original mail from bzzz@sun.com)
 for linux-ext4@vger.kernel.org; Tue, 30 Sep 2008 05:35:37 +0100 (BST)
In-reply-to: <20080929205712.GH10831@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> Yeah, I know Andrian Bunk strikes again....  but the right answer is
> to ressurect that code and add it back.

indeed

> Well, we need to keep this information for the SSD Trim command
> anyway; so probably the right approach is to keep a red/black tree of
> extents that need to be freed, and then when the commit callback is
> called, we can update the appropriate mballoc data structures and call
> the SSD trim command if necessary.

why we need a tree? at least for the purpose of keeping blocks unavailable
we'd need just a list as at commit we free them all.

> The other thing which I should check is that if we are using this
> scheme, I think we shouldn't need to keep the shadow copy of the block
> bitmap buffers any more.  I would imagine we still need them for the
> inode bitmaps, for the same reason, though.

shadow copy holds preallocated blocks

thanks, Alex

