From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/6 v5] ext4: Add new ext4_discard_partial_page_buffers
 routines
Date: Mon, 22 Aug 2011 07:33:03 -0700
Message-ID: <4E52689F.70606@linux.vnet.ibm.com>
References: <1313893787-25460-1-git-send-email-achender@linux.vnet.ibm.com> <1313893787-25460-2-git-send-email-achender@linux.vnet.ibm.com> <20110822023810.GA3671@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:34900 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367Ab1HVOdT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Aug 2011 10:33:19 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e39.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p7MEI1Xg017500
	for <linux-ext4@vger.kernel.org>; Mon, 22 Aug 2011 08:18:01 -0600
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id p7MEXBeW026544
	for <linux-ext4@vger.kernel.org>; Mon, 22 Aug 2011 08:33:11 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p7M8X5Fj026460
	for <linux-ext4@vger.kernel.org>; Mon, 22 Aug 2011 02:33:06 -0600
In-Reply-To: <20110822023810.GA3671@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 08/21/2011 07:38 PM, Ted Ts'o wrote:
> On Sat, Aug 20, 2011 at 07:29:42PM -0700, Allison Henderson wrote:
>> +		/* If the range is block aligned, unmap */
>> +		if (range_to_discard == blocksize) {
>> +			clear_buffer_dirty(bh);
>> +			bh->b_bdev = NULL;
>> +			clear_buffer_mapped(bh);
>> +			clear_buffer_req(bh);
>> +			clear_buffer_new(bh);
>> +			clear_buffer_delay(bh);
>> +			clear_buffer_unwritten(bh);
>> +			clear_buffer_uptodate(bh);
>> +			ClearPageUptodate(page);
>
> Is this ClearPageUptodate() necessary?  If the page is uptodate, and
> we've zero'ed out the relevant space, why do we need to force the page
> to read in from disk again?  (In fact, if we want to avoid forcing the
> whole punched region to be written to disk, we'll need to get rid of
> the ClearPageUptodate() sooner or later --- and I'm not sure I see why
> it's needed now.  Am I missing something?)
>
> 					- Ted

Oh, I see, maybe we can take this out now then.  Initially we put this 
in there when all we were doing was unmapping the buffer heads.  The 
idea was that if we just unmap the buffer heads and set the page not 
uptodate we wouldnt have to zero the page, but since that didnt work out 
for the mapped reads, we added the zeroing back in.  I'll run some more 
tests to see if we can take it out.  Thx!

Allison Henderson
