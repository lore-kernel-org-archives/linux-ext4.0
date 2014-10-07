From: Paul Paulson <paul.paulson@seagate.com>
Subject: Re: [PATCH] generic/017: skip tests with mkfs failures
Date: Tue, 7 Oct 2014 13:18:34 -0500
Message-ID: <CAG4SSaQg_2kZZsHUcO=q4m-P1CsD+ThyPcE58js+3sVWPymYAw@mail.gmail.com>
References: <1412619830-23088-1-git-send-email-paul.paulson@seagate.com>
	<20141006232114.GK2301@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: fstests <fstests@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx0a-00003501.pphosted.com ([67.231.144.15]:29453 "EHLO
	mx0a-00003501.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754618AbaJGSSf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Oct 2014 14:18:35 -0400
Received: from pps.filterd (m0075553.ppops.net [127.0.0.1])
	by mx0a-00003501.pphosted.com (8.14.5/8.14.5) with SMTP id s97I4Gdk028629
	for <linux-ext4@vger.kernel.org>; Tue, 7 Oct 2014 14:18:35 -0400
Received: from mail-qa0-f44.google.com (mail-qa0-f44.google.com [209.85.216.44])
	by mx0a-00003501.pphosted.com with ESMTP id 1pvm7krbd5-3
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Tue, 07 Oct 2014 14:18:34 -0400
Received: by mail-qa0-f44.google.com with SMTP id x12so4696427qac.31
        for <linux-ext4@vger.kernel.org>; Tue, 07 Oct 2014 11:18:34 -0700 (PDT)
In-Reply-To: <20141006232114.GK2301@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>> diff --git a/tests/generic/017 b/tests/generic/017
>> index 13b7254..eb38d4d 100755
>> --- a/tests/generic/017
>> +++ b/tests/generic/017
>> @@ -49,8 +49,16 @@ _do_die_on_error=y
>>  testfile=$SCRATCH_MNT/$seq.$$
>>  BLOCKS=10240
>>
>> -for (( BSIZE = 1024; BSIZE <= 4096; BSIZE *= 2 )); do
>> +MAX_INODE_COUNT_1K=127877120
>> +inode_count=`$TUNE2FS_PROG -l $SCRATCH_DEV | awk '/Inode count:/ { print $3 }'`
>> +initial_bsize=$(($inode_count <= $MAX_INODE_COUNT_1K ? 1024 : 2048))
>
> FWIW, that'll break every filesystem type other than ext4.
Yes, that was an oversight on my part. The initial_bsize calculation
should have taken filesystem type into account.
