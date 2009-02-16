From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] ext4: Fix to read empty directory blocks correctly in	64k
 blocksize filesystems
Date: Mon, 16 Feb 2009 16:32:56 -0700
Message-ID: <20090216233256.GI3199@webber.adilger.int>
References: <4990FAE4.1080009@cn.fujitsu.com>
 <20090210152049.GF30689@mini-me.lan>
 <20090211054816.GP3209@webber.adilger.int> <20090211151547.GK29220@mini-me.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Wei Yongjun <yjwei@cn.fujitsu.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:42582 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592AbZBPXdL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Feb 2009 18:33:11 -0500
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n1GNX8DR011241
	for <linux-ext4@vger.kernel.org>; Mon, 16 Feb 2009 15:33:08 -0800 (PST)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7.0-3.01 64bit (built Dec 23 2008))
 id <0KF600B00LT6UY00@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Mon,
 16 Feb 2009 15:14:13 -0800 (PST)
In-reply-to: <20090211151547.GK29220@mini-me.lan>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Feb 11, 2009  10:15 -0500, Theodore Ts'o wrote:
> On Wed, Feb 11, 2009 at 12:48:16AM -0500, Andreas Dilger wrote:
> > I'm glad that the MAX_REC_LEN value is being kept, because "0" is
> > too easily hit due to disk corruption.
> 
> I'm not too worried about that, actually.  If there is a disk
> corruption, we will detect it easily enough no matter which encoding
> we use.  I am thinking though that neither 65535 nor 0 is the best way
> of encoding 65536.  In fact, I would suggest the encoding 0x01.
> Specifically, I suggest:
> 
> 	     (rec_len & 65532) | ((rec_len >> 16) & 3)
> 
> This encodes valid rec_len values in the range 0 through 2**18-4, and
> allows for maximum block sizes of up to 256k.  To retain backwards
> compatibility, and to allow for a 256k blocksize, we can have a
> special case where a rec_len of either 0 or 65535 means
> EXT4_BLOCK_SIZE(s).
> 
> It's unlikely we'll see VM pages of up to 256k, but at some point we
> might find that the Linux VM has been enhanced to support filesystem
> block sizes > than the VM page size, at which point it might be useful
> for some applications to allow very large filesystem block sizes.

There are probably a dozen other places in the ext* code that expect
blocksize <= 65536, so I don't think this new encoding is really helping
us at all.  We are already restricted to 2^32-1 inodes due to the dirent
format and I expect we will have changed the dirent format by that time
anyways.

I'd rather keep this change as simple as possible (i.e. the original
65535 or 0 values, preferring 65535).

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

