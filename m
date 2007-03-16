From: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: Ext4 devel interlock meeting minutes (March 14, 2007)
Date: Fri, 16 Mar 2007 09:31:35 -0700
Message-ID: <20070316093135.174b4b69.rdunlap@xenotime.net>
References: <45F87C03.506@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Avantika Mathur <mathur@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:53279 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933161AbXCPQbQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Mar 2007 12:31:16 -0400
Received: from midway.site ([71.245.96.31]) by xenotime.net for <linux-ext4@vger.kernel.org>; Fri, 16 Mar 2007 09:31:15 -0700
In-Reply-To: <45F87C03.506@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 14 Mar 2007 15:49:39 -0700 Avantika Mathur wrote:

> Ext4 Developer Interlock Call: 03/14/2007 Meeting Minutes
> 
> Attendees: Mingming Cao, Eric Sandeen, Ted Ts'o, Dave Kleikamp, Suparna Bhattacharya, Takashi Sato, Avantika Mathur
> 
> Minutes can be accessed at: http://ext4.wiki.kernel.org/index.php/Ext4_Developer%27s_Conference_Call 
> 
> 
> Ext4 git Tree:
> 
> - Shaggy and Eric fixed the recent problems with the nanosecond timestamps in the git tree
> 
> - There is a general problem that the git tree is not updated frequently
> 
> 	- Ted feels there is not enough testing done to feel comfortable updating to a new release
> 
>         -- Many of the patches added to the tree are not tested properly.  
> 	-- It would be helpful if people could pick up the tree and test it, and make sure all upstream merging criteria is met by ext4 developers.
> 
>     - Currently looking at methods of automating testing of each new git tree release on different architectures and benchmarks.
> 
>     - Slow code review is also slowing down ext4.
> 
> - Ted suggested maintaining a git tree that tracks the patch queue, so there can be multiple people working on the patch queue. 
> 	- When patches are stable, update the central git tree that can then be pushed upstream.
> 
> - Ted will start a second git tree, and initially put Shaggy and Mingming as additional users who can access the tree. 

Hi,
What's the purpose of this second git tree, please?

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
