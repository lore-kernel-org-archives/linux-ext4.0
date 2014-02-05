From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Tuxera test suite failure for setfacl
Date: Wed, 05 Feb 2014 11:45:39 +0530
Message-ID: <87mwi69jas.fsf@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
To: Jan Kara <jack@suse.cz>,
	ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:60411 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbaBEGPq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 5 Feb 2014 01:15:46 -0500
Received: from /spool/local
	by e28smtp08.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <aneesh.kumar@linux.vnet.ibm.com>;
	Wed, 5 Feb 2014 11:45:44 +0530
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by d28dlp03.in.ibm.com (Postfix) with ESMTP id 98D041258053
	for <linux-ext4@vger.kernel.org>; Wed,  5 Feb 2014 11:47:29 +0530 (IST)
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id s156FeN353805144
	for <linux-ext4@vger.kernel.org>; Wed, 5 Feb 2014 11:45:40 +0530
Received: from d28av01.in.ibm.com (localhost [127.0.0.1])
	by d28av01.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s156FdWs010300
	for <linux-ext4@vger.kernel.org>; Wed, 5 Feb 2014 11:45:39 +0530
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Hello,

With commit c6ac12a6159c802ae8b757dd13563564e64333df we are modifying
the ctime of the file when changing file's permission by setfacl. The
commit says that is correct as per spec. But we do have a test in tuxera
http://tuxera.com/sw/qa/pjd-fstest-20090130-RC.tgz test/xacl/00.t 45
which expect the ctime to be not changed across setfacl.

I haven't looked at the spec myself. Can you double check and make sure
it is ok to change the ctime across setfacl ?

-aneesh

