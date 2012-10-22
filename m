From: Marcel van Beurden <marcel_linux-ext4@marsnix.nl>
Subject: Re: Shrinking ext3 partition takes long and high CPU usage
Date: Mon, 22 Oct 2012 11:42:35 +0200
Message-ID: <5085150B.4050504@marsnix.nl>
References: <50811EA2.6030603@marsnix.nl> <20121019143614.GA15590@andromeda.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4757 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098Ab2JVJmp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Oct 2012 05:42:45 -0400
Received: from squeeze.netwerk (mrcl.xs4all.nl [83.163.124.123])
	by smtp-vbr7.xs4all.nl (8.13.8/8.13.8) with ESMTP id q9M9ggQe096273
	(version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 22 Oct 2012 11:42:43 +0200 (CEST)
	(envelope-from marcel_linux-ext4@marsnix.nl)
Received: from [188.202.202.42] (helo=[192.168.20.45])
	by squeeze.netwerk with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <marcel_linux-ext4@marsnix.nl>)
	id 1TQEWv-0000q0-RZ
	for linux-ext4@vger.kernel.org; Mon, 22 Oct 2012 11:42:42 +0200
In-Reply-To: <20121019143614.GA15590@andromeda.usersys.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

A follow-up...

 >> Is resize2fs being stuck and hanging forever, or is it just taking a
>> lot of time? I wouldn't expect resizing to be so CPU intensive.
>>
> Hi, is not possible to answer this with just the information you provided. I
> would expect to see soft lockup warnings on the system log if it was really
> stuck.

There was no information in any log.

> You're using a too olde resize2fs so, may be possible you're using a buggy
> version too, but I'm not the best person to say if there was any bug on
> resize2fs which might be causing this.

Yeah, it was not an up-to-date system. I just used whatever I had available.

> Also, I hope you're trying to shrink the filesystem with this umounted :-)

It was unmounted.

According to my calculations (using the data rate that iotop showed me), 
it would take forever. So I decided to cancel the resize process. Then I 
ran e2fsck on it which gave me plenty of errors like this one:

Multiply-claimed block(s) in inode 2879754: 43528289 43528290 43528291 
43528292 43528293 43528294 43528295 43528296 43528297 43528298 43528299 
43528300 43528301 43528302 43528303 43528304 43528305 43528306

And after that it crashed with this message:

e2fsck: Can't allocate block element
e2fsck: aborted

Since the disk still seemed readable, I copied all files to another disk 
and it did that without complaining. Not sure how many files are 
missing/corrupted. So far I found some empty directories and one regular 
file that was 0 bytes.

Lessons learned:
1. Always use up-to-date software
2. Be careful that when meaning to resize a partition, you don't 
accidentally move it (round to cylinders in gparted?)
3. Get the USB disk out of it's enclosure and hook it up to a SATA port

Regards,
Marcel

