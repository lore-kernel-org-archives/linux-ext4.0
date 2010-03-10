From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15420] EXT4_USE_FOR_EXT23 causes wrong free space calculation
 on ext2 and ext3
Date: Wed, 10 Mar 2010 12:25:31 GMT
Message-ID: <201003101225.o2ACPVkg024848@demeter.kernel.org>
References: <bug-15420-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:38118 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090Ab0CJMZc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Mar 2010 07:25:32 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o2ACPViq024849
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 10 Mar 2010 12:25:31 GMT
In-Reply-To: <bug-15420-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=15420





--- Comment #6 from Jan Kara <jack@suse.cz>  2010-03-10 12:25:21 ---
> http://bugzilla.kernel.org/show_bug.cgi?id=15420
> 
> 
> Theodore Tso <tytso@mit.edu> changed:
> 
>            What    |Removed                     |Added
> ----------------------------------------------------------------------------
>                  CC|                            |tytso@mit.edu
> 
> 
> 
> 
> --- Comment #5 from Theodore Tso <tytso@mit.edu>  2010-03-10 03:12:30 ---
> This sounds like the block reservation code for delayed allocation is
> over-aggressive about estimating how many blocks are need for the indirect
> blocks in the case of indirect-mapped inodes (which would be what you get when
> mounting an ext2 filesystem using the ext4 file system driver).
> 
> This should be an aesthetic issue only, but it would be nice to have this be
> fixed.
  Since bugzilla seems to be down now, I'll reply by email:
Won't it make sence to use 'nodelalloc' by default when ext4 driver is used
for ext2 or ext3 filesystem? Because delayed allocation has some implications
people need not expect - like the overestimation of needed blocks, or changed
semantics of ordered data mode etc...
  So something like the patch below?

                                    Honza

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
