From: Avantika Mathur <mathur@linux.vnet.ibm.com>
Subject: Ext4 devel interlock meeting minutes (March 14, 2007)
Date: Wed, 14 Mar 2007 15:49:39 -0700
Message-ID: <45F87C03.506@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:36973 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753315AbXCNWtk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 14 Mar 2007 18:49:40 -0400
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e32.co.us.ibm.com (8.12.11.20060308/8.13.8) with ESMTP id l2EMm9ug021858
	for <linux-ext4@vger.kernel.org>; Wed, 14 Mar 2007 18:48:09 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by westrelay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l2EMneB6062794
	for <linux-ext4@vger.kernel.org>; Wed, 14 Mar 2007 16:49:40 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l2EMnd7S016249
	for <linux-ext4@vger.kernel.org>; Wed, 14 Mar 2007 16:49:39 -0600
Received: from [9.47.16.74] (IBM-DD6E2EC41B8.beaverton.ibm.com [9.47.16.74])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l2EMndx8016231
	for <linux-ext4@vger.kernel.org>; Wed, 14 Mar 2007 16:49:39 -0600
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Ext4 Developer Interlock Call: 03/14/2007 Meeting Minutes

Attendees: Mingming Cao, Eric Sandeen, Ted Ts'o, Dave Kleikamp, Suparna Bhattacharya, Takashi Sato, Avantika Mathur

Minutes can be accessed at: http://ext4.wiki.kernel.org/index.php/Ext4_Developer%27s_Conference_Call 


Ext4 git Tree:

- Shaggy and Eric fixed the recent problems with the nanosecond timestamps in the git tree

- There is a general problem that the git tree is not updated frequently

	- Ted feels there is not enough testing done to feel comfortable updating to a new release

        -- Many of the patches added to the tree are not tested properly.  
	-- It would be helpful if people could pick up the tree and test it, and make sure all upstream merging criteria is met by ext4 developers.

    - Currently looking at methods of automating testing of each new git tree release on different architectures and benchmarks.

    - Slow code review is also slowing down ext4.

- Ted suggested maintaining a git tree that tracks the patch queue, so there can be multiple people working on the patch queue. 
	- When patches are stable, update the central git tree that can then be pushed upstream.

- Ted will start a second git tree, and initially put Shaggy and Mingming as additional users who can access the tree. 


OLS:

- The Ext4 OLS Paper was accepted.

- Avantika presented the basic outline for the paper, Suparna had comments on the layout

	- Rather than grouping features based on time (when they are going to be included), group them based on classification, 
		- i.e. scalability, block placement, new features.

	- This way the paper can be used as a reference for people who want to learn about ext4

- Avantika will update the outline and send out a new version

- In the 2005 OLS ext3 paper, benchmarks tio dbench and filemark were used. 
	- Looking into different benchmarks to use in this paper. 
	- Eric suggested looking at CPU utilization test used by David Chinner in his XFS OLS paper last year.


Preallocation:

- Amit has been working on implementing the fallocate systemn call

    - he was struggling with the mode bit and implementation on different architectures.

- Having difficulty in how to order the parameters on s390 architecture

- Suparna will ask Amit to post his current patches, so other can begin reviewing and helping out.


i_version Patches:

- the high 32  bit of the i_version field is still required to support the full 64 bit i_version number NFSv4 requires

- The general consensus on the call was to use the i_extra_isize in the inode for the high 32 bits.

    - This would keep i_version completely separated from ctime
