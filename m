From: Eric Whitney <eric.whitney@hp.com>
Subject: 2.6.39 and 3.0 scalability measurement results
Date: Sun, 31 Jul 2011 22:57:52 -0400
Message-ID: <4E361630.9060907@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:10058 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297Ab1HADDI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 31 Jul 2011 23:03:08 -0400
Received: from g5t0030.atlanta.hp.com (g5t0030.atlanta.hp.com [16.228.8.142])
	by g5t0006.atlanta.hp.com (Postfix) with ESMTP id 11686C0FA
	for <linux-ext4@vger.kernel.org>; Mon,  1 Aug 2011 02:54:26 +0000 (UTC)
Received: from ldl (ldl.usa.hp.com [16.125.112.222])
	by g5t0030.atlanta.hp.com (Postfix) with ESMTP id DBA5F18085
	for <linux-ext4@vger.kernel.org>; Mon,  1 Aug 2011 02:54:26 +0000 (UTC)
Received: from localhost (ldl.fc.hp.com [127.0.0.1])
	by ldl (Postfix) with ESMTP id 99459CF0008
	for <linux-ext4@vger.kernel.org>; Sun, 31 Jul 2011 20:54:26 -0600 (MDT)
Received: from ldl ([127.0.0.1])
	by localhost (ldl.fc.hp.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LKVEz0UaDtAA for <linux-ext4@vger.kernel.org>;
	Sun, 31 Jul 2011 20:54:26 -0600 (MDT)
Received: from [192.168.0.12] (squirrel.fc.hp.com [15.11.146.57])
	(Authenticated sender: enw@fc.hp.com)
	by ldl (Postfix) with ESMTPA id 4C804CF0007
	for <linux-ext4@vger.kernel.org>; Sun, 31 Jul 2011 20:54:26 -0600 (MDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've posted the results of my 2.6.38/2.6.39 and 2.6.39/3.0 ext4 
scalability measurements and comparisons on a 48 core x86_64 server at:

http://free.linux.hp.com/~enw/ext4/2.6.39

http://free.linux.hp.com/~enw/ext4/3.0

The results include throughput and CPU efficiency graphs for five simple 
workloads, the raw data for same, and lockstats as well.

The data cover ext4 filesystems with and without journals.  For 
reference, ext3, xfs, and btrfs are included as well.

The 2.6.38/2.6.39 results mainly show the clear scalability benefit of 
making the mblk_io_submit mount option default behavior for ext4 
filesystems with journals - see the large_file_creates throughput plot.

In the way of more recent news, the 2.6.39/3.0 results indicate little 
change for ext4 either with or without journals.

Thanks,
Eric
