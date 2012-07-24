From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: "Setting filesystem feature 'metadata_csum' not supported" when
 trying to enable ext4 metadata checksums
Date: Tue, 24 Jul 2012 17:44:45 +0800
Message-ID: <20120724094445.GA11369@gmail.com>
References: <500E4384.4090002@wpkg.org>
 <20120724075000.GA10906@gmail.com>
 <500E6209.2060604@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Tomasz Chmielewski <mangoo@wpkg.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:49015 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200Ab2GXJgI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 24 Jul 2012 05:36:08 -0400
Received: by yenl2 with SMTP id l2so6418596yen.19
        for <linux-ext4@vger.kernel.org>; Tue, 24 Jul 2012 02:36:08 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <500E6209.2060604@wpkg.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 24, 2012 at 03:51:21PM +0700, Tomasz Chmielewski wrote:
> On 07/24/2012 02:50 PM, Zheng Liu wrote:
> 
> >Could you please checkout the 'pu' branch in e2fsprogs?  You need to
> >use pu branch of e2fsprogs because the patches of metadata checksum
> >for e2fsprogs are in this branch.
> >
> >BTW, until 3.5 kernel, it seems that metadata checksum still has a bug.
> >Here is a patch to fix this bug [1].
> >
> >1. http://www.spinics.net/lists/linux-ext4/msg32685.html
> 
> OK, tried with pu branch and got this:
> 
> root@s9:/usr/src/e2fsprogs# misc/tune2fs -O metadata_csum /dev/sda1
> tune2fs 1.42.3 (14-May-2012)
> rewrite_directory: Unknown code kJe 176 while rewriting directories
> 
> Expected?

No, it seems that it is not our expectation.  Could you please provide
more information?  Such as feature list.  Use "debugfs -R
'stats' /dev/${DEVICE}" to get it, please.

Regards,
Zheng
