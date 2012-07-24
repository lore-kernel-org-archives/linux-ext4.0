From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: "Setting filesystem feature 'metadata_csum' not supported" when
 trying to enable ext4 metadata checksums
Date: Tue, 24 Jul 2012 15:50:00 +0800
Message-ID: <20120724075000.GA10906@gmail.com>
References: <500E4384.4090002@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Tomasz Chmielewski <mangoo@wpkg.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:47349 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755084Ab2GXHlT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 24 Jul 2012 03:41:19 -0400
Received: by gglu4 with SMTP id u4so6351510ggl.19
        for <linux-ext4@vger.kernel.org>; Tue, 24 Jul 2012 00:41:19 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <500E4384.4090002@wpkg.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 24, 2012 at 01:41:08PM +0700, Tomasz Chmielewski wrote:
> With Linux 3.5, it should be possible to use ext4 metadata
> checksums; enabling of which should be made with the following
> command:
> 
> 
> # tune2fs -O metadata_csum /dev/sda1
> tune2fs 1.42 (29-Nov-2011)
> Setting filesystem feature 'metadata_csum' not supported.
> 
> 
> Running kernel 3.5, tried the latest e2fsprogs from git.

Hi Tomasz,

Could you please checkout the 'pu' branch in e2fsprogs?  You need to
use pu branch of e2fsprogs because the patches of metadata checksum
for e2fsprogs are in this branch.

BTW, until 3.5 kernel, it seems that metadata checksum still has a bug.
Here is a patch to fix this bug [1].

1. http://www.spinics.net/lists/linux-ext4/msg32685.html

Regards,
Zheng
