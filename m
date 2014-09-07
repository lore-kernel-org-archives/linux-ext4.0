From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] ext4: use mkfs.ext4 -F instead of piping in yes
Date: Sun, 7 Sep 2014 08:49:27 -0700
Message-ID: <20140907154927.GA23630@infradead.org>
References: <1410092942-22201-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fstests@vger.kernel.org,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>,
	Eryu Guan <eguan@redhat.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44252 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437AbaIGPt2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 7 Sep 2014 11:49:28 -0400
Content-Disposition: inline
In-Reply-To: <1410092942-22201-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Sep 07, 2014 at 08:29:02AM -0400, Theodore Ts'o wrote:
> Using "yes | mkfs.ext4 ..." results in the error message results in
> the test failing, at least for some versions of e2fsprogs:
> 
>     +yes: standard output: Broken pipe
>     +yes: write error
> 
> It better to use the -F option, which will eliminate the questions.

Looks good, but maybe we should have a $MKFS_EXT4_PROG variable similar
to $MKFS_XFS_PROG so that we can set this in one place?
