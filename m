From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Unusual code in mballoc.c.
Date: Sun, 28 Sep 2008 11:56:12 +1000
Message-ID: <200809281156.12688.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Alex Tomas <alex@clusterfs.com>, Mike Travis <travis@sgi.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:50873 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751684AbYI1B4Q (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 27 Sep 2008 21:56:16 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

   A grep lead me to fs/ext4/mballoc.c:

Line 2551:
	for (i = 0; i < nr_cpu_ids; i++) {

This is more normally "for_each_possible_cpu(i)".

Line 4097:
	ac->ac_lg = &sbi->s_locality_groups[get_cpu()];
	put_cpu();

This is presumably someone suppressing a warning.   It should be:
	ac->ac_lg = &sbi->s_locality_groups[raw_smp_processor_id()];

Thanks,
Rusty.
