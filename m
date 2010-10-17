From: "Daniel Taylor" <Daniel.Taylor@wdc.com>
Subject: ext over RAID-[56]?
Date: Sat, 16 Oct 2010 17:16:50 -0700
Message-ID: <25B374CC0D9DFB4698BB331F82CD0CF20D5FE3@wdscexbe08.sc.wdc.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wdscspam2.wdc.com ([129.253.170.131]:23656 "EHLO
	wdscspam2.wdc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756929Ab0JQA3v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 16 Oct 2010 20:29:51 -0400
Content-class: urn:content-classes:message
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

One of the program managers here asked me a question that I couldn't answer:

with ext[34] over a RAID-[56] volume, what protection against data
corruption
and loss of existing data does the file system provide for the case of an
incomplete update of the RAID "stripe"?

I know that anyone with any usable brain cells has their data server on a
nice
UPS, but not all customers are so equipped, and he's concerned about
corruption
during a power failure (loss of unwritten data is OK).

I can't see any configuration options that would help but I could easily be
missing something.  Any ideas?

Thanks,

Dan Taylor
Sr. Staff Engineer
WD Branded Products
