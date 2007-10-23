From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: compilebench numbers for ext4
Date: Tue, 23 Oct 2007 18:13:53 +0530
Message-ID: <471DEC89.2050906@linux.vnet.ibm.com>
References: <20071022193104.0beafeca@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>, Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:52092 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834AbXJWN1f (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Oct 2007 09:27:35 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp03.au.ibm.com (8.13.1/8.13.1) with ESMTP id l9NCiJQE018022
	for <linux-ext4@vger.kernel.org>; Tue, 23 Oct 2007 22:44:19 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l9NCiI5V2285674
	for <linux-ext4@vger.kernel.org>; Tue, 23 Oct 2007 22:44:20 +1000
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9NCi2n9012950
	for <linux-ext4@vger.kernel.org>; Tue, 23 Oct 2007 22:44:03 +1000
In-Reply-To: <20071022193104.0beafeca@think.oraclecorp.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


I get this error while running compilebench  

http://oss.oracle.com/~mason/compilebench/compilebench-0.4.tar.bz2


elm3b138:~/compilebench-0.4# ./compilebench  -d /ext4/
using working directory /ext4/, 30 intial dirs 100 runs
native unpatched native-0 222MB in 9.17 seconds (24.25 MB/s)
native patched native-0 109MB in 3.12 seconds (35.15 MB/s)
native unpatched compiled native-0 680MB in 12.81 seconds (53.13 MB/s)
native patched compiled native-0 691MB in 11.99 seconds (57.68 MB/s)
create dir kernel-0 222MB in 8.48 seconds (26.22 MB/s)
create dir kernel-1 222MB in 8.09 seconds (27.49 MB/s)
create dir kernel-2 222MB in 8.02 seconds (27.73 MB/s)
create dir kernel-3 222MB in 8.09 seconds (27.49 MB/s)
create dir kernel-4 222MB in 8.26 seconds (26.92 MB/s)
create dir kernel-5 222MB in 9.26 seconds (24.01 MB/s)
create dir kernel-6 222MB in 8.60 seconds (25.86 MB/s)
create dir kernel-7 222MB in 8.02 seconds (27.73 MB/s)
create dir kernel-8 222MB in 8.11 seconds (27.42 MB/s)
create dir kernel-9 222MB in 7.95 seconds (27.97 MB/s)
create dir kernel-10 222MB in 8.04 seconds (27.66 MB/s)
create dir kernel-11 222MB in 8.04 seconds (27.66 MB/s)
create dir kernel-12 222MB in 7.99 seconds (27.83 MB/s)
create dir kernel-13 222MB in 8.11 seconds (27.42 MB/s)
create dir kernel-14 222MB in 8.46 seconds (26.29 MB/s)
create dir kernel-15 222MB in 7.97 seconds (27.90 MB/s)
create dir kernel-16 222MB in 8.70 seconds (25.56 MB/s)
create dir kernel-17 222MB in 7.99 seconds (27.83 MB/s)
create dir kernel-18 222MB in 8.12 seconds (27.39 MB/s)
create dir kernel-19 222MB in 8.25 seconds (26.95 MB/s)
create dir kernel-20 222MB in 8.58 seconds (25.92 MB/s)
create dir kernel-21 222MB in 11.96 seconds (18.59 MB/s)
create dir kernel-22 222MB in 9.34 seconds (23.81 MB/s)
create dir kernel-23 222MB in 9.04 seconds (24.60 MB/s)
create dir kernel-24 222MB in 8.34 seconds (26.66 MB/s)
create dir kernel-25 222MB in 8.65 seconds (25.71 MB/s)
create dir kernel-26 222MB in 8.48 seconds (26.22 MB/s)
create dir kernel-27 222MB in 9.14 seconds (24.33 MB/s)
create dir kernel-28 222MB in 8.75 seconds (25.41 MB/s)
create dir kernel-29 222MB in 8.26 seconds (26.92 MB/s)
compile dir kernel-6 680MB in 17.90 seconds (38.02 MB/s)
stat dir kernel-1 in 5.27 seconds
delete kernel-6 in 11.98 seconds
patch dir kernel-26 109MB in 12.39 seconds (8.85 MB/s)
patch dir kernel-23 109MB in 10.08 seconds (10.88 MB/s)
create dir kernel-86372 222MB in 11.75 seconds (18.93 MB/s)
compile dir kernel-16 680MB in 23.44 seconds (29.04 MB/s)
Traceback (most recent call last):
  File "./compilebench", line 541, in ?
    total_runs += func(dset, rnd)
  File "./compilebench", line 431, in create_one_dir
    mbs = run_directory(dset.unpatched, dirname, "create dir")
  File "./compilebench", line 217, in run_directory
    fp = file(fname, 'a+')
IOError: [Errno 2] No such file or directory: '/ext4/kernel-75618/fs/smbfs/symlink.c'
elm3b138:~/compilebench-0.4#
