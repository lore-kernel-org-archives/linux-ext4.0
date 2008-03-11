From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: Export needed symbol for ZERO_PAGE usage in
	modules.
Date: Tue, 11 Mar 2008 11:20:15 +0530
Message-ID: <20080311055015.GA8108@skywalker>
References: <1205214392-8236-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: cmm@us.ibm.com, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:40590 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753393AbYCKFwy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Mar 2008 01:52:54 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp02.au.ibm.com (8.13.1/8.13.1) with ESMTP id m2B5r1VY025978
	for <linux-ext4@vger.kernel.org>; Tue, 11 Mar 2008 16:53:01 +1100
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m2B5s3xL249466
	for <linux-ext4@vger.kernel.org>; Tue, 11 Mar 2008 16:54:03 +1100
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m2B5oLMF028765
	for <linux-ext4@vger.kernel.org>; Tue, 11 Mar 2008 16:50:21 +1100
Content-Disposition: inline
In-Reply-To: <1205214392-8236-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 11, 2008 at 11:16:32AM +0530, Aneesh Kumar K.V wrote:
> ext4 use ZERO_PAGE(0) to zero out blocks. We need to export
> different symbols in different arch for the usage of ZERO_PAGE
> in modules.
> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---

This should be applied before ext4-fallocate-full-fs-ENOSPC-handling.patch


-aneesh
