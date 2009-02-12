From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [Bug 12579] ext4 filesystem hang
Date: Thu, 12 Feb 2009 22:06:10 +0530
Message-ID: <20090212163610.GA10351@skywalker>
References: <bug-12579-13602@http.bugzilla.kernel.org/> <20090212152406.C59BC108041@picon.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: bugme-daemon@bugzilla.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:42304 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756079AbZBLQgY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Feb 2009 11:36:24 -0500
Received: from d23relay02.au.ibm.com (d23relay02.au.ibm.com [202.81.31.244])
	by e23smtp05.au.ibm.com (8.13.1/8.13.1) with ESMTP id n1CGYm37022396
	for <linux-ext4@vger.kernel.org>; Fri, 13 Feb 2009 03:34:48 +1100
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay02.au.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id n1CGaMa61171594
	for <linux-ext4@vger.kernel.org>; Fri, 13 Feb 2009 03:36:22 +1100
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n1CGaMBU007987
	for <linux-ext4@vger.kernel.org>; Fri, 13 Feb 2009 03:36:22 +1100
Content-Disposition: inline
In-Reply-To: <20090212152406.C59BC108041@picon.linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Two commits which are already in the mainline which fixed some changes
after .28 are

89e1219004b3657cc014521663eeef0744f1c99d
dcf6a79dda5cc2a2bec183e50d829030c0972aaa


Both changes have implication wrt ext4. I would suggest try with the
above two commits and see if the problem still exist.

-aneesh
