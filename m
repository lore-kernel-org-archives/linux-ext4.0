From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Tue, 27 Oct 2009 16:33:00 +0530
Message-ID: <20091027110300.GA31653@skywalker.linux.vnet.ibm.com>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
 <200910271038.n9RAcJgD028430@demeter.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:40105 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212AbZJ0KsC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 27 Oct 2009 06:48:02 -0400
Received: from d23relay05.au.ibm.com (d23relay05.au.ibm.com [202.81.31.247])
	by e23smtp07.au.ibm.com (8.14.3/8.13.1) with ESMTP id n9RAm665021916
	for <linux-ext4@vger.kernel.org>; Tue, 27 Oct 2009 21:48:06 +1100
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay05.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n9RAjBrB1470628
	for <linux-ext4@vger.kernel.org>; Tue, 27 Oct 2009 21:45:12 +1100
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id n9RAm5tW032558
	for <linux-ext4@vger.kernel.org>; Tue, 27 Oct 2009 21:48:05 +1100
Content-Disposition: inline
In-Reply-To: <200910271038.n9RAcJgD028430@demeter.kernel.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

You need to test only with patch in Comment #123 

Also can you make sure you start with a clean file system
before the test. ie fsck and make sure file system is clean.
Then boot the new kernel and run the test ?

-aneesh
