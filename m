From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [Bug 13369] kernel BUG at fs/ext4/inode.c:3123
Date: Sun, 24 May 2009 23:57:47 +0530
Message-ID: <20090524182747.GA3001@skywalker>
References: <bug-13369-13602@http.bugzilla.kernel.org/> <200905232140.n4NLeNI2026314@demeter.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:55667 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753056AbZEXS1y (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 24 May 2009 14:27:54 -0400
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28smtp02.in.ibm.com (8.13.1/8.13.1) with ESMTP id n4OIRp9x006250
	for <linux-ext4@vger.kernel.org>; Sun, 24 May 2009 23:57:51 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n4OIRpUp1777798
	for <linux-ext4@vger.kernel.org>; Sun, 24 May 2009 23:57:51 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.13.1/8.13.3) with ESMTP id n4OIRp86031569
	for <linux-ext4@vger.kernel.org>; Sun, 24 May 2009 23:57:51 +0530
Content-Disposition: inline
In-Reply-To: <200905232140.n4NLeNI2026314@demeter.kernel.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

With data=journal and blocksize= 1k I am seeing some problem explained
here

http://bugzilla.kernel.org/show_bug.cgi?id=12624

-aneesh
