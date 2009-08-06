From: Andreas Dilger <adilger@sun.com>
Subject: Re: ll_ver_fs data verification failure - 96TB fs
Date: Thu, 06 Aug 2009 16:19:27 -0600
Message-ID: <20090806221927.GI3340@webber.adilger.int>
References: <28623.1249307676@gamaville.dokosmarshall.org>
 <20090806200400.GC1800@shell> <18249.1249591034@alphaville.usa.hp.com>
 <20090806205002.GH3340@webber.adilger.int>
 <18690.1249594088@alphaville.usa.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: Valerie Aurora <vaurora@redhat.com>, linux-ext4@vger.kernel.org
To: Nick Dokos <nicholas.dokos@hp.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:37143 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243AbZHFWTt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Aug 2009 18:19:49 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n76MJkAM010261
	for <linux-ext4@vger.kernel.org>; Thu, 6 Aug 2009 15:19:47 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.02 64bit (built Apr 16 2009))
 id <0KNZ00F0076JZB00@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Thu,
 06 Aug 2009 15:19:46 -0700 (PDT)
In-reply-to: <18690.1249594088@alphaville.usa.hp.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Aug 06, 2009  17:28 -0400, Nick Dokos wrote:
> > On Aug 06, 2009  16:37 -0400, Nick Dokos wrote:
> > Can you have a look at the error handling in ll_ver_fs at that point?
> > It seems that it might just have re-used the previous 1MB buffer, but
> > didn't detect/report the error from the read, which would itself be bad.
> 
> It looks right to me:
> 
> ,----
> |               ...
> | 		if (read(fd, chunk_buf, chunksize) < 0) {
> | 			fprintf(stderr, "\n%s: read %s+%llu failed: %s\n",
> | 				progname, file, offset, strerror(errno));
> | 			return 1;
> | 		}
> | 		if (verify_chunk(chunk_buf, chunksize, offset, time_st,
> | 				 inode_st, file) != 0)
> | 			return 1;
> |               ...
> `----
> 
> The read() should have failed (and I should have gotten a different error
> message) but somehow it didn't - instead, verify_chunk() was called and
> *that* detected the mismatch.

Well, it seems possible that read() returned less than chunksize bytes,
and the buffer compared correctly up to the 4kB chunk that is beyond the
read data.  That looks like a small bug in llverfs, since it is legal
for read() to return less than the requested bytes.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

