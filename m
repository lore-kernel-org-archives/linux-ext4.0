From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] ext4: Fix to read empty directory blocks correctly in	64k
 blocksize filesystems
Date: Wed, 11 Feb 2009 00:48:16 -0500
Message-ID: <20090211054816.GP3209@webber.adilger.int>
References: <4990FAE4.1080009@cn.fujitsu.com>
 <20090210152049.GF30689@mini-me.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Wei Yongjun <yjwei@cn.fujitsu.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:50459 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbZBKFs0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 11 Feb 2009 00:48:26 -0500
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n1B5mJSc022338
	for <linux-ext4@vger.kernel.org>; Tue, 10 Feb 2009 21:48:19 -0800 (PST)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7.0-3.01 64bit (built Dec 23 2008))
 id <0KEV00G00ZZXYQ00@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Tue,
 10 Feb 2009 21:48:19 -0800 (PST)
In-reply-to: <20090210152049.GF30689@mini-me.lan>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Feb 10, 2009  10:20 -0500, Theodore Ts'o wrote:
> The rec_len field in the directory entry is 16 bits, so there was a
> problem representing rec_len for filesystems with a 64k block size in
> the case where the directory entry takes the entire 64k block.
> Unfortunately, there were two schemes that were proposed; one where
> all zeros meant 65536 and one where all ones (65535) meant 65536.
> E2fsprogs used 0, whereas the kernel used 65535.  Oops.  Fortunately
> this case happens extremely rarely, with the most common case being
> the lost+found directory, created by mke2fs.
> 
> So we will be liberal in what we accept, and accept both encodings,
> but we will continue to encode 65536 as 65535.  This will require a
> change in e2fsprogs, but with fortunately ext4 filesystems normally
> have the dir_index feature enabled, which precludes having a
> completely empty directory block.

I'm glad that the MAX_REC_LEN value is being kept, because "0" is
too easily hit due to disk corruption.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

