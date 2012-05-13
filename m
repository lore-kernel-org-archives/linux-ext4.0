From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix the code style from printk to ext_debug in
 extents.c
Date: Sun, 13 May 2012 00:20:06 -0400
Message-ID: <20120513042006.GA31866@thunk.org>
References: <CADxeRwnv7quZbWn9xZ=KnEg_KyT65DApEt57zDdgeYsRgQKYQw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Steven Liu <lingjiujianke@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:56753 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750749Ab2EMEUK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 13 May 2012 00:20:10 -0400
Content-Disposition: inline
In-Reply-To: <CADxeRwnv7quZbWn9xZ=KnEg_KyT65DApEt57zDdgeYsRgQKYQw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, May 12, 2012 at 11:57:13PM +0800, Steven Liu wrote:
> Hi Ted,
> 
> just fix the printk debug to ext_debug, if undefined the EXT_DEBUG
> it will not output the debug message
> 
> Signed-off-by: LiuQi <liuqi@zecloud.cn>

I'm not sure what's the point?  The code in question is all under a
CHECK_BINSEARCH, which is in itself a debugging option.

		       	     	      		- Ted
