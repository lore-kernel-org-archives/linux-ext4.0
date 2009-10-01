From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14286] kernel BUG at fs/ext4/extents.c:2863
Date: Thu, 1 Oct 2009 05:58:02 GMT
Message-ID: <200910010558.n915w2Z4020719@demeter.kernel.org>
References: <bug-14286-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:53812 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627AbZJAF56 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Oct 2009 01:57:58 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n915w2dO020722
	for <linux-ext4@vger.kernel.org>; Thu, 1 Oct 2009 05:58:02 GMT
In-Reply-To: <bug-14286-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14286





--- Comment #3 from R.N.Sastry <rnsastry@linux.vnet.ibm.com>  2009-10-01 05:58:01 ---
unzip the above file(s) 
ext4.364.img.tar.gz
ext4.base.tar.gz 

And download the fsfuzzer from URL 
http://www.risesecurity.org/files/fsfuzzer-0.7.3.tar.gz

Untar it
cd fsfuzzer-0.7.3
./configure
make

cp ext4.364.img to fsfuzzer-0.7.3/cfs
cp ext4.base to fsfuzzer-0.7.3/fs
and run the file named run_test in dir fsfuzzer-0.7.3
./run_test ext4 364

Check the dmesg.

Thanks!!

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
