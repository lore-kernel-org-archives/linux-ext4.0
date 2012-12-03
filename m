From: Tao Ma <tm@tao.ma>
Subject: Re: [ext4:dev 39/57] (.text+0x10b24): multiple definition of `walk_page_buffers'
Date: Mon, 03 Dec 2012 13:03:27 +0800
Message-ID: <50BC329F.8030707@tao.ma>
References: <50bc2b11.LsekEeO+H00dsdNO%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Tao Ma <boyu.mt@taobao.com>, linux-ext4@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>
To: kbuild test robot <fengguang.wu@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:60981 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750710Ab2LCFDc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Dec 2012 00:03:32 -0500
In-Reply-To: <50bc2b11.LsekEeO+H00dsdNO%fengguang.wu@intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Fengguang,
	thanks for the update.
	Yeah, I guess we should rename it to ext4_walk_page_buffers to avoid
the future complaint.

Thanks
Tao

On 12/03/2012 12:31 PM, kbuild test robot wrote:
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git dev
> head:   b0c30cdb0d3fcf5a04de4a46fceba767cf8be022
> commit: c99dcc3889f574139c8c8a2699664dc31bccd415 [39/57] ext4: add normal write support for inline data
> config: make ARCH=i386 allyesconfig
> 
> All error/warnings:
> 
> fs/ocfs2/built-in.o: In function `walk_page_buffers':
> (.text+0x10b24): multiple definition of `walk_page_buffers'
> fs/ext4/built-in.o:(.text+0x72b3): first defined here
> 
> ---
> 0-DAY kernel build testing backend         Open Source Technology Center
> Fengguang Wu, Yuanhan Liu                              Intel Corporation
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

