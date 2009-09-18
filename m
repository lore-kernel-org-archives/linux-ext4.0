From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH, RFC] mke2fs: get device topology values from blkid
Date: Fri, 18 Sep 2009 02:13:41 -0400
Message-ID: <yq1k4zw93vu.fsf@sermon.lab.mkp.net>
References: <4AB2B6B9.7010506@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from acsinet12.oracle.com ([141.146.126.234]:61884 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbZIRGOF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Sep 2009 02:14:05 -0400
In-Reply-To: <4AB2B6B9.7010506@redhat.com> (Eric Sandeen's message of "Thu, 17
	Sep 2009 17:22:49 -0500")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>>>>> "Eric" == Eric Sandeen <sandeen@redhat.com> writes:

Eric> This is just a rough cut, due to the blkid header selection issues
Eric> I mentioned earlier on the list.  It'll also need some config-fu
Eric> to be sure we've got a blkid which has these calls, but with it in
Eric> place, we'll finally have automatic selection of stride/stripe:

What about alignment?

I know that in our friendly DM universe the volume will be aligned.  But
what if the user does mkfs on /dev/sdX and the drive isn't naturally
aligned?

How flexible is the extN on-disk format?  Can you pad and shift things
if need be?

Also, are you guys affected by the previously-acked-sectors-are-now-gone
problems with 512-byte logical/4KB physical drives?

-- 
Martin K. Petersen	Oracle Linux Engineering
