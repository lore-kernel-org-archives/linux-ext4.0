From: Nick Dokos <nicholas.dokos@hp.com>
Subject: Re: [PATCH 0/6][64-bit] Overview
Date: Fri, 01 May 2009 11:37:30 -0400
Message-ID: <22617.1241192250@gamaville.dokosmarshall.org>
References: <15543.1241167560@gamaville.dokosmarshall.org>  <20090501105757.GD3209@webber.adilger.int>
Reply-To: nick@fc.hp.com
Cc: Nick Dokos <nick@fc.hp.com>, linux-ext4@vger.kernel.org,
	"Theodore Ts'o" <tytso@mit.edu>,
	Valerie Aurora <vaurora@redhat.com>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from qmta05.westchester.pa.mail.comcast.net ([76.96.62.48]:54884
	"EHLO QMTA05.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753373AbZEAPhP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 May 2009 11:37:15 -0400
In-Reply-To: Message from Andreas Dilger <adilger@sun.com>
   of "Fri, 01 May 2009 04:57:58 MDT." <20090501105757.GD3209@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger <adilger@sun.com> wrote:

> Nick,
> sorry to be so slow getting back to you.  Attached are the relatively
> simple test programs we use to verify whether large block devices and
> large filesystems are suffering from block address aliasing.
> 
> The first tool (llverdev) will write either partial or fill data patterns
> to the disk, then read them back and verify the data is still correct.
> 
> The second tool (llverfs) will try to allocate directories spread across
> the filesystem (if possible, using EXT2_TOPDIR_FL) and then fill the
> filesystem partially or fully with a data pattern in ~1GB files and 
> then read them back for verification.
> 
> This isn't really a stress test, but rather just a sanity check for
> variable overflows at different levels of the IO stack.
> 

Andreas,

thanks very much! I'll do some runs over the weekend with them,
as well as some e2fsck runs w/blktrace (with and without lazy
itable init).

Thanks,
Nick

PS. BTW, I have problems receiving email right now - the Reply-to
address above seems to work but my "official" address in the From header
does not.
