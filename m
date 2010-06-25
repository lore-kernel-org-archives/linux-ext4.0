From: Eric Whitney <eric.whitney@hp.com>
Subject: ext4 scalability testing results
Date: Fri, 25 Jun 2010 17:54:22 -0400
Message-ID: <4C25258E.6060207@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from g4t0017.houston.hp.com ([15.201.24.20]:41924 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895Ab0FYVux (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 25 Jun 2010 17:50:53 -0400
Received: from g4t0018.houston.hp.com (g4t0018.houston.hp.com [16.234.32.27])
	by g4t0017.houston.hp.com (Postfix) with ESMTP id 41D6F3838A
	for <linux-ext4@vger.kernel.org>; Fri, 25 Jun 2010 21:50:53 +0000 (UTC)
Received: from ldl (ldl.fc.hp.com [15.11.146.30])
	by g4t0018.houston.hp.com (Postfix) with ESMTP id 33CE110769
	for <linux-ext4@vger.kernel.org>; Fri, 25 Jun 2010 21:50:53 +0000 (UTC)
Received: from localhost (ldl.fc.hp.com [127.0.0.1])
	by ldl (Postfix) with ESMTP id EA51BCF0020
	for <linux-ext4@vger.kernel.org>; Fri, 25 Jun 2010 15:50:52 -0600 (MDT)
Received: from ldl ([127.0.0.1])
	by localhost (ldl.fc.hp.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JATfneJqDAQB for <linux-ext4@vger.kernel.org>;
	Fri, 25 Jun 2010 15:50:52 -0600 (MDT)
Received: from [192.168.0.14] (squirrel.fc.hp.com [15.11.146.57])
	(Authenticated sender: enw@fc.hp.com)
	by ldl (Postfix) with ESMTPA id 9AB24CF0013
	for <linux-ext4@vger.kernel.org>; Fri, 25 Jun 2010 15:50:52 -0600 (MDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

As discussed in recent ext4 developer concalls, I've added 2.6.34 XFS 
results for the Boxacle large_file_creates and random_writes workloads 
to the ext4 results collected earlier.

To make it easier to navigate through the data, I've also added graphs 
and constructed a simple web page with links to the raw results, lock 
stats, etc.

It's at: http://free.linux.hp.com/~enw/ext4/2.6.34

Eric

