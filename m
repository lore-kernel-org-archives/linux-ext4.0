From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] [PATCH] xfstests: use -F when making scratch ext4 fs
Date: Fri, 26 Apr 2013 17:09:28 -0600
Message-ID: <E173CD13-2FD1-45A4-BEAE-815A9DEC4B62@dilger.ca>
References: <1367003813-17686-1-git-send-email-jbacik@fusionio.com> <517AD302.4000905@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Josef Bacik <jbacik@fusionio.com>, linux-ext4@vger.kernel.org,
	xfs@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f175.google.com ([209.85.192.175]:50368 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103Ab3DZXJb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 26 Apr 2013 19:09:31 -0400
Received: by mail-pd0-f175.google.com with SMTP id g12so848552pdj.34
        for <linux-ext4@vger.kernel.org>; Fri, 26 Apr 2013 16:09:31 -0700 (PDT)
In-Reply-To: <517AD302.4000905@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2013-04-26, at 1:18 PM, Eric Sandeen wrote:
> On 4/26/13 2:16 PM, Josef Bacik wrote:
>> mkfs.ext4 will ask you if you are sure if you try to mkfs an entire disk instead of just a partition, so any xfstest that uses a scratch device and you specify a full disk will appear to hang because it's waiting for you to say yes.  This fixes the problem by just forcing it to do its thing.  Thanks,
>> 
>> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> 
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> 
> The whole-disk test is pretty derpy anyway. Too bad -F overrides
> much more than just that, but this is probably a decent
> thing to do.

Yeah, we've had to work around the whole-device check for years,
because the 512-byte sector offset for the DOS partition table
kills performance on RAID systems.

Given that the kernel should hold the whole block device busy these
days for O_EXCL opens if there are partitions on the device, it
should be safe to remove this check from mke2fs, though the above
workaround would still be needed for a while.

Cheers, Andreas





