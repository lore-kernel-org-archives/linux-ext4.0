From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [Bug 14739] BUG: scheduling while atomic: nfsd/3369/0x00000002
Date: Mon, 7 Dec 2009 22:39:33 +0530
Message-ID: <20091207170933.GA16078@skywalker.linux.vnet.ibm.com>
References: <bug-14739-13602@http.bugzilla.kernel.org/>
 <200912051728.nB5HSDVn018680@demeter.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Mingming <cmm@us.ibm.com>
To: bugzilla-daemon@bugzilla.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:44404 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758120AbZLGRJc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Dec 2009 12:09:32 -0500
Received: from d28relay05.in.ibm.com (d28relay05.in.ibm.com [9.184.220.62])
	by e28smtp09.in.ibm.com (8.14.3/8.13.1) with ESMTP id nB7GlR2k005153
	for <linux-ext4@vger.kernel.org>; Mon, 7 Dec 2009 22:17:27 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay05.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id nB7H9buS3297500
	for <linux-ext4@vger.kernel.org>; Mon, 7 Dec 2009 22:39:37 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id nB7H9bxN027842
	for <linux-ext4@vger.kernel.org>; Mon, 7 Dec 2009 22:39:37 +0530
Content-Disposition: inline
In-Reply-To: <200912051728.nB5HSDVn018680@demeter.kernel.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Dec 05, 2009 at 05:28:13PM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
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
