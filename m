From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: add rb_tree cache to struct ext4_group_info
Date: Tue, 30 Mar 2010 23:59:25 +0530
Message-ID: <87y6h9y86y.fsf@linux.vnet.ibm.com>
References: <h2tac8f92701003280211p70c2dbcpac77b16fb27deb79@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: jing zhang <zj.barak@gmail.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:39146 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755415Ab0C3S3b (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 30 Mar 2010 14:29:31 -0400
Received: from d28relay05.in.ibm.com (d28relay05.in.ibm.com [9.184.220.62])
	by e28smtp03.in.ibm.com (8.14.3/8.13.1) with ESMTP id o2UITTBx004892
	for <linux-ext4@vger.kernel.org>; Tue, 30 Mar 2010 23:59:29 +0530
Received: from d28av02.in.ibm.com (d28av02.in.ibm.com [9.184.220.64])
	by d28relay05.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o2UITS823043524
	for <linux-ext4@vger.kernel.org>; Tue, 30 Mar 2010 23:59:28 +0530
Received: from d28av02.in.ibm.com (loopback [127.0.0.1])
	by d28av02.in.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o2UITRYk016319
	for <linux-ext4@vger.kernel.org>; Wed, 31 Mar 2010 05:29:28 +1100
In-Reply-To: <h2tac8f92701003280211p70c2dbcpac77b16fb27deb79@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, 28 Mar 2010 17:11:55 +0800, jing zhang <zj.barak@gmail.com> wrote:
> From: Jing Zhang <zj.barak@gmail.com>
> 
> Date: Sun Mar 28 17:09:33     2010
> 
> rb_tree cache is added to struct ext4_group_info at minor cost.
> 

Did we measure the cost of not doing this ? Is there a profile data that
we can look at ?

-aneesh
