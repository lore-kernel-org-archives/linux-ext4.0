From: Daniel Drake <ddrake@brontes3d.com>
Subject: e2fsck and human intervention
Date: Mon, 05 Mar 2007 11:26:57 -0500
Message-ID: <1173112017.6300.14.camel@systems03.mmm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp126.iad.emailsrvr.com ([207.97.245.126]:50751 "EHLO
	smtp126.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788AbXCEQgU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 5 Mar 2007 11:36:20 -0500
Received: from [169.14.245.222] (host34.155.212.242.conversent.net [155.212.242.34])
	(Authenticated sender: ddrake@brontes3d.com)
	by relay2.r2.iad.emailsrvr.com (SMTP Server) with ESMTP id DFB0A44F1F9
	for <linux-ext4@vger.kernel.org>; Mon,  5 Mar 2007 11:26:57 -0500 (EST)
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

I'm working with ext3 partitions in a product environment, where
numerous embedded Linux systems will be shipped to various locations.

In testing we occasionally find that system boot is halted by e2fsck
with an "UNEXPECTED INCONSISTENCY" error message. This is while running
in preen mode.

This usually happens during e2fsck's regular "check every X mounts"
thing, as opposed to immediately after booting up after power loss, so
to begin with it's not immediately obvious why there is a problem.

It's of course understandable and inevitable that power loss will
occasionally cause some file loss or corruption, and that's fine. My
main concern is that fsck is halting the boot process, and in a product
scenario this would require an engineer to perform a service call. If
e2fsck could unconditionally perform a best-effort attempt at solving
the problems, it would be ideal.

Are there any better approaches than something like the following?

1. Run "e2fsck -p /"

2. If bit 3 is set in exit code (i.e. preen functionality detected
unexpected inconsistency) then run "e2fsck -y /"

Is there significant risk of further data loss through using -y than
might be experienced otherwise?

Thanks!
-- 
Daniel Drake
Brontes Technologies, A 3M Company
