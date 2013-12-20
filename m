From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] ext4: ext4_inode_is_fast_symlink should use cluster
 size
Date: Thu, 19 Dec 2013 23:22:46 -0500
Message-ID: <20131220042246.GA23508@thunk.org>
References: <1387435099-11163-1-git-send-email-yangyongqiang01@baidu.com>
 <CAGBYx2a1w+REq6634mOpSZhWWSVuYMuXy48LhAJq7q4kB5Wdew@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Yongqiang Yang <yangyongqiang01@baidu.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41859 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753926Ab3LTEWw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 Dec 2013 23:22:52 -0500
Content-Disposition: inline
In-Reply-To: <CAGBYx2a1w+REq6634mOpSZhWWSVuYMuXy48LhAJq7q4kB5Wdew@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 19, 2013 at 02:40:42PM +0800, Yongqiang Yang wrote:
> can be reproduced by xfstests 62 with  bigalloc and 128bit size inode.

Hi Yongqiang,

I can't find the original message you were replying.  I can
reconstruct the 2/2 patch, but is there a 1/2 patch that you had meant
to send to the linux-ext4 list?

Many thanks,

					- Ted
