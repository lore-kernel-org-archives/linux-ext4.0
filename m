From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH -V2] ext4: Drop mapped buffer_head check during
	page_mkwrite
Date: Mon, 7 Sep 2009 17:52:25 +0530
Message-ID: <20090907122225.GB14516@skywalker.linux.vnet.ibm.com>
References: <1251264196-31382-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20090829022656.GK16732@mit.edu> <20090831063006.GA7711@skywalker.linux.vnet.ibm.com> <20090831122448.GG20822@mit.edu> <20090831123313.GA21973@skywalker.linux.vnet.ibm.com> <20090831125025.GI20822@mit.edu> <20090831170601.GA26003@skywalker.linux.vnet.ibm.com> <20090906034951.GG3055@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:40067 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224AbZIGMWi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Sep 2009 08:22:38 -0400
Received: from d23relay02.au.ibm.com (d23relay02.au.ibm.com [202.81.31.244])
	by e23smtp08.au.ibm.com (8.14.3/8.13.1) with ESMTP id n87CJH4P004362
	for <linux-ext4@vger.kernel.org>; Mon, 7 Sep 2009 22:19:17 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay02.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n87CMcCC1085692
	for <linux-ext4@vger.kernel.org>; Mon, 7 Sep 2009 22:22:38 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n87CMbQK001904
	for <linux-ext4@vger.kernel.org>; Mon, 7 Sep 2009 22:22:37 +1000
Content-Disposition: inline
In-Reply-To: <20090906034951.GG3055@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Sep 05, 2009 at 11:49:51PM -0400, Theodore Tso wrote:
> OK, I've added this patch to the ext4 patch queue.
> 


I have sent a v3 version of this patch. You may want to take that

-aneesh
