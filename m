From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: Re: punch-hole should go beyond i_size
Date: Thu, 12 Jan 2012 20:18:11 -0700
Message-ID: <4F0FA273.5060108@linux.vnet.ibm.com>
References: <alpine.LSU.2.00.1201111639240.1833@eggly.anvils> <20120112025547.GC2806@dastard> <4F0F08F6.2000205@linux.vnet.ibm.com> <alpine.LSU.2.00.1201121617320.1541@eggly.anvils>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Dave Chinner <david@fromorbit.com>, linux-ext4@vger.kernel.org
To: Hugh Dickins <hughd@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e7.ny.us.ibm.com ([32.97.182.137]:47103 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751420Ab2AMDSj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Jan 2012 22:18:39 -0500
Received: from /spool/local
	by e7.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <achender@linux.vnet.ibm.com>;
	Thu, 12 Jan 2012 22:18:38 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q0D3IEWf473776
	for <linux-ext4@vger.kernel.org>; Thu, 12 Jan 2012 22:18:14 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q0D3IEoD004721
	for <linux-ext4@vger.kernel.org>; Thu, 12 Jan 2012 22:18:14 -0500
In-Reply-To: <alpine.LSU.2.00.1201121617320.1541@eggly.anvils>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 01/12/2012 05:21 PM, Hugh Dickins wrote:
> On Thu, 12 Jan 2012, Allison Henderson wrote:
>> On 01/11/2012 07:55 PM, Dave Chinner wrote:
>>> On Wed, Jan 11, 2012 at 05:02:12PM -0800, Hugh Dickins wrote:
>>>>
>>>> ext4_ext_punch_hole() contains /* No need to punch hole beyond i_size */
>>>> early return, and trimming to i_size below, but forgets that the other
>>>> variety of fallocate(), with FALLOC_FL_KEEP_SIZE set, may have allocated
>>>> blocks beyond i_size.  They can be removed with ftruncate(), but it is
>>>> unexpected for fallocate() not to undo its own work, and xfs does so.
>>>
>>> I'm pretty sure that's a bug as XFS allows punching holes in extents
>>> beyond EOF.
>>
>> Oh I see, I'll take a look at it, I think it will be ok to just take out the
>> early return.  Thx!
>
> Thanks.  And I've just noticed another, very easily fixed, error:
> I believe those -ENOTSUPPs in ext4_punch_hole() should be -EOPNOTSUPPs.
>
> Hugh
>
Ah, I think youre right, I will change the error values.  I have the 
current solution running in a test right now, and will post the patch 
when it comes up clean.  Thx!

Allison Henderson

