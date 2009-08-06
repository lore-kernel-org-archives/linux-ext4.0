From: Nick Dokos <nicholas.dokos@hp.com>
Subject: Re: ll_ver_fs data verification failure - 96TB fs
Date: Thu, 06 Aug 2009 18:01:04 -0400
Message-ID: <18945.1249596064@alphaville.usa.hp.com>
References: <28623.1249307676@gamaville.dokosmarshall.org> <20090806200400.GC1800@shell> <18249.1249591034@alphaville.usa.hp.com> <20090806205002.GH3340@webber.adilger.int> <18690.1249594088@alphaville.usa.hp.com>  <18822.1249594980@alphaville.usa.hp.com>
Reply-To: nicholas.dokos@hp.com
Cc: Valerie Aurora <vaurora@redhat.com>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from g1t0027.austin.hp.com ([15.216.28.34]:26181 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677AbZHFWBC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Aug 2009 18:01:02 -0400
Cc: nicholas.dokos@hp.com
In-Reply-To: Message from Nick Dokos <nicholas.dokos@hp.com>
   of "Thu, 06 Aug 2009 17:43:00 EDT." <18822.1249594980@alphaville.usa.hp.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Nick Dokos <nicholas.dokos@hp.com> wrote:

> Nick Dokos <nicholas.dokos@hp.com> wrote:
> 
> > > On Aug 06, 2009  16:37 -0400, Nick Dokos wrote:
> > > > I did that to begin with but the problem turns out to be much more
> > > > mundane: there was an IO error on one of the volumes. It wasn't quite
> > > > obvious (no red lights going off) but there *was* a message in
> > > > /var/log/messages - unfortunately I missed it. I eventually recreated
> > > > the error by trying to read the file with ``od -c'' and then went back
> > > > and found the original error. I don't know why/how ll_ver_fs managed to
> > > > read the offset and come up with a 1M difference[1] -- ``od -c'' failed with
> > > > a big thud.
> > > 
> > > Can you have a look at the error handling in ll_ver_fs at that point?
> > > It seems that it might just have re-used the previous 1MB buffer, but
> > > didn't detect/report the error from the read, which would itself be bad.
> > > 
> > 
> > It looks right to me:
> > 
> > ,----
> > |               ...
> > | 		if (read(fd, chunk_buf, chunksize) < 0) {
> > | 			fprintf(stderr, "\n%s: read %s+%llu failed: %s\n",
> > | 				progname, file, offset, strerror(errno));
> > | 			return 1;
> > | 		}
> > | 		if (verify_chunk(chunk_buf, chunksize, offset, time_st,
> > | 				 inode_st, file) != 0)
> > | 			return 1;
> > |               ...
> > `----
> > 
> > The read() should have failed (and I should have gotten a different error
> > message) but somehow it didn't - instead, verify_chunk() was called and
> > *that* detected the mismatch.
> > 
> 
> The offset starts at 0 and is marched along at a 1MB stride, so it's
> conceivable that the read() returned 0 (avoiding the error return) and
> did not touch chunk_buf (thereby leading to the verify_chunk() failure).
> 
> That would be consistent with what I got, but if so, it would be a kernel
> bug somewhere in the read() calling sequence, right?
> 
> Thanks,
> Nick
> 
> PS. For the record, this is the error from /var/log/messages:
> 
> ,----
> | ...
> | Aug  5 18:14:11 shifter kernel: sd 10:0:7:3: [sdn] Unhandled sense code
> | Aug  5 18:14:11 shifter kernel: sd 10:0:7:3: [sdn] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> | Aug  5 18:14:11 shifter kernel: sd 10:0:7:3: [sdn] Sense Key : Medium Error [current] 
> | Aug  5 18:14:11 shifter kernel: sd 10:0:7:3: [sdn] Add. Sense: No additional sense information
> | Aug  5 18:14:11 shifter kernel: end_request: I/O error, dev sdn, sector 2238819328
> | Aug  5 18:16:03 shifter kernel: sd 10:0:7:3: [sdn] Unhandled sense code
> | Aug  5 18:16:03 shifter kernel: sd 10:0:7:3: [sdn] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> | Aug  5 18:16:03 shifter kernel: sd 10:0:7:3: [sdn] Sense Key : Medium Error [current] 
> | Aug  5 18:16:03 shifter kernel: sd 10:0:7:3: [sdn] Add. Sense: No additional sense information
> | Aug  5 18:16:03 shifter kernel: end_request: I/O error, dev sdn, sector 2238819592
> `----
> 

Jim Owens pointed out to me that the code doesn't deal correctly with
short reads.  The verification information is at the beginning of every
4kB block, so the sector error causes a short read with exactly the
symptoms I see.  The next read() would get the error.

The code should  perhaps read something like this:

 		if ((nread = read(fd, chunk_buf, chunksize)) < 0) {
 			fprintf(stderr, "\n%s: read %s+%llu failed: %s\n",
 				progname, file, offset, strerror(errno));
 			return 1;
 		}
                if (nread < chunksize) {
                        fprintf(stderr, "short read etc");
                        /* or force the next read() to check for errors? */
                        return 1;
                }
 		if (verify_chunk(chunk_buf, chunksize, offset, time_st,
 				 inode_st, file) != 0)
 			return 1;

Thanks,
Nick
