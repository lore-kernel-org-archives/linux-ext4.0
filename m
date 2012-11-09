From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] Remove VLAIS usage from JBD2 code
Date: Fri, 9 Nov 2012 15:19:12 -0800
Message-ID: <20121109231912.GA6444@blackbox.djwong.org>
References: <1351622404-18214-1-git-send-email-behanw@converseincode.com>
 <1351622404-18214-2-git-send-email-behanw@converseincode.com>
 <20121030191307.GC19576@blackbox.djwong.org>
 <20121108155307.GB766@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Behan Webster <behanw@converseincode.com>,
	linux-ext4@vger.kernel.org, Mark Charlebois <charlebm@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:25166 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037Ab2KIXTT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Nov 2012 18:19:19 -0500
Content-Disposition: inline
In-Reply-To: <20121108155307.GB766@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 08, 2012 at 10:53:07AM -0500, Theodore Ts'o wrote:
> Hey Darrick,
> 
> I was looking at this code a bit more closely while applying the
> revised version of this patch --- and this in particular raised a red
> flag for me:
> 
>      *(u32 *)desc.ctx = crc;
>      	   ...
>      return *(u32 *)desc.ctx;
> 
> Does this raise any byte swapping issues?  Looking at how the crc32
> code in crypto/ works, I'm almost certain this is broken on big-endian
> systems, and we need to add le32_to_cup() and cpu_to_le32() calls here.
> 
> Am I missing something?

crc32_[bl]e_generic() in lib/crc32.c contains the appropriate be/le-to-cpu
conversion calls to ensure that the results are always returned in cpu-endian
format.  The crypto/crc32.c file is basically just a crypto-hash wrapper around
the lib/crc32.c code, and don't touch the endianness at all.  The ext4 code
receives the results from the crypto code in cpu-endian format and always
converts it to (or from) little-endian format when accessing disk structures.

As far as e2fsprogs, it leaves the checksums in le format, only converting it
to cpu-endian format when verifying or setting the checksum.

--D
> 
> 	     	     	    		  - Ted
