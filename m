From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [Bug 13369] kernel BUG at fs/ext4/inode.c:3123
Date: Mon, 25 May 2009 00:50:24 +0530
Message-ID: <20090524192024.GA11337@skywalker>
References: <bug-13369-13602@http.bugzilla.kernel.org/> <200905241828.n4OISN1R025683@demeter.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:38653 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbZEXTUa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 24 May 2009 15:20:30 -0400
Received: from d23relay01.au.ibm.com (d23relay01.au.ibm.com [202.81.31.243])
	by e23smtp03.au.ibm.com (8.13.1/8.13.1) with ESMTP id n4OJIWKX025075
	for <linux-ext4@vger.kernel.org>; Mon, 25 May 2009 05:18:32 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay01.au.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n4OJKUtl328014
	for <linux-ext4@vger.kernel.org>; Mon, 25 May 2009 05:20:30 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n4OJKUiG003921
	for <linux-ext4@vger.kernel.org>; Mon, 25 May 2009 05:20:30 +1000
Content-Disposition: inline
In-Reply-To: <200905241828.n4OISN1R025683@demeter.kernel.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Can you try with the patch series found at

http://article.gmane.org/gmane.comp.file-systems.ext4/12962
(Threading is not working for gmane currently so the two patches
you may need are
http://thread.gmane.org/gmane.linux.file-systems/31465
http://thread.gmane.org/gmane.comp.file-systems.ext4/12960
)

I guess mmap and truncate combination can result in we missing pagefault
when we write to second block in the same page. That would mean we may
have to do block allocation in writepage.

-aneesh
