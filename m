From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/4] ext4: fix reserved space transferring on chown()
 [V2]
Date: Mon, 7 Dec 2009 22:48:35 +0530
Message-ID: <20091207171835.GB16078@skywalker.linux.vnet.ibm.com>
References: <1259132261-16785-1-git-send-email-dmonakhov@openvz.org>
 <1259132261-16785-2-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:40166 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964834AbZLGRSg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Dec 2009 12:18:36 -0500
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.31.245])
	by e23smtp08.au.ibm.com (8.14.3/8.13.1) with ESMTP id nB84IfWO024405
	for <linux-ext4@vger.kernel.org>; Tue, 8 Dec 2009 15:18:41 +1100
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id nB7HIfTc1552472
	for <linux-ext4@vger.kernel.org>; Tue, 8 Dec 2009 04:18:41 +1100
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id nB7HIfjo030897
	for <linux-ext4@vger.kernel.org>; Tue, 8 Dec 2009 04:18:41 +1100
Content-Disposition: inline
In-Reply-To: <1259132261-16785-2-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 25, 2009 at 09:57:39AM +0300, Dmitry Monakhov wrote:
> Currently all quota's functions except vfs_dq_reserve_block()
> called without i_block_reservation_lock. This result in
> ext4_reservation vs quota_reservation inconsistency which provoke
> incorrect reservation transfer ==> incorrect quota after transfer.
> 
> Race (1)
> | Task 1 (chown)                 | Task 2 (truncate)                    |
> | dquot_transfer                 |                                      |
> | ->down_write(dqptr_sem)        | ext4_da_release_spac                 |
> | -->dquot_get_reserved_space    | ->lock(i_block_reservation_lock)     |
> | --->get_reserved_space         | /* decrement reservation */          |
> | ---->ext4_get_reserved_space   | ->unlock(i_block_reservation_lock)   |
> | ----->lock(i_block_rsv_lock)   | /* During this time window           |
> | /* Read ext4_rsv from inode */ | * fs's reservation not equals        |
> | /* transfer it to new quota */ | * to quota's */                      |
> | ->up_write(dqptr_sem)          | ->vfs_dq_release_reservation_block() |
> |                                | /* quota_rsv goes negative here */   |
> |                                |                                      |
> 
> Race (2)
> | Task 1 (chown)                | Task 2 (flush-8:16)             |
> | dquot_transfer()              | ext4_mb_mark_diskspace_used()   |
> | ->down_write(dqptr_sem)       | ->vfs_dq_claim_block()          |
> | --->get_reserved_space()      | /* After this moment         */ |
> | --->ext4_get_reserved_space() | /* ext4_rsv != quota_ino_rsv */ |
> | /* Read rsv from inode which  |                                 |
> | ->dquot_free_reserved_space() |                                 |
> | /* quota_rsv goes negative */ |                                 |
> |                               |                                 |
> |                               | dquot_free_reserved_space()     |
> |                               | /* finally dec ext4_ino_rsv */  |
> 
> So, in order to protect us from this type of races we always have to
> provides ext4_ino_rsv == quot_ino_rsv guarantee. And this is only
> possible then i_block_reservation_lock is taken before entering any
> quota operations.
> 
> In fact i_block_reservation_lock is held by ext4_da_reserve_space()
> while calling vfs_dq_reserve_block(). Lock are held in following order
> i_block_reservation_lock > dqptr_sem
> 
> This may result in deadlock because of different lock ordering:
> ext4_da_reserve_space()             dquot_transfer()
> lock(i_block_reservation_lock)	     down_write(dqptr_sem)
>   down_write(dqptr_sem)		     lock(i_block_reservation_lock)
> 
> But this not happen only because both callers must have i_mutex so
> serialization happens on i_mutex.


But that down_write can sleep right ? 

For example:
http://bugzilla.kernel.org/show_bug.cgi?id=14739

-aneesh
