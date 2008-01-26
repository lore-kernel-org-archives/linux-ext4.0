From: Bryan Henderson <hbryan@us.ibm.com>
Subject: Re: [RFC] Parallelize IO for e2fsck
Date: Fri, 25 Jan 2008 17:55:51 -0800
Message-ID: <OF9B297CB7.4B613CFE-ON882573DC.00092EE4-882573DC.000A9B77@us.ibm.com>
References: <alpine.LSU.0.999.0801252338460.26260@be1.lrz>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Cc: Bodo Eggert <7eggert@gmx.de>, Andreas Dilger <adilger@sun.com>,
	Andreas Dilger <adilger@clusterfs.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Adrian Bunk <bunk@kernel.org>, David Chinner <dgc@sgi.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, Ric Wheeler <ric@emc.com>,
	Theodore Tso <tytso@MIT.EDU>,
	Valerie Henson <val@vahconsulting.com>, Valdis.Kletnieks@vt.edu
To: Bodo Eggert <7eggert@gmx.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:55569 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755438AbYAZB4Y (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Jan 2008 20:56:24 -0500
In-Reply-To: <alpine.LSU.0.999.0801252338460.26260@be1.lrz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>> Incidentally, some context for the AIX approach to the OOM problem: a 
>> process may exclude itself from OOM vulnerability altogether.  It 
places 
>> itself in "early allocation" mode, which means at the time it creates 
>> virtual memory, it reserves enough backing store for the worst case. 
The 
>> memory manager does not send such a process the SIGDANGER signal or 
>> terminate it when it runs out of paging space.  Before c. 2000, this 
was 
>> the only mode.  Now the default is late allocation mode, which is 
similar 
>> to Linux.
>
>This is an interesting approach. It feels like some programs might be 
>interested in choosing this mode instead of risking OOM. 

It's the way virtual memory always worked when it was first invented.  The 
system not only reserved space to back every page of virtual memory; it 
assigned the particular blocks for it.  Late allocation was a later 
innovation, and I believe its main goal was to make it possible to use the 
cheaper disk drives for paging instead of drums.  Late allocation gives 
you better locality on disk, so the seeking doesn't eat you alive (drums 
don't seek).  Even then, I assume (but am not sure) that the system at 
least reserved the space in an account somewhere so at pageout time there 
was guaranteed to be a place to which to page out.  Overcommitting page 
space to save on disk space was a later idea.

I was surprised to see AIX do late allocation by default, because IBM's 
traditional style is bulletproof systems.  A system where a process can be 
killed at unpredictable times because of resource demands of unrelated 
processes doesn't really fit that style.

It's really a fairly unusual application that benefits from late 
allocation: one that creates a lot more virtual memory than it ever 
touches.  For example, a sparse array.  Or am I missing something?

--
Bryan Henderson                     IBM Almaden Research Center
San Jose CA                         Filesystems
