From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [ext4:dev 47/50] fs/ext4/indirect.c:1799 ext4_ind_punch_hole()
 warn: inconsistent returns mutex:&inode->i_mutex: locked (1710) unlocked
 (1799)
Date: Fri, 28 Sep 2012 09:20:55 -0400
Message-ID: <20120928132055.GC13352@thunk.org>
References: <20120928060719.GA15218@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Zheng Liu <wenqing.lz@taobao.com>, kernel-janitors@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Fengguang Wu <fengguang.wu@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:52856 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754691Ab2I1NVA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 28 Sep 2012 09:21:00 -0400
Content-Disposition: inline
In-Reply-To: <20120928060719.GA15218@localhost>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 28, 2012 at 02:07:19PM +0800, Fengguang Wu wrote:
> Hi Zheng,
> 
> FYI, there are new smatch warnings show up in
> 
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git dev
> head:   b2f1a8e5612e2488a3995ec06b422b44651d088b
> commit: 3e1b02687146ddefa8e53c2a5e13d3bd87b16b09 [47/50] ext4: add support for hole punching non-extent-mapped files

I'm going to be dropping the indirect punch hole patches from the ext4
dev tree, based on the number of xfstests failures that I found in my
overnight testing.

I had hoped the changes were small and localized, and wouldn't cause
problems if the punch hole feature wasn't used, but at this point,
given that many distributions are starting to use the ext4 file system
for legacy ext3 file systems, my judgement is that the risks are too
great for the upcoming merge window; so this will probably need to
wait for the next development cycle.

     	     	  	  				- Ted

