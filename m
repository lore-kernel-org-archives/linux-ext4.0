From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: locking typo in ext4_mb_add_n_trim()
Date: Fri, 27 Mar 2009 22:05:17 +0530
Message-ID: <20090327163517.GA2810@skywalker>
References: <Pine.LNX.4.64.0903262204430.4167@usbsys.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, adilger@sun.com, linux-ext4@vger.kernel.org
To: Dan Carpenter <error27@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:56574 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587AbZC0Qfi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 27 Mar 2009 12:35:38 -0400
Received: from d23relay01.au.ibm.com (d23relay01.au.ibm.com [202.81.31.243])
	by e23smtp09.au.ibm.com (8.13.1/8.13.1) with ESMTP id n2RGJ1Pt030607
	for <linux-ext4@vger.kernel.org>; Sat, 28 Mar 2009 03:19:01 +1100
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay01.au.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n2RGZqlL463184
	for <linux-ext4@vger.kernel.org>; Sat, 28 Mar 2009 03:35:52 +1100
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n2RGZYrY020626
	for <linux-ext4@vger.kernel.org>; Sat, 28 Mar 2009 03:35:34 +1100
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0903262204430.4167@usbsys.site>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 27, 2009 at 01:27:04PM +0300, Dan Carpenter wrote:
> Smatch (http://repo.or.cz/w/smatch.git/) complains about the locking in 
> ext4_mb_add_n_trim() from fs/ext4/mballoc.c
> 
> I think it's meant to be spin_unlock(&tmp_pa->pa_lock); on line 4442.
> 
>   4438          list_for_each_entry_rcu(tmp_pa, &lg->lg_prealloc_list[order],
>   4439                                                  pa_inode_list) {
>   4440                  spin_lock(&tmp_pa->pa_lock);
>   4441                  if (tmp_pa->pa_deleted) {
>   4442                          spin_unlock(&pa->pa_lock);
>   4443                          continue;
>   4444                  }
> 
> I can send a patch if I'm right or you could just give me a:
> Reported-by: Dan Carpenter <error27@gmail.com>
> 

Good catch. Can you send a proper patch with signed-off-by. You can add

Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@gmail.com>

-aneesh
