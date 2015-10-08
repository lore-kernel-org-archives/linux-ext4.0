From: Nikolay Borisov <kernel@kyup.com>
Subject: JBD2 stuck, causing fsck to not run.
Date: Thu, 8 Oct 2015 09:42:30 +0300
Message-ID: <56161056.1000605@kyup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	SiteGround Operations <operations@siteground.com>,
	Marian Marinov <mm@1h.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:35666 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbbJHGmh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 8 Oct 2015 02:42:37 -0400
Received: by wicge5 with SMTP id ge5so10897955wic.0
        for <linux-ext4@vger.kernel.org>; Wed, 07 Oct 2015 23:42:35 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

Yesterday I wanted to run fsck on an ext4 volume. However, fsck was
saying that the volume was still in use and was aborting. After some
debugging turned out it was failing in the bd_may_claim() . Further
investigation revealed that the JBD2 thread for this particular volume
was stuck with the following trace:

PID: 14508 TASK: ffff8802c3b8bd80 CPU: 11 COMMAND: "jbd2/dm-11-8"
#0 [ffff8805d1aefdc0] __schedule at ffffffff815ac3be
#1 [ffff8805d1aefe10] schedule at ffffffff815ac9ce
#2 [ffff8805d1aefe30] kjournald2 at ffffffff8127a5ae
#3 [ffff8805d1aefec0] kthread at ffffffff81073fce
#4 [ffff8805d1aeff50] ret_from_fork at ffffffff815b0fe2

This seems pretty normal to me except that at some point ext4_put_super
should have called jbd2_journal_destroy, which in turn should set the
JBD2_UNMOUNT flag and wakeup the jbd thread so that it can exit
gracefully, apparently this hadn't happened. The volume where the
filesystem was created is an LVM thin volume if it matters.

I wonder whether it's possible due to corruption that ext4 got confused
that it's not being journalled and as such skipped part responsible for
shutting down JBD2? So far this has happened numerous times on a variety
of kernel - from 3.12.28 to 4.1.6 (which was the most recent as of
yesterday). Any ideas when this problem manifests again how to debug it
further?

Regards,
Nikolay
