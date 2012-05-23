From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH RESEND] ext4: make sure O_(D)SYNC semantic in
 ext4_fallocate()
Date: Wed, 23 May 2012 09:19:41 +0800
Message-ID: <20120523011941.GA6830@gmail.com>
References: <1326703663-4801-1-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Zheng Liu <wenqing.lz@taobao.com>, Theodore Ts'o <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61822 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754446Ab2EWBMR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 22 May 2012 21:12:17 -0400
Received: by dady13 with SMTP id y13so8985108dad.19
        for <linux-ext4@vger.kernel.org>; Tue, 22 May 2012 18:12:17 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1326703663-4801-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 16, 2012 at 04:47:43PM +0800, Zheng Liu wrote:
> Ext4 must make sure the transaction to be commited to the disk when user opens
> a file with O_(D)SYNC flag and do a fallocate(2) call.
> 
> This problem had been reported by Christoph Hellwig in this thread:
> http://www.spinics.net/lists/linux-btrfs/msg13621.html

Hi Ted,

Could you please review this patch?  Thank you.

Regards,
Zheng  
