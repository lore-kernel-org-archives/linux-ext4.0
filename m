From: Sebastian Biedermann
	<biedermann@seceng.informatik.tu-darmstadt.de>
Subject: Writing one file, observing two writes
Date: Sun, 13 Apr 2014 11:49:07 -0400
Message-ID: <534AB1F3.2060700@seceng.informatik.tu-darmstadt.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lnx141.hrz.tu-darmstadt.de ([130.83.156.236]:41562 "EHLO
	lnx141.hrz.tu-darmstadt.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751686AbaDMPzb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 13 Apr 2014 11:55:31 -0400
Received: from lnx500.hrz.tu-darmstadt.de (lnx500.hrz.tu-darmstadt.de [130.83.156.225])
	by lnx141.hrz.tu-darmstadt.de (8.14.4/8.13.8) with ESMTP id s3DFoPYP006988
	for <linux-ext4@vger.kernel.org>; Sun, 13 Apr 2014 17:50:25 +0200
	(envelope-from biedermann@seceng.informatik.tu-darmstadt.de)
Received: from mail.cdc.informatik.tu-darmstadt.de (cdc-info.cdc.informatik.tu-darmstadt.de [130.83.167.6])
	by lnx500.hrz.tu-darmstadt.de (8.14.4/8.14.4/HRZ/PMX) with ESMTP id s3DFnAqW019775
	for <linux-ext4@vger.kernel.org>; Sun, 13 Apr 2014 17:49:10 +0200
	(envelope-from biedermann@seceng.informatik.tu-darmstadt.de)
Received: from [172.28.143.127] (nat-130-132-173-205.central.yale.edu [130.132.173.205])
	(using TLSv1 with cipher ECDHE-RSA-AES128-SHA (128/128 bits))
	(Client did not present a certificate)
	by mail.cdc.informatik.tu-darmstadt.de (Postfix) with ESMTPSA id 6D0B023A56
	for <linux-ext4@vger.kernel.org>; Sun, 13 Apr 2014 17:49:10 +0200 (CEST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Dear ext4 developers,

I'm working on a research project about side channel attacks to hard drives.
My testbed runs Ubuntu Linux 12.04 with ext4 file system.

When writing a random file with dd command to my hard drive, I could see
the process jbd2/sda1
writing two times while it seems to wait a fixed period of time between
these two writes.

I actually think that the process is first writing the data to the
sectors and then updating the ext4 data base in a second step.
Is that true or am I wrong? Why is it waiting some seconds between these
two steps and on what is that delay depending?

Thank you!
Sebastian
