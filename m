From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: delalloc and reservation.
Date: Mon, 29 Oct 2007 20:03:23 +0530
Message-ID: <4725EF33.7050804@linux.vnet.ibm.com>
References: <4725AF5B.1000300@linux.vnet.ibm.com> <4725F8E6.2050500@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@clusterfs.com>,
	Eric Sandeen <sandeen@redhat.com>,
	Valerie Clement <valerie.clement@bull.net>,
	Theodore Tso <tytso@mit.edu>, Mingming Cao <cmm@us.ibm.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Alex Tomas <bzzz.tomas@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:60643 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757990AbXJ2PF3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Oct 2007 11:05:29 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp03.au.ibm.com (8.13.1/8.13.1) with ESMTP id l9TEXw3s030644
	for <linux-ext4@vger.kernel.org>; Tue, 30 Oct 2007 01:33:58 +1100
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l9TEXxkm2617344
	for <linux-ext4@vger.kernel.org>; Tue, 30 Oct 2007 01:33:59 +1100
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9TEXe0e017446
	for <linux-ext4@vger.kernel.org>; Tue, 30 Oct 2007 01:33:41 +1100
In-Reply-To: <4725F8E6.2050500@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



Alex Tomas wrote:
> Hi,
> 
> could you try the patch attached. it should fix the issue. the idea
> was to align requests in order to help raid5-like setups. but somewhere
> I lost one bit in mballoc: it should pre-allocate all crossed stripes,
> but it didn't.
> 
> as for discard, lustre doesn't use open/close for data, so discard-on-close
> makes zero sense in our case. I'm not very positive whether we need to
> drop preallocation on file close in case of delayed allocation as writeback
> can be started while file is open and finish after close(2).
> 
> 

mballoc by default doesn't give the particular layout only if i force small
size to use inode preallocation i am hitting the problem. ie to change the
below line in ext4_mb_group_or_file

 if (ac->ac_o_ex.fe_len >= sbi->s_mb_small_req)

to 

if (ac->ac_o_ex.fe_len <= sbi->s_mb_small_req)

Do you want to test the patch with this change ?

We are observing the problem with delalloc and nomballoc.


-aneesh
