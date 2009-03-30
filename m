From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: Add sysfs support
Date: Mon, 30 Mar 2009 15:40:34 +0530
Message-ID: <20090330101034.GB4796@skywalker>
References: <1235879288-26201-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:34389 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756537AbZC3KKm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Mar 2009 06:10:42 -0400
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28smtp03.in.ibm.com (8.13.1/8.13.1) with ESMTP id n2UAAa7a032535
	for <linux-ext4@vger.kernel.org>; Mon, 30 Mar 2009 15:40:36 +0530
Received: from d28av04.in.ibm.com (d28av04.in.ibm.com [9.184.220.66])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n2UA6v7J1355930
	for <linux-ext4@vger.kernel.org>; Mon, 30 Mar 2009 15:36:57 +0530
Received: from d28av04.in.ibm.com (loopback [127.0.0.1])
	by d28av04.in.ibm.com (8.13.1/8.13.3) with ESMTP id n2UAAZJa022968
	for <linux-ext4@vger.kernel.org>; Mon, 30 Mar 2009 21:10:35 +1100
Content-Disposition: inline
In-Reply-To: <1235879288-26201-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Feb 28, 2009 at 10:48:07PM -0500, Theodore Ts'o wrote:
> Add basic sysfs support so that information about the mounted
> filesystem and various tuning parameters can be accessed via
> /sys/fs/ext4/<dev>/*.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  fs/ext4/ext4_sb.h |    2 +
>  fs/ext4/super.c   |  198 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 200 insertions(+), 0 deletions(-)
> 

This needs documentation in Documentation/ABI/testing.


-aneesh
