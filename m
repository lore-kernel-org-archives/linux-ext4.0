From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: Re: punch-hole should go beyond i_size
Date: Thu, 12 Jan 2012 09:23:18 -0700
Message-ID: <4F0F08F6.2000205@linux.vnet.ibm.com>
References: <alpine.LSU.2.00.1201111639240.1833@eggly.anvils> <20120112025547.GC2806@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Hugh Dickins <hughd@google.com>, linux-ext4@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:54916 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753602Ab2ALQ1X (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Jan 2012 11:27:23 -0500
Received: from /spool/local
	by e6.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <achender@linux.vnet.ibm.com>;
	Thu, 12 Jan 2012 11:27:21 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay06.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q0CGNKVb1568920
	for <linux-ext4@vger.kernel.org>; Thu, 12 Jan 2012 11:23:20 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q0CGNKfG027470
	for <linux-ext4@vger.kernel.org>; Thu, 12 Jan 2012 11:23:20 -0500
In-Reply-To: <20120112025547.GC2806@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 01/11/2012 07:55 PM, Dave Chinner wrote:
> On Wed, Jan 11, 2012 at 05:02:12PM -0800, Hugh Dickins wrote:
>> Hi Allison,
>>
>> In thinking about fallocate() on tmpfs, I cross-check with ext4
>> and find this bug in its implementation of FALLOC_FL_PUNCH_HOLE:
>>
>> rm -f temp
>> fallocate    -l 4096 temp
>> du temp				# shows 4, right
>> fallocate -p -l 4096 temp
>> du temp				# shows 0, right
>> rm -f temp
>> fallocate -n -l 4096 temp
>> du temp				# shows 4, right
>> fallocate -p -l 4096 temp
>> du temp				# shows 4, wrong
>> rm temp
>>
>> ext4_ext_punch_hole() contains /* No need to punch hole beyond i_size */
>> early return, and trimming to i_size below, but forgets that the other
>> variety of fallocate(), with FALLOC_FL_KEEP_SIZE set, may have allocated
>> blocks beyond i_size.  They can be removed with ftruncate(), but it is
>> unexpected for fallocate() not to undo its own work, and xfs does so.
>
> I'm pretty sure that's a bug as XFS allows punching holes in extents
> beyond EOF.
>
> Cheers,
>
> Dave.

Oh I see, I'll take a look at it, I think it will be ok to just take out 
the early return.  Thx!

Allison

