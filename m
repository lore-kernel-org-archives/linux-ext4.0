From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: sparsify - utility to punch out blocks of 0s in a file
Date: Mon, 06 Feb 2012 03:44:43 +0400
Message-ID: <4F2F146B.6050003@msgid.tls.msk.ru>
References: <4F2D8F30.3090802@redhat.com> <4F2D90B6.4070008@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	xfs-oss <xfs@oss.sgi.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from isrv.corpit.ru ([86.62.121.231]:52843 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753429Ab2BEXoq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 5 Feb 2012 18:44:46 -0500
In-Reply-To: <4F2D90B6.4070008@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 05.02.2012 00:10, Eric Sandeen wrote:
[]

Just a very quick look:

>  * sparsify - utility to punch out blocks of 0s in a file
> int main(int argc, char **argv)
> {
[]
> 	if (optind == argc) {
> 		printf("Error: no filename specified\n");
> 		usage();
> 	}
> 
> 	fname = argv[optind++];

There's no handling of the case when there are more than one file
specified on the command line.


> 	/*
> 	 * Normalize to blocksize-aligned range:
> 	 * round start down, round end up - get all blocks including the range specified
> 	 */
> 
> 	punch_range_start = round_down(punch_range_start, blocksize);
> 	punch_range_end = round_up(punch_range_end, blocksize);
> 	min_hole = round_up(min_hole, blocksize);
> 	if (!min_hole)
> 		min_hole = blocksize;

I think this deserves some bold warning if punch_range_start
or punch_hole_end is not a multiple of blocksize.

[]
> 	/*
> 	 * Read through the file, finding block-aligned regions of 0s.
> 	 * If the region is at least min_hole, punch it out.
> 	 * This should be starting at a block-aligned offset
> 	 */
> 
> 	while ((ret = read(fd, readbuf, min_hole)) > 0) {
> 
> 		if (!memcmp(readbuf, zerobuf, min_hole)) {

Now this is interesting.  Can ret be < min_hole?  Can a read
in a middle of a file be shorter than specified?

How it will work together with some other operation being done
at the same file -- ftruncate anyone?

Thanks!

/mjt
