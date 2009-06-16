From: Eric Sandeen <sandeen@redhat.com>
Subject: Something wrong with extent-based journal creation
Date: Tue, 16 Jun 2009 17:38:00 -0500
Message-ID: <4A381EC8.4010202@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:44221 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753500AbZFPWh7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 16 Jun 2009 18:37:59 -0400
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n5GMc2tv023238
	for <linux-ext4@vger.kernel.org>; Tue, 16 Jun 2009 18:38:02 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n5GMc1gf028736
	for <linux-ext4@vger.kernel.org>; Tue, 16 Jun 2009 18:38:01 -0400
Received: from liberator.sandeen.net (sebastian-int.corp.redhat.com [172.16.52.221])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n5GMc0bD007316
	for <linux-ext4@vger.kernel.org>; Tue, 16 Jun 2009 18:38:00 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've been tearing my hair out all day on this and not getting anywhere
yet, so punting to the list ;)

I have a user running mke2fs -t ext4 in a virt guest, and a mount
immediately after that fails.

It fails because the journal inode has an invalide i_extra_isize.

I've narrowed it down to the commit (961306d3) which creates the journal
with extent format; if that's commented out, it works fine.

I can't for the life of me see where the problem is coming from, though.

I thought we'd need a write_inode_new (emphasis on new here) for the
journal inode, but switching to that doesn't help.

I can't reproduce this myself... any ideas or suggestions of where to
look? :)

-Eric
