From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Fwd: [RESEND PATCH 2/2] ext4: ext4_inode_is_fast_symlink should
 use cluster size
Date: Mon, 6 Jan 2014 09:51:45 -0500
Message-ID: <20140106145145.GC13648@thunk.org>
References: <1387515880-10185-1-git-send-email-yangyongqiang01@baidu.com>
 <1387515880-10185-2-git-send-email-yangyongqiang01@baidu.com>
 <CAGBYx2Zx7jnK-DmM7=RCCVwz4N0FfE_-=eETO8OkLt5McCXttg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46277 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751341AbaAFOvr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 6 Jan 2014 09:51:47 -0500
Content-Disposition: inline
In-Reply-To: <CAGBYx2Zx7jnK-DmM7=RCCVwz4N0FfE_-=eETO8OkLt5McCXttg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 20, 2013 at 01:13:33PM +0800, Yongqiang Yang wrote:
> From: Yongqiang Yang <xiaoqiangnk@gmail.com>
> 
> can be reproduced by xfstests 62 with  bigalloc and 128bit size inode.
> 
> Signed-off-by: Yongqiang Yang <yangyongqiang01@baidu.com>

Thanks, applied.

						- Ted
