From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/1 v2 RESEND] mke2fs: check that auto-detected
 blocksize <= sys_page_size
Date: Thu, 15 Sep 2011 23:11:48 -0400
Message-ID: <20110916031148.GP28181@thunk.org>
References: <1312966123.4477.99.camel@newpride>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Yury V. Zaytsev" <yury@shurup.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:50002 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751596Ab1IPDLw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 Sep 2011 23:11:52 -0400
Content-Disposition: inline
In-Reply-To: <1312966123.4477.99.camel@newpride>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 10, 2011 at 10:48:43AM +0200, Yury V. Zaytsev wrote:
> Block size can be specified manually via the -b option or deduced
> automatically. Unfortunately, the check that it is still smaller than
> the system page size is only performed right after the command line
> options are parsed.
> 
> Therefore, if buggy or inappropriately installed/configured hardware
> hints that larger block sizes have to be used, mkfs will silently create
> a file system which can not be mounted on the system in question.
> 
> By moving the check beyond the last assignment to blocksize it is now
> ensured, that mkfs will issue a warning even if inappropriate blocksize
> was auto-detected.
> 
> The new behavior can be easily tested, by exporting the following
> variables before running mkfs:
> 
>     export MKE2FS_DEVICE_SECTSIZE=8192
>     export MKE2FS_DEVICE_PHYS_SECTSIZE=8192
> 
> Signed-off-by: Yury V. Zaytsev <yury@shurup.com>
> Reviewed-by: Lukas Czerner <lczerner@redhat.com>

Thanks, I've merged this into the next branch.  Apologies for the delay.

	     	    	      	       - Ted
