From: Gernot Hillier <gernot.hillier@siemens.com>
Subject: unexpected sync delays in dpkg for small pre-allocated files on ext4
Date: Tue, 24 May 2016 19:07:41 +0200
Message-ID: <57448A5D.4050805@siemens.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gecko.sbs.de ([194.138.37.40]:51293 "EHLO gecko.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751856AbcEXRPj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 May 2016 13:15:39 -0400
Received: from mail1.sbs.de (mail1.sbs.de [192.129.41.35])
	by gecko.sbs.de (8.15.2/8.15.2) with ESMTPS id u4OH7fEp022055
	(version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Tue, 24 May 2016 19:07:41 +0200
Received: from linux-mf4q.internal.hillier.de ([146.254.78.80])
	by mail1.sbs.de (8.15.2/8.15.2) with ESMTP id u4OH7fSj004221
	for <linux-ext4@vger.kernel.org>; Tue, 24 May 2016 19:07:41 +0200
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi there!

We experience strange delays with kernel 4.1.18 during dpkg package
installation on an ext4 filesystem after switching from Ubuntu 14.04 to
16.04. We can reproduce the issue with kernel 4.6. Installation of the
same package takes 2s with ext3 and 31s with ext4 on the same partition.

Hardware is an Intel-based server with Supermicro X8DTH board and
Seagate ST973451SS disks connected to an LSI SAS2008 controller (PCI
0x1000:0x0072, mpt2sas driver).

We could track this down to the introduction of fallocate() in recent
dpkg versions and derived the following synthetic test case. First
sync_file_range() call takes ~5ms, 2nd call ~15ms.

	fd = open("test1.txt", 0xc1);
	ret = fallocate(fd, 0, 0, 20);
	ret = write(fd, "hallo", 6);
	ret = sync_file_range(fd, 0, 0, 2);
	ret = close(fd);

	fd = open("test2.txt", 0xc1);
	ret = fallocate(fd, 0, 0, 20);
	ret = write(fd, "hallo", 6);
	ret = sync_file_range(fd, 0, 0, 2);
	ret = close(fd);

The delay is caused by sb_issue_zeroout() in ext4_ext_zeroout(), called
by ext4_ext_convert_to_initialized().

Ftrace function_graph snippet with important events (recorded with
kernel 4.6):

  7)          |      ext4_ext_map_blocks() {
[...]
  7)          |        /* ext4_ext_handle_unwritten_extents: ... */
  7)          |        /* ext4_ext_convert_to_initialized_enter: ... */
  7)          |        ext4_ext_zeroout() {
  7)          |          ext4_issue_zeroout() {

[... CPU switches to kworker, then to <idle> ...]
[... 14 ms later, we continue...]

  3)          |  /* irq_handler_entry: irq=25 name=mpt2sas0-msix0 */
  3)          |  /* irq_handler_exit: irq=25 ret=handled */
  7)          |  /* softirq_raise: vec=4 [action=BLOCK] */
  7)          |  /* softirq_entry: vec=4 [action=BLOCK] */
  7)          |  /* block_rq_complete: 8,16 W () 114969912 + 8 [0] */
[...]
  7) * 14 ms  |          } /* ext4_issue_zeroout */

ANY of the following changes reduce the sync_file_range() runtime to <<
1 ms:

 * do not use fallocate()
 * fallocate() for more than extent_max_zeroout_kb, e.g. 40 kB
 * echo 0 > /sys/fs/ext4/sdb2/extent_max_zeroout_kb
 * use ext3 instead of ext4
 * mount ext4 with -o dioread_nolock

To me, the problem looks comparable to
https://bugzilla.kernel.org/show_bug.cgi?id=56821 (even if we don't see
a full hang and there's no RAID involved for us), so a closer look on
the SCSI layer or driver might be the next step?

Any suggestions how to continue analysis are greatly appreciated!

-- 
Gernot Hillier, Siemens AG
Corporate Technology, Corporate Competence Center Embedded Linux

