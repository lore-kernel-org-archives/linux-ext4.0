From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: ignore ext3/ext2 only mount options
Date: Sun, 4 Mar 2012 22:16:25 -0500
Message-ID: <20120305031625.GD9087@thunk.org>
References: <1330177021-1189-1-git-send-email-teg@jklm.no>
 <20120305024104.GC9087@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Thomas Baechler <thomas@archlinux.org>,
	Tobias Powalowski <tobias.powalowski@googlemail.com>,
	Dave Reisner <d@falconindy.com>
To: Tom Gundersen <teg@jklm.no>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:50710 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755068Ab2CEDQ0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 4 Mar 2012 22:16:26 -0500
Content-Disposition: inline
In-Reply-To: <20120305024104.GC9087@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Mar 04, 2012 at 09:41:04PM -0500, Ted Ts'o wrote:
> Thanks.  This patch will be slightly modified due to some cleanup and
> refactorization in ext4's mount option handling code that I've been
> doing.

Note: the entire patch series can be found here, for those people who
are not subscribed to the linux-ext4 list.

http://thread.gmane.org/gmane.comp.file-systems.ext4/31094

						- Ted
