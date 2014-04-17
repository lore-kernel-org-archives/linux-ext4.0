From: Mikulas Patocka <mpatocka@redhat.com>
Subject: an infinite loop in ext4 in 3.14
Date: Thu, 17 Apr 2014 15:23:13 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1404171510330.22570@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-kernel@vger.kernel.org
To: linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55772 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751620AbaDQTXQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 17 Apr 2014 15:23:16 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi

I hit a bug in ext4 - jbd2 was stuck in an infinite loop when remounting 
the root filesystem read-only during shutdown.

The filesystem is ext3, but it uses the ext4 driver with the following 
options: rw,relatime,discard,errors=remount-ro,data=ordered

The machine was stuck, but it was possible to obtain a stacktrace with 
Alt-SysRQ-P. I put several stacktraces here:

http://people.redhat.com/~mpatocka/crashes/ext4/

The stacktraces change in jbd2_log_do_checkpoint and 
jbd2_cleanup_journal_tail. jbd2_log_do_checkpoint doesn't call 
jbd2_cleanup_journal_tail from a loop, so the the probable location of the 
infinite loop was this piece of code in jbd2_journal_flush:

while (!err && journal->j_checkpoint_transactions != NULL) {

Mikulas
