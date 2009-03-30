From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: remove /proc tuning knobs
Date: Mon, 30 Mar 2009 15:41:37 +0530
Message-ID: <20090330101137.GC4796@skywalker>
References: <1235879288-26201-1-git-send-email-tytso@mit.edu> <1235879288-26201-2-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:45245 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756741AbZC3KLn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Mar 2009 06:11:43 -0400
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28smtp02.in.ibm.com (8.13.1/8.13.1) with ESMTP id n2UABdbL004740
	for <linux-ext4@vger.kernel.org>; Mon, 30 Mar 2009 15:41:39 +0530
Received: from d28av03.in.ibm.com (d28av03.in.ibm.com [9.184.220.65])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n2UA81PM4305022
	for <linux-ext4@vger.kernel.org>; Mon, 30 Mar 2009 15:38:01 +0530
Received: from d28av03.in.ibm.com (loopback [127.0.0.1])
	by d28av03.in.ibm.com (8.13.1/8.13.3) with ESMTP id n2UABdmx032191
	for <linux-ext4@vger.kernel.org>; Mon, 30 Mar 2009 21:11:39 +1100
Content-Disposition: inline
In-Reply-To: <1235879288-26201-2-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Feb 28, 2009 at 10:48:08PM -0500, Theodore Ts'o wrote:
> Remove tuning knobs in /proc/fs/ext4/<dev/* since they have been
> replaced by knobs in sysfs at /sys/fs/ext4/<dev>/*.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  fs/ext4/ext4.h    |   16 -------
>  fs/ext4/inode.c   |    7 +---
>  fs/ext4/mballoc.c |  117 +++++++++++++----------------------------------------
>  fs/ext4/super.c   |   46 ---------------------
>  4 files changed, 30 insertions(+), 156 deletions(-)
> 

This patch would need changes to Documentation/filesystems/proc.txt


-aneesh
