From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Sat, 31 Oct 2009 15:26:12 GMT
Message-ID: <200910311526.n9VFQCqY016454@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:47830 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757866AbZJaP0I (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 31 Oct 2009 11:26:08 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9VFQC8x016456
	for <linux-ext4@vger.kernel.org>; Sat, 31 Oct 2009 15:26:12 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #162 from Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>  2009-10-31 15:26:01 ---
On Sat, Oct 31, 2009 at 05:15:28AM -0400, Theodore Tso wrote:
> On Fri, Oct 30, 2009 at 01:56:27PM -0600, Andreas Dilger wrote:
> > I wonder if there are multiple problems involved here?  Eric, it seems
> > possible that your reproducer is exercising a similar, though unrelated
> > codepath.  
> 
> Note that Aneesh has pubished two patches which insert a call to
> ext4_discard_preallocations().  One is a patch which inserts it into
> fs/inode.c's truncate path (for direct/indirect-mapped inodes) and one
> which is patch which inserts it into fs/extents.c truncate path (for
> extent-mapped inodes).  As near as I can tell both patches are
> necessary, and it looks to me like they should be combined into a
> single patch, since commit 487caeef9 affects both truncate paths.
> Aneesh, do you concur?
> 

We need only the patch that drop prealloc space in ext4_truncate_restart_trans
ext4_ext_truncate_extend_restart calls ext4_truncate_restart_trans. So adding
the prealloc space dropping in ext4_truncate_restart_trans should handle both
direct/indirect-mapped inode and extent-mapped inodes.

-aneesh

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
