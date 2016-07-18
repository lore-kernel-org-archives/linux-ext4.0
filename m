From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [4.7-rc6 ext3 BUG] kernel BUG at fs/ext4/xattr.c:1331
Date: Sun, 17 Jul 2016 21:07:16 -0700
Message-ID: <83e3076d-4f84-705d-5259-b3ac1aaf90b7@redhat.com>
References: <20160718022356.GC1922@dastard> <20160718030256.GD1922@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
To: Dave Chinner <david@fromorbit.com>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48602 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750709AbcGREHT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 18 Jul 2016 00:07:19 -0400
In-Reply-To: <20160718030256.GD1922@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 7/17/16 8:02 PM, Dave Chinner wrote:
> # rm !$
> rm /mnt/scratch/fsr_test_file.27768.14.6
> #
> 
> And, by removing an attribute, I can successfully remove the file.
> So this definitely looks like a corner case xattr handling issue in
> ext3/4.

I told xfs/227 that it could run on ext3 and ran it, but this
didn't reproduce for me.

Can you provide a dumpe2fs -h for the root fs, this might depend on
inode size etc.

Thanks,
-Eric
