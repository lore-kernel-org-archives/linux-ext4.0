From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] filefrag: count optimize non-verbose mode; count 0 extents properly when verbose
Date: Fri, 8 Apr 2011 17:40:52 -0600
Message-ID: <569EBA4C-A6BB-4E64-88B9-F2F946891B56@dilger.ca>
References: <4CEC4C86.1030806@redhat.com> <4D9F3B71.2050808@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:56898 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398Ab1DHXky convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 8 Apr 2011 19:40:54 -0400
In-Reply-To: <4D9F3B71.2050808@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-04-08, at 10:44 AM, Eric Sandeen wrote:
> On 11/23/10 3:21 PM, Eric Sandeen wrote:
>> # rm -f a; touch a; filefrag -v a
>> 
>> yields 1 extent when it should be 0.  Without -v, 0 is returned.
>> 
>> Fix this up by special-casing no extents returned in verbose
>> mode; skip printing the header for the columns too, since there
>> are no columns to print.
>> 
>> Also, in nonverbose mode we can set fm_extent_count to 0
>> so that FIEMAP will just query the extent count without gathering
>> details; as it is today I think a non-verbose query may under-report
>> the extent count once "count" extents have been filled in.
>> 
>> Addresses-redhat-bugzilla: 653234
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> 
> ping^3
> 
>> ---
>> 
>> diff --git a/misc/filefrag.c b/misc/filefrag.c
>> index bd4486d..a48b9b0 100644
>> --- a/misc/filefrag.c
>> +++ b/misc/filefrag.c
>> @@ -194,7 +194,14 @@ static int filefrag_fiemap(int fd, int blk_shift, int *num_extents)
>> 	do {
>> 		fiemap->fm_length = ~0ULL;
>> 		fiemap->fm_flags = flags;
>> -		fiemap->fm_extent_count = count;
>> +		/*
>> +		 * If fm_extent_count == 0, FIEMAP returns count of
>> +		 * extents found without filling in details.
>> +		 */
>> +		if (!verbose)
>> +			fiemap->fm_extent_count = 0;
>> +		else
>> +			fiemap->fm_extent_count = count;

This is already checked before the start of the do {} while() loop, just above the context of this patch:

	if (!verbose)
		count = 0;

No point in checking (!verbose) inside the loop.

>> @@ -206,6 +213,14 @@ static int filefrag_fiemap(int fd, int blk_shift, int *num_extents)
>> 		}
>> 
>> 		if (verbose && !fiemap_header_printed) {
>> +			/*
>> +			 * No extents on first call?
>> +			 * Skip header and show 0 extents.
>> +			 */
>> +			if (fiemap->fm_mapped_extents == 0) {
>> +				*num_extents = 0;
>> +				goto out;
>> +			}
>> 			printf(" ext %*s %*s %*s length flags\n", logical_width,
>> 			       "logical", physical_width, "physical",
>> 			       physical_width, "expected");

This part definitely makes sense.

Cheers, Andreas





