From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Some interesting input from a flash manufacturer
Date: Tue, 06 Mar 2012 13:42:12 -0500
Message-ID: <yq1r4x5k1vf.fsf@sermon.lab.mkp.net>
References: <E1S3Za4-0005VW-W9@tytso-glaptop.cam.corp.google.com>
	<4F5135F0.6090100@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Lukas Czerner <lczerner@redhat.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:27460 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758314Ab2CFSmS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 6 Mar 2012 13:42:18 -0500
In-Reply-To: <4F5135F0.6090100@redhat.com> (Eric Sandeen's message of "Fri, 02
	Mar 2012 15:04:48 -0600")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>>>>> "Eric" == Eric Sandeen <sandeen@redhat.com> writes:

>> We also talked about ways that we might right some application notes
>> so that handset OEM's understood how to use mke2fs parameters to
>> optimize their file systems for different types of flash systems, and
>> perhaps ways that the eMMC spec could be enhanced so that key
>> parameters such as erase block size, flash page size, and translation
>> table granularity could be passed back to the block layer, and made
>> available to file system and mkfs.

Eric> Now that would be nice.  Could some of this just be piggybacked on
Eric> the existing preferred_io_size-type geometry interfaces?

So far the barrier has been that the flash manufacturers did not want to
disclose the erase block size, etc. That's why the original
standardization efforts in that department were shelved.

If the devices actually start exporting this information I'll be happy
to put it in the topology.

-- 
Martin K. Petersen	Oracle Linux Engineering
