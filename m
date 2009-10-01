From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14287] ext4: fixpoint divide exception at ext4_fill_super
Date: Thu, 1 Oct 2009 06:01:29 GMT
Message-ID: <200910010601.n9161T8c021076@demeter.kernel.org>
References: <bug-14287-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:37269 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104AbZJAGBZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Oct 2009 02:01:25 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9161Tpx021077
	for <linux-ext4@vger.kernel.org>; Thu, 1 Oct 2009 06:01:29 GMT
In-Reply-To: <bug-14287-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14287





--- Comment #2 from R.N.Sastry <rnsastry@linux.vnet.ibm.com>  2009-10-01 06:01:28 ---
Use the ext4.base file from already attached to other bug #14286
http://bugzilla.kernel.org/attachment.cgi?id=23214

unzip the above file(s) 
ext4.319.img.tar.gz
ext4.base.tar.gz 

And download the fsfuzzer from site
http://www.risesecurity.org/files/fsfuzzer-0.7.3.tar.gz

Untar it
cd fsfuzzer-0.7.3
./configure
make

cp ext4.319.img to fsfuzzer-0.7.3/cfs
cp ext4.base to fsfuzzer-0.7.3/fs
and run the file named run_test in fsfuzzer-0.7.3
./run_test ext4 319

Check the dmesg.

Thanks!!

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
