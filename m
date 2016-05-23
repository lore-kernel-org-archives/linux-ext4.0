From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] mke2fs: fix project quota creation
Date: Sun, 22 May 2016 20:49:54 -0400
Message-ID: <20160523004954.GE6720@thunk.org>
References: <1463883560-2442-1-git-send-email-tytso@mit.edu>
 <CAP9B-QmbOm2uAs9-m6E7FQVpWW-GXU-VwshSMS++-m3P-f8ygw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Wang Shilong <wangshilong1991@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50770 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752685AbcEWAuC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 22 May 2016 20:50:02 -0400
Content-Disposition: inline
In-Reply-To: <CAP9B-QmbOm2uAs9-m6E7FQVpWW-GXU-VwshSMS++-m3P-f8ygw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, May 22, 2016 at 01:34:59PM +0800, Wang Shilong wrote:
> On Sun, May 22, 2016 at 10:19 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> > Creating a file system with project quotas can fail if mke2fs is built
> > using hardening options.  This is because quota_compute_usage() used
> > ext2fs_get_next_inode() instead of ext2fs_get_inode_full(), and a
> > small inode was passed into quota_data_add, when a large inode needs
> > to be used.  As a result get_dq() would end up dereferencing undefined
> > space in the stack.  Without the hardening options, this would be
> > zero, so "mke2fs -t ext4 -O project.quota -I 256 test.img" would work
> > essentially by accident.
> >
> > Fix this by using ext2fs_get_inode_full() so that a large inode is
> > available to quota_data_inodes().
> >
> > Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> 
> I thought Li Xi sent updated e2fsprogs including this fixing parts.
> maybe because you merged early version patches.

There was a separate patch that broke ABI backwards compatibility of
e2fsprogs' shared libraries, which I rejected on those grounds,
perhaps that's what you thinking of?  It wasn't clear that the patch
was in fact fixing a problem, as opposed to just being a clean up.  So
I didn't realize there was a problem that needed fixing.

  	 	       	     	     	  - Ted
