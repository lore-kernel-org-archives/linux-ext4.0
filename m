From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] xfstests-bld: specify inode size in inline test scenario
 conf
Date: Sat, 27 Sep 2014 14:10:49 -0400
Message-ID: <20140927181049.GA11222@thunk.org>
References: <20140926221646.GA20955@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52579 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752525AbaI0SKy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 27 Sep 2014 14:10:54 -0400
Content-Disposition: inline
In-Reply-To: <20140926221646.GA20955@wallace>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 26, 2014 at 06:16:46PM -0400, Eric Whitney wrote:
> Some xfstests use test file systems that are smaller than 512 MB, and
> per the mke2fs.conf default, contain 128 byte inodes.  These tests
> include xfstests generic/015, generic/077, generic/083, and shared/298.
> All of them fail at mkfs time when run in xfstest-bld's inline test
> scenario because the inline data feature requires a minimum inode size
> of 256 bytes.
> 
> Fix this problem by specifying an inode size of 256 bytes in the inline
> conf file.  This allows the tester more flexibility than modifying the
> xfstests themselves.
> 
> This change also makes it possible to run generic/027 successfully and
> in a reasonable amount of time (less than 20 minutes on one x86-64 VM).
> It also fails silently when mkfs'ing its test file system, but then
> proceeds to run and reports success erroneously.
> 
> Signed-off-by: Eric Whitney <enwlinux@gmail.com>

Applied, thanks.

						- Ted
