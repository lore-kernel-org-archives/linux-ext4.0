From: John R Nelson <jrnelson@bhcc.edu>
Subject: Transactions in JBD2 proc
Date: Mon, 29 Oct 2012 13:20:43 -0400
Message-ID: <4B9BD6EF1B194041BF688A9AAE347E37064B168BA039@mercury-stu.bhcc.dom>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5000.bhcc.mass.edu ([134.241.59.13]:28813 "EHLO bhcc.mass.edu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752276Ab2J2Rfx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Oct 2012 13:35:53 -0400
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

hi,
does the 3640 indicate that there have have 3640 journal writes to this ext4 parition since my computer has been up?

3640 transaction, each up to 8192 blocks
average: 
  0ms waiting for transaction
  2032ms running transaction
  0ms transaction was being locked
  0ms flushing data (in ordered mode)
  52ms logging transaction
  71647us average transaction commit time
  316 handles per transaction
  7 blocks per transaction
  8 logged blocks per transaction


