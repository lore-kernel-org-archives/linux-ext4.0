From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: Fix fallocate to update the file size in each	transaction.
Date: Thu, 13 Mar 2008 09:04:19 -0500
Message-ID: <47D93463.9040506@redhat.com>
References: <1205214445-8328-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20080311055555.GB8108@skywalker> <20080313075139.GI5851@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	cmm@us.ibm.com, tytso@mit.edu, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:42741 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752189AbYCMOMO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Mar 2008 10:12:14 -0400
In-Reply-To: <20080313075139.GI5851@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger wrote:
> On Mar 11, 2008  11:25 +0530, Aneesh Kumar K.V wrote:
>> +	-x: run test after preallocating the area (1|2) 2 to not update size.\n\
> 
> The issue with preallocating just a single area in fsx is that this isn't
> much different than starting the test with a single large write or truncate.

except that the filesystem does still have to manage the unwritten
extent splits properly... but I agree that ongoing extending and
non-extending fallocates of various sizes would be very interesting.

-Eric

> What would be a lot more useful is to have fsx continually do fallocate
> requests of variable sizes during the test.  This would be quite similar
> to a "write" operation, except that it wouldn't change any existing data
> and holes would still read back as zero.  The only difference is in the
> "do not update size" test any fallocate at the end of the file would not
> increase the file size.
> 
> This would exercise the fallocate code a LOT because it would put unwritten
> extents in the middle of the file, map a single fallocate to multiple
> discontiguous holes of the file (not overwriting existing allocated data
> in the middle of the file), verify fallocate of an overlapping unwritten
> extent works, etc.
> 
