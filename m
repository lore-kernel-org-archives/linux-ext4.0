From: Andreas Dilger <adilger@sun.com>
Subject: Re: Large volume ll_ver_fs results (w/ short read/write patch).
Date: Wed, 19 Aug 2009 19:04:14 -0600
Message-ID: <20090820010414.GA649@webber.adilger.int>
References: <20654.1250520912@gamaville.dokosmarshall.org>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: Nick Dokos <nicholas.dokos@hp.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:59853 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975AbZHTBES (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 19 Aug 2009 21:04:18 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n7K14JsV011115
	for <linux-ext4@vger.kernel.org>; Wed, 19 Aug 2009 18:04:19 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KON00I00HLIRW00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Wed,
 19 Aug 2009 18:04:19 -0700 (PDT)
In-reply-to: <20654.1250520912@gamaville.dokosmarshall.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Aug 17, 2009  10:55 -0400, Nick Dokos wrote:
> There were two disk errors encountered that resulted in short reads, but
> the patched ll_ver_fs continued on (patch attached). So two chunks (1MB
> each) were not completely verified (only the part that was read
> successfully was), but the rest of the fs checked out OK. Luckily, the
> fsck did not find any errors: both disk errors were in file data.
> We have replaced the disks but are not planning to repeat the test: it's
> not clear that it would tells us anything more at this point.

> write File name: /mnt/dir00725/file011          
> write complete
> 
> read File name: /mnt/dir00725/file010          
> read complete

Nick, thanks for the patch.  I'm incorporating the fixes upstream,
but one question that was raised is that (in essence) this allows
IO errors to be hit, yet and the return code from llverfs is 0.
The llverdev/llverfs tools are used not only for finding software
data corruption bugs, but also to verify the underlying media.

It was definitely a bug in the original code that there was no
error reported during the write phase if there was a short write,
but this was at least caught during the read phase because the
data would be incorrect.

What I've done is to count errors hit during read and write, and
then exit with a non-zero value if there were any IO errors hit
(as happened in your case), even if the rest of the data was
verified correctly.  This allows scanning the whole disk in a
single pass (if there are not too many underlying errors) but
still ensuring there is no false sense of security because the
program exited with 0.

The current patch can be gotten at:

https://bugzilla.lustre.org/attachment.cgi?id=25407&action=edit

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

