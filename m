From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] ext4: ext4_inode_is_fast_symlink should use cluster
 size
Date: Fri, 20 Dec 2013 00:01:28 -0500
Message-ID: <20131220050128.GC23508@thunk.org>
References: <1387435099-11163-1-git-send-email-yangyongqiang01@baidu.com>
 <CAGBYx2a1w+REq6634mOpSZhWWSVuYMuXy48LhAJq7q4kB5Wdew@mail.gmail.com>
 <20131220042246.GA23508@thunk.org>
 <CAGBYx2ay84YFV35g9B7wL0GLN-K_KLLXWp7mBjvF9LBgURfZHA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Yongqiang Yang <yangyongqiang01@baidu.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41874 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751179Ab3LTFBd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 20 Dec 2013 00:01:33 -0500
Content-Disposition: inline
In-Reply-To: <CAGBYx2ay84YFV35g9B7wL0GLN-K_KLLXWp7mBjvF9LBgURfZHA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 20, 2013 at 12:58:47PM +0800, Yongqiang Yang wrote:
> > I can't find the original message you were replying.  I can
> > reconstruct the 2/2 patch, but is there a 1/2 patch that you had meant
> > to send to the linux-ext4 list?
> Interesting, I sent the patch to ext4 list and you. I will resend them.

Thanks.  I couldn't find the patches on either gmane[1] or patchwork[2].

[1] http://news.gmane.org/gmane.comp.file-systems.ext4
[2] http://patchwork.ozlabs.org/project/linux-ext4/list/

So I'm guessing it got lost before reaching vger.kernel.org.

regards,

					- Ted
