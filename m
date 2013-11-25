From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: Invalid filesystem option set: inline_data
Date: Mon, 25 Nov 2013 10:37:20 +0800
Message-ID: <20131125023720.GA11713@gmail.com>
References: <CAM16AnBtv5UE0LN_hzsUjWRV33Pd_TuXkgLxmQRAFjS86MY9-g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: d lopez <dlopezzz63@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:62224 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753280Ab3KYCee (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 24 Nov 2013 21:34:34 -0500
Received: by mail-pd0-f173.google.com with SMTP id p10so4509642pdj.18
        for <linux-ext4@vger.kernel.org>; Sun, 24 Nov 2013 18:34:33 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <CAM16AnBtv5UE0LN_hzsUjWRV33Pd_TuXkgLxmQRAFjS86MY9-g@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

On Sun, Nov 24, 2013 at 06:19:06PM +0100, d lopez wrote:
> Hello,
> 
> I'm trying to use inline_data with kernel 3.11.9, but it doesn't seem to
> work.
> 
> # mkfs.ext4 -O inline_data -m 0 -v  /dev/sdb12
> mke2fs 1.42.8 (20-Jun-2013)
> Invalid filesystem option set: inline_data

Please use e2fsprogs/pu branch.  All patches with inline_data support
are on this branch.  You can use the following commands to get the
latest source code of e2fsprogs.

% git clone git://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git
% git checkout -b pu origin/pu

Regards,
                                                - Zheng
