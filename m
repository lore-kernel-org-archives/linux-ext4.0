From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/4] e2fsprogs: Make mke2fs use undo I/O manager.
Date: Wed, 01 Aug 2007 11:44:01 +0530
Message-ID: <46B024A9.1080000@linux.vnet.ibm.com>
References: <bee58d48110eee4d5cd133167245b99644148d96.1185933778.git.aneesh.kumar@linux.vnet.ibm.com> <70b3f394cda275d59094d52f60d1ee76492033fc.1185933778.git.aneesh.kumar@linux.vnet.ibm.com> <20070801060439.GP5469@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:46070 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150AbXHAHOu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Aug 2007 03:14:50 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by ausmtp05.au.ibm.com (8.13.8/8.13.8) with ESMTP id l717FTnK819378
	for <linux-ext4@vger.kernel.org>; Wed, 1 Aug 2007 17:16:42 +1000
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.250.242])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.4) with ESMTP id l716Hix6145032
	for <linux-ext4@vger.kernel.org>; Wed, 1 Aug 2007 16:17:45 +1000
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l716EALK014172
	for <linux-ext4@vger.kernel.org>; Wed, 1 Aug 2007 16:14:10 +1000
In-Reply-To: <20070801060439.GP5469@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



Andreas Dilger wrote:
> On Aug 01, 2007  07:34 +0530, Aneesh Kumar K.V wrote:
>> When running mke2fs, if a file system is detected
>> on the device, we use Undo I/O manager as the io manager.
>> This helps in reverting the changes made to the filesystem
>> in case we wrongly selected the device.
>>
>> The environment variable MKE2FS_SCRATCH_DIR
>> is used to indicate the  directory within which the tdb
>> file need to be created. The file will be named mke2fs-XXXXXX
> 
> It might be more useful to have "mke2fs-{dev}-{timestamp}" as
> the filename, so that it is clear where the image came from.
>

I added it as a FIXME!! in the code. So i was intending to do it.

+	/* FIXME!! Should we generate Unique file name ?? */
+	sprintf(tdb_file, "%s/mke2fs-XXXXXX", tdb_dir);



I will add it in my next patch set.

-aneesh
