From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: sparsify - utility to punch out blocks of 0s in a file
Date: Sun, 05 Feb 2012 17:55:41 -0600
Message-ID: <4F2F16FD.2090400@redhat.com>
References: <4F2D8F30.3090802@redhat.com> <4F2D90B6.4070008@redhat.com> <4F2F146B.6050003@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	xfs-oss <xfs@oss.sgi.com>
To: Michael Tokarev <mjt@tls.msk.ru>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22221 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753927Ab2BEXz7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 5 Feb 2012 18:55:59 -0500
In-Reply-To: <4F2F146B.6050003@msgid.tls.msk.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2/5/12 5:44 PM, Michael Tokarev wrote:
> On 05.02.2012 00:10, Eric Sandeen wrote:
> []
> 
> Just a very quick look:
> 
>>  * sparsify - utility to punch out blocks of 0s in a file
>> int main(int argc, char **argv)
>> {
> []
>> 	if (optind == argc) {
>> 		printf("Error: no filename specified\n");
>> 		usage();
>> 	}
>>
>> 	fname = argv[optind++];
> 
> There's no handling of the case when there are more than one file
> specified on the command line.

ok

> 
>> 	/*
>> 	 * Normalize to blocksize-aligned range:
>> 	 * round start down, round end up - get all blocks including the range specified
>> 	 */
>>
>> 	punch_range_start = round_down(punch_range_start, blocksize);
>> 	punch_range_end = round_up(punch_range_end, blocksize);
>> 	min_hole = round_up(min_hole, blocksize);
>> 	if (!min_hole)
>> 		min_hole = blocksize;
> 
> I think this deserves some bold warning if punch_range_start
> or punch_hole_end is not a multiple of blocksize.

well, we can only punch on block boundaries.  But I suppose I should swap
round_up and round_down, so that we never punch anything that isn't *inside*
the specified range.

> []
>> 	/*
>> 	 * Read through the file, finding block-aligned regions of 0s.
>> 	 * If the region is at least min_hole, punch it out.
>> 	 * This should be starting at a block-aligned offset
>> 	 */
>>
>> 	while ((ret = read(fd, readbuf, min_hole)) > 0) {
>>
>> 		if (!memcmp(readbuf, zerobuf, min_hole)) {
> 
> Now this is interesting.  Can ret be < min_hole?  Can a read
> in a middle of a file be shorter than specified?

yes, and yes (but unlikely i think)...


> How it will work together with some other operation being done
> at the same file -- ftruncate anyone?

I probably have some boundary condition & error checking to do yet :)

Thanks for the review,
-Eric
 
> Thanks!
> 
> /mjt

