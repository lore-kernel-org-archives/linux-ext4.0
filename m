From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: e2fsprogs make check errors on powerpc
Date: Wed, 30 Jul 2008 16:55:41 +0530
Message-ID: <20080730112541.GA2932@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: tytso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:48347 "EHLO
	e28esmtp01.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761392AbYG3LZv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 30 Jul 2008 07:25:51 -0400
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28esmtp01.in.ibm.com (8.13.1/8.13.1) with ESMTP id m6UBPmwx031602
	for <linux-ext4@vger.kernel.org>; Wed, 30 Jul 2008 16:55:48 +0530
Received: from d28av04.in.ibm.com (d28av04.in.ibm.com [9.184.220.66])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6UBPkUG1699900
	for <linux-ext4@vger.kernel.org>; Wed, 30 Jul 2008 16:55:46 +0530
Received: from d28av04.in.ibm.com (loopback [127.0.0.1])
	by d28av04.in.ibm.com (8.13.1/8.13.3) with ESMTP id m6UBPl8f006209
	for <linux-ext4@vger.kernel.org>; Wed, 30 Jul 2008 16:55:47 +0530
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I get these errors on powerpc.


Printing region (min=1. max=1001) (1, 55)  
LD_LIBRARY_PATH=../lib DYLD_LIBRARY_PATH=../lib ./tst_crc32

Testing length 0...
Testing length 1...
CRC cancellation fail: 0x592aefaf should be 0

CRC split fail: 0x592aefaf

CRC split fail: 0xf1466c6f

CRC split fail: 0xf1466c6f

CRC split fail: 0xf1466c6f

CRC split fail: 0x592aefaf

CRC split fail: 0x592aefaf

CRC cancellation fail: 0xf5f7549a should be 0

-aneesh

