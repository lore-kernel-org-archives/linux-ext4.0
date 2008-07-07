From: Eric Sandeen <sandeen@redhat.com>
Subject: error in ext4_mb_release_inode_pa
Date: Mon, 07 Jul 2008 10:29:10 -0500
Message-ID: <48723646.1050101@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:43932 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752927AbYGGP3M (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 Jul 2008 11:29:12 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m67FTCfd017329
	for <linux-ext4@vger.kernel.org>; Mon, 7 Jul 2008 11:29:12 -0400
Received: from pobox-2.corp.redhat.com (pobox-2.corp.redhat.com [10.11.255.15])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m67FTBdW021022
	for <linux-ext4@vger.kernel.org>; Mon, 7 Jul 2008 11:29:11 -0400
Received: from liberator.sandeen.net (sebastian-int.corp.redhat.com [172.16.52.221])
	by pobox-2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m67FTANM026412
	for <linux-ext4@vger.kernel.org>; Mon, 7 Jul 2008 11:29:11 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This was on #linuxfs last night, and I think I've seen at least one
other report of it:

[22:44]  <shehjart> any ideas why i get the following two lines on the
serial console when writing to ext4 over software raid0:
[22:44]  <shehjart> pa e00001004112d450: logic 11928, phys. 47003288,
len 360
[22:45]  <shehjart> EXT4-fs error (device md0):
ext4_mb_release_inode_pa: free 176, pa_free 174

Just FYI,
-Eric
