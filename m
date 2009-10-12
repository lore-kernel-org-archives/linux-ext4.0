From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [Bug 14354] New: Bad corruption with 2.6.32-rc1 and upwards
Date: Mon, 12 Oct 2009 20:57:08 +0530
Message-ID: <20091012152708.GA7899@skywalker.linux.vnet.ibm.com>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:37456 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757174AbZJLP1q (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 12 Oct 2009 11:27:46 -0400
Received: from d28relay03.in.ibm.com (d28relay03.in.ibm.com [9.184.220.60])
	by e28smtp07.in.ibm.com (8.14.3/8.13.1) with ESMTP id n9CFR791019555
	for <linux-ext4@vger.kernel.org>; Mon, 12 Oct 2009 20:57:07 +0530
Received: from d28av02.in.ibm.com (d28av02.in.ibm.com [9.184.220.64])
	by d28relay03.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n9CFR7Ls2744512
	for <linux-ext4@vger.kernel.org>; Mon, 12 Oct 2009 20:57:07 +0530
Received: from d28av02.in.ibm.com (loopback [127.0.0.1])
	by d28av02.in.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id n9CFR7dr029187
	for <linux-ext4@vger.kernel.org>; Tue, 13 Oct 2009 02:27:07 +1100
Content-Disposition: inline
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This one was found on 2.6.30-1 reported by one of my friend

Hi Aneesh,

I got the second ext4 fs error on my wife's eeepc.  I have recorded what
was fixed.  The kernel is 2.6.30-1 from debian sid.

suvaipc:~# fsck.ext4 /dev/mapper/eeepc-suvai 
e2fsck 1.41.3 (12-Oct-2008)
/dev/mapper/eeepc-suvai contains a file system with errors, check forced.
Pass 1: Checking inodes, blocks, and sizes
Inode 336893 has illegal block(s).  Clear<y>? yes

Illegal block #12 (7602287) in inode 336893.  CLEARED.
Illegal block #13 (6422560) in inode 336893.  CLEARED.
Illegal block #15 (7274595) in inode 336893.  CLEARED.
Illegal block #16 (7536750) in inode 336893.  CLEARED.
Illegal block #17 (6553705) in inode 336893.  CLEARED.
Illegal block #18 (7471205) in inode 336893.  CLEARED.
Illegal block #19 (6553701) in inode 336893.  CLEARED.
Illegal block #20 (6357024) in inode 336893.  CLEARED.
Illegal block #22 (7602281) in inode 336893.  CLEARED.
Illegal block #23 (7798816) in inode 336893.  CLEARED.
Illegal block #24 (7536737) in inode 336893.  CLEARED.
Too many illegal blocks in inode 336893.
Clear inode<y>? yes

Restarting e2fsck from the beginning...
/dev/mapper/eeepc-suvai contains a file system with errors, check forced.
Pass 1: Checking inodes, blocks, and sizes

Running additional passes to resolve blocks claimed by more than one inode...
Pass 1B: Rescanning for multiply-claimed blocks
Multiply-claimed block(s) in inode 336889: 1347590 1347591 1347592 1347593 1347595 1347597
Multiply-claimed block(s) in inode 336890: 1898439 1898442 1898443 1898444 1898445 1898446 1898513 1898514 1898515 1898516 1898517 1898518 1898519 1898520 1898521 1898522 1898543 1898544 1898545
Multiply-claimed block(s) in inode 336891: 1361951 1361952 1361961 1361962 1361963 1361964 1361965 1361966 1361967 1361968 1361969 1361970 1361971 1361972 1361973 1361974 1361975 1361976 1361977 1361978
Multiply-claimed block(s) in inode 336892: 1415316 1415317 1415318 1415319 1415320 1415321 1415344 1415345
Multiply-claimed block(s) in inode 336894: 1415359 1415382 1416689
Multiply-claimed block(s) in inode 336895: 1898381 1898382 1898383 1898384 1898385 1898386 1898387 1898388 1898389 1898390 1898391 1898392 1898393 1898394 1898395 1898396 1898397 1898398 1898399 1898400 1898401 1898402 1898403 1898404 1898405 1898406 1898407 1898408 1898409 1898410 1898411 1898412 1898413 1898414 1898415 1898416 1898417 1898418 1898419 1898420 1898421 1898422 1898423 1898424 1898425 1898426 1898427 1898428 1898429 1898430 1898431 1898432 1898433 1898434 1898435 1898436 1898437 1898438
Multiply-claimed block(s) in inode 336896: 1361922 1361923 1361924 1361925 1361926 1361927 1361929 1361930 1361931 1361932 1361933 1361934 1361935 1361947 1361948 1361949 1361950 1361979 1361980
Multiply-claimed block(s) in inode 336897: 1347590 1347591 1347592 1347593 1347595 1347597
Multiply-claimed block(s) in inode 336898: 1898439 1898442 1898443 1898444 1898445 1898446 1898513 1898514 1898515 1898516 1898517 1898518 1898519 1898520 1898521 1898522 1898543 1898544 1898545
Multiply-claimed block(s) in inode 336899: 1361951 1361952 1361961 1361962 1361963 1361964 1361965 1361966 1361967 1361968 1361969 1361970 1361971 1361972 1361973 1361974 1361975 1361976 1361977 1361978
Multiply-claimed block(s) in inode 336900: 1415316 1415317 1415318 1415319 1415320 1415321 1415344 1415345
Multiply-claimed block(s) in inode 336902: 1415359 1415382 1416689
Multiply-claimed block(s) in inode 336903: 1898381 1898382 1898383 1898384 1898385 1898386 1898387 1898388 1898389 1898390 1898391 1898392 1898393 1898394 1898395 1898396 1898397 1898398 1898399 1898400 1898401 1898402 1898403 1898404 1898405 1898406 1898407 1898408 1898409 1898410 1898411 1898412 1898413 1898414 1898415 1898416 1898417 1898418 1898419 1898420 1898421 1898422 1898423 1898424 1898425 1898426 1898427 1898428 1898429 1898430 1898431 1898432 1898433 1898434 1898435 1898436 1898437 1898438
Multiply-claimed block(s) in inode 336904: 1361922 1361923 1361924 1361925 1361926 1361927 1361929 1361930 1361931 1361932 1361933 1361934 1361935 1361947 1361948 1361949 1361950 1361979 1361980
Pass 1C: Scanning directories for inodes with multiply-claimed blocks
Pass 1D: Reconciling multiply-claimed blocks
(There are 14 inodes containing multiply-claimed blocks.)

......
........

Pass 2: Checking directory structure
Entry '#336913' in /lost+found (11) has deleted/unused inode 336913.  Clear<y>? yes

Entry '#336914' in /lost+found (11) has deleted/unused inode 336914.  Clear<y>? yes

Entry '#336915' in /lost+found (11) has deleted/unused inode 336915.  Clear<y>? yes

Entry '#336916' in /lost+found (11) has deleted/unused inode 336916.  Clear<y>? yes

Entry '#336917' in /lost+found (11) has deleted/unused inode 336917.  Clear<y>? yes

Entry '#336918' in /lost+found (11) has deleted/unused inode 336918.  Clear<y>? yes

Entry '#336919' in /lost+found (11) has deleted/unused inode 336919.  Clear<y>? yes

Entry '#336920' in /lost+found (11) has deleted/unused inode 336920.  Clear<y>? yes


Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Inode 336558 ref count is 12, should be 11.  Fix<y>? yes

Unattached inode 336898
Connect to /lost+found<y>? yes

Inode 336898 ref count is 2, should be 1.  Fix<y>? yes

Unattached inode 336899
Connect to /lost+found<y>? yes

Inode 336899 ref count is 2, should be 1.  Fix<y>? yes

Unattached inode 336902
Connect to /lost+found<y>? yes

Inode 336902 ref count is 2, should be 1.  Fix<y>? yes

Unattached inode 336904
Connect to /lost+found<y>? yes

Inode 336904 ref count is 2, should be 1.  Fix<y>? yes

Pass 5: Checking group summary information
Block bitmap differences:  -(1344019--1344024) -(1347586--1347589) -1347594 -1347596 -(1347598--1347599) -(1349632--1349638) -1353729 -(1415305--1415308) -(1415329--1415332) -(1415338--1415343) -(1902878--1902967)
Fix<y>? yes

Free blocks count wrong for group #0 (31076, counted=30947).
Fix<y>? yes

Free blocks count wrong for group #41 (19489, counted=19511).
Fix<y>? yes

Free blocks count wrong for group #43 (1, counted=15).
Fix<y>? yes

Free blocks count wrong for group #58 (13532, counted=13622).
Fix<y>? yes

Free blocks count wrong (2373548, counted=2373545).
Fix<y>? yes

Inode bitmap differences:  -336893 -(336913--336920)
Fix<y>? yes

Free inodes count wrong for group #41 (7031, counted=7040).
Fix<y>? yes

Directories count wrong for group #41 (254, counted=253).
Fix<y>? yes

Free inodes count wrong (1302827, counted=1302836).
Fix<y>? yes


/dev/mapper/eeepc-suvai: ***** FILE SYSTEM WAS MODIFIED *****
/dev/mapper/eeepc-suvai: 7884/1310720 files (3.9% non-contiguous), 2869335/5242880 blocks
suvaipc:~# fsck.ext4 /dev/mapper/eeepc-suvai 
e2fsck 1.41.3 (12-Oct-2008)
/dev/mapper/eeepc-suvai: clean, 7884/1310720 files, 2869335/5242880 blocks
suvaipc:~# exit

Script done on Mon Sep 28 11:17:59 2009


