From: Badari Pulavarty <pbadari@gmail.com>
Subject: ext4 not updating ctime on truncate ?
Date: Tue, 08 Apr 2008 08:37:49 -0700
Message-ID: <1207669069.18386.6.camel@badari-desktop>
References: <Pine.LNX.4.62.0804022313390.664@tamago.serverit.net>
	 <1207247251.30407.59.camel@dyn9047017100.beaverton.ibm.com>
	 <Pine.LNX.4.62.0804070207160.25240@tamago.serverit.net>
	 <1207587843.31073.3.camel@badari-desktop>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Szabolcs Szakacsits <szaka@ntfs-3g.org>
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:51458 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751676AbYDHPhu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Apr 2008 11:37:50 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m38Fbn4V000379
	for <linux-ext4@vger.kernel.org>; Tue, 8 Apr 2008 11:37:49 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m38Fbnck235224
	for <linux-ext4@vger.kernel.org>; Tue, 8 Apr 2008 11:37:49 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m38Fbnap009463
	for <linux-ext4@vger.kernel.org>; Tue, 8 Apr 2008 11:37:49 -0400
In-Reply-To: <1207587843.31073.3.camel@badari-desktop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Hi,

I ran Linux POSIX filesystem test suite released by  Szabolcs Szakacsits
on ext4. I get one failure on ext4.

Failed Test                     Stat Wstat Total Fail  Failed  List of
Failed
-------------------------------------------------------------------------------
/root/posix/tests/truncate/00.t               21    1   4.76%  15

Looking at the test, its complaining that ext4 is not updating ctime
for truncate. Is this a known issue ?

# successful truncate(2) updates ctime.
expect 0 create ${n0} 0644
ctime1=`${fstest} stat ${n0} ctime`
sleep 1
expect 0 truncate ${n0} 123
ctime2=`${fstest} stat ${n0} ctime`
test_check $ctime1 -lt $ctime2


Thanks,
Badari


