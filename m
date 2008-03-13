From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] ext4: Fix fallocate to update the file size in each
	transaction.
Date: Thu, 13 Mar 2008 01:51:39 -0600
Message-ID: <20080313075139.GI5851@webber.adilger.int>
References: <1205214445-8328-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <20080311055555.GB8108@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: cmm@us.ibm.com, tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:34535 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665AbYCMHxA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Mar 2008 03:53:00 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m2D7qxFv012604
	for <linux-ext4@vger.kernel.org>; Thu, 13 Mar 2008 00:52:59 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JXN00L01SHK5W00@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Thu, 13 Mar 2008 00:52:59 -0700 (PDT)
In-reply-to: <20080311055555.GB8108@skywalker>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mar 11, 2008  11:25 +0530, Aneesh Kumar K.V wrote:
> +	-x: run test after preallocating the area (1|2) 2 to not update size.\n\

The issue with preallocating just a single area in fsx is that this isn't
much different than starting the test with a single large write or truncate.

What would be a lot more useful is to have fsx continually do fallocate
requests of variable sizes during the test.  This would be quite similar
to a "write" operation, except that it wouldn't change any existing data
and holes would still read back as zero.  The only difference is in the
"do not update size" test any fallocate at the end of the file would not
increase the file size.

This would exercise the fallocate code a LOT because it would put unwritten
extents in the middle of the file, map a single fallocate to multiple
discontiguous holes of the file (not overwriting existing allocated data
in the middle of the file), verify fallocate of an overlapping unwritten
extent works, etc.

> +#define FALLOC_FL_KEEP_SIZE	0x01
> +#ifdef __i386__
> +#define __NR_fallocate          324
> +	loff_t offset, maxlen;
> +	offset = 0;
> +	maxlen = maxfilelen;
> +	if (prealloc == 1) {
> +		if (syscall(__NR_fallocate, fd, 0, offset, maxlen) < 0) {
> +			prterr(fname);
> +			exit(97);
> +		}
> +	} else if (prealloc == 2) {
> +		if (syscall(__NR_fallocate, fd, FALLOC_FL_KEEP_SIZE, offset, maxlen) < 0) {
> +			prterr(fname);
> +			exit(97);
> +		}
> +	}
> +#elif defined (__powerpc__)
> +#define __NR_fallocate          309
> +	/* Work only with 32 bit user space */
> +	unsigned int maxlen = maxfilelen;
> +	if (prealloc == 1) {
> +		if (syscall(__NR_fallocate, fd, 0, 0, 0, 0, maxlen) < 0) {
> +			prterr(fname);
> +			exit(97);
> +		}
> +	} else if (prealloc == 2) {
> +		if (syscall(__NR_fallocate, fd, FALLOC_FL_KEEP_SIZE, 0, 0, 0, maxlen) < 0) {
> +			prterr(fname);
> +			exit(97);
> +		}
> +	}
> +#endif

This should be moved into a separate "do_fallocate()" wrapper function
that takes normal fallocate parameters fd, offset, len.  In the future it
would just call "fallocate()" directly.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

