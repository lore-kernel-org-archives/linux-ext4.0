From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14739] BUG: scheduling while atomic: nfsd/3369/0x00000002
Date: Mon, 7 Dec 2009 17:09:43 GMT
Message-ID: <200912071709.nB7H9hp9031149@demeter.kernel.org>
References: <bug-14739-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:40367 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935434AbZLGRJg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Dec 2009 12:09:36 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nB7H9hf8031150
	for <linux-ext4@vger.kernel.org>; Mon, 7 Dec 2009 17:09:43 GMT
In-Reply-To: <bug-14739-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14739





--- Comment #2 from Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>  2009-12-07 17:09:41 ---
On Sat, Dec 05, 2009 at 05:28:13PM +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=14739
> 
> 
> Trond Myklebust <trond.myklebust@fys.uio.no> changed:
> 
>            What    |Removed                     |Added
> ----------------------------------------------------------------------------
>                  CC|                            |trond.myklebust@fys.uio.no
>           Component|NFS                         |ext4
>          AssignedTo|trond.myklebust@fys.uio.no  |fs_ext4@kernel-bugs.osdl.or
>                    |                            |g
> 
> 
> 
> 
> --- Comment #1 from Trond Myklebust <trond.myklebust@fys.uio.no>  2009-12-05 17:28:12 ---
> Hmm... This looks to me like it is rather an ext4 bug. Reassigning to
> the ext4 folks for the moment.
> 

Hmm we are doing dquot_reserve_space with i_block_reservation_lock held.
ie

spin_lock(&EXT4_I(inode)->i_block_reservation_lock);  
- vfs_dq_reserve_block
  - down_read(&sb_dqopt(inode->i_sb)->dqptr_sem)


Adding Mingming to CC:
-aneesh

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
