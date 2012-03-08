From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Some interesting input from a flash manufacturer
Date: Wed, 07 Mar 2012 23:36:39 -0500
Message-ID: <yq1r4x3hfoo.fsf@sermon.lab.mkp.net>
References: <E1S3Za4-0005VW-W9@tytso-glaptop.cam.corp.google.com>
	<4F5135F0.6090100@redhat.com> <20120302231131.GE22215@thunk.org>
	<yq1mx7tk1rn.fsf@sermon.lab.mkp.net> <20120307005203.GB5717@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	Lukas Czerner <lczerner@redhat.com>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:47310 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794Ab2CHEgp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 7 Mar 2012 23:36:45 -0500
In-Reply-To: <20120307005203.GB5717@thunk.org> (Ted Ts'o's message of "Tue, 6
	Mar 2012 19:52:03 -0500")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>>>>> "Ted" == Ted Ts'o <tytso@mit.edu> writes:

Ted> But min_io currently means the smallest size that we're allowed to
Ted> write, correct?  

Without incurring a penalty, yes. That was conceived in the standards
with 4K sectors and RAID RMW in mind. But I think it would apply to SSDs
as well. Depending on how mkfs.* interpret the field, obviously.


Ted> And the flash page size could be 128k and 512 byte writes might be
Ted> perfectly OK; it's just that writes are more optimal at 128k, and
Ted> would be even more optimal at the erbase block size of 4 megs.

Yep. Just like in the RAID case where the writing the full stripe chunk
is better than just a logical block. And a full stripe is even better.


Ted> That's why I'm not sure it makes sense to use the existing fields,
Ted> since it will confuse file system utilities that are reading those
Ted> fields.

Happy to add new fields if it makes sense. But right now ATA ACS doesn't
even have anything corresponding to the SCSI fields that populate min_io
and opt_io.

-- 
Martin K. Petersen	Oracle Linux Engineering
