From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] Remove VLAIS usage from JBD2 code
Date: Fri, 9 Nov 2012 15:24:51 -0800
Message-ID: <20121109232451.GA11827@blackbox.djwong.org>
References: <1351622404-18214-1-git-send-email-behanw@converseincode.com>
 <1351622404-18214-2-git-send-email-behanw@converseincode.com>
 <20121030191307.GC19576@blackbox.djwong.org>
 <20121108155307.GB766@thunk.org>
 <20121109231912.GA6444@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Behan Webster <behanw@converseincode.com>,
	linux-ext4@vger.kernel.org, Mark Charlebois <charlebm@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:21051 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659Ab2KIXY5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Nov 2012 18:24:57 -0500
Content-Disposition: inline
In-Reply-To: <20121109231912.GA6444@blackbox.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 09, 2012 at 03:19:12PM -0800, Darrick J. Wong wrote:
> On Thu, Nov 08, 2012 at 10:53:07AM -0500, Theodore Ts'o wrote:
> > Hey Darrick,
> > 
> > I was looking at this code a bit more closely while applying the
> > revised version of this patch --- and this in particular raised a red
> > flag for me:
> > 
> >      *(u32 *)desc.ctx = crc;
> >      	   ...
> >      return *(u32 *)desc.ctx;
> > 
> > Does this raise any byte swapping issues?  Looking at how the crc32
> > code in crypto/ works, I'm almost certain this is broken on big-endian
> > systems, and we need to add le32_to_cup() and cpu_to_le32() calls here.
> > 
> > Am I missing something?
> 
> crc32_[bl]e_generic() in lib/crc32.c contains the appropriate be/le-to-cpu
> conversion calls to ensure that the results are always returned in cpu-endian
> format.  The crypto/crc32.c file is basically just a crypto-hash wrapper around
> the lib/crc32.c code, and don't touch the endianness at all.  The ext4 code
> receives the results from the crypto code in cpu-endian format and always
> converts it to (or from) little-endian format when accessing disk structures.
> 
> As far as e2fsprogs, it leaves the checksums in le format, only converting it
> to cpu-endian format when verifying or setting the checksum.

I forgot to mention -- I tried creating a metadata_csum filesystem on an x86
box.  Then I bounced it between that machine and my one remaining ppc32 box,
running a mount/read/write/unmount/fsck script on each bounce.  I didn't see
any errors.  Sadly, I no longer have anything weirder (sparc64/s390x) to test.

--D
> 
> --D
> > 
> > 	     	     	    		  - Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
