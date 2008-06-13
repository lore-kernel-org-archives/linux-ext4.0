From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH] ext4: Add ordered mode support for delalloc
Date: Sat, 14 Jun 2008 02:23:44 +0530
Message-ID: <20080613205344.GB16204@skywalker>
References: <1213284316-22063-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:39798 "EHLO
	e28esmtp02.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753325AbYFMUxw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 13 Jun 2008 16:53:52 -0400
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28esmtp02.in.ibm.com (8.13.1/8.13.1) with ESMTP id m5DKrnTG027656
	for <linux-ext4@vger.kernel.org>; Sat, 14 Jun 2008 02:23:49 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m5DKr4Wj766202
	for <linux-ext4@vger.kernel.org>; Sat, 14 Jun 2008 02:23:04 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.13.1/8.13.3) with ESMTP id m5DKrmWS015333
	for <linux-ext4@vger.kernel.org>; Sat, 14 Jun 2008 02:23:49 +0530
Content-Disposition: inline
In-Reply-To: <1213284316-22063-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 12, 2008 at 08:55:16PM +0530, Aneesh Kumar K.V wrote:
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---
>  fs/ext4/inode.c  |  169 +++++++++++++++++++++++++++++++++++++++++++++++++++--
>  fs/jbd2/commit.c |   41 ++++++++++++--
>  2 files changed, 198 insertions(+), 12 deletions(-)
> 

I tested this with fsstress with fallocate, fsx-linux, fs_inode, ffsb,
and generic cp test of / to the new filesystem.

I will now do a crash test and will verify whether ordered behavior
is working correctly.


-aneesh

