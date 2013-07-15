From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Beginner questions about ext4
Date: Mon, 15 Jul 2013 14:59:53 -0400
Message-ID: <20130715185953.GE26359@thunk.org>
References: <loom.20130612T140739-743@post.gmane.org>
 <loom.20130623T082353-563@post.gmane.org>
 <20130623115953.GA16193@thunk.org>
 <CACyNnZOkmpkTtDU_-6D9iC3aKOnP4n-XoO1_XJq=Hn2=BnEQYQ@mail.gmail.com>
 <20130715134357.GA26359@thunk.org>
 <CACyNnZPnzEbcFj69+fGjm1rkLay51WTXFMqr25AOzY3vtvegpw@mail.gmail.com>
 <20130715163720.GC26359@thunk.org>
 <CACyNnZMxN7p9k0UOFLNmKL6sV0k+grNh85UpPJVyHck9pA7M5w@mail.gmail.com>
 <20130715181037.GD26359@thunk.org>
 <CACyNnZN7jGKYp5P87+OYJzAa-iVWMvBSujBh==A=w642RFDUvQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Felipe Monteiro de Carvalho <felipemonteiro.carvalho@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:38035 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754065Ab3GOS75 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 15 Jul 2013 14:59:57 -0400
Content-Disposition: inline
In-Reply-To: <CACyNnZN7jGKYp5P87+OYJzAa-iVWMvBSujBh==A=w642RFDUvQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 15, 2013 at 08:18:16PM +0200, Felipe Monteiro de Carvalho wrote:
> wow, that's a pretty amazing tool, didn't know about it.

Are you familiar with debugfs?  I'd also strongly suggest that you try
using that program to try to understand the file system layout.

>But my table of group descriptors read from group nr 0 is all correct
>between group nr 0 and 31, but group nr 32 to 63 are filled with
>zeroes.

> Filesystem features:      has_journal ext_attr resize_inode dir_index filetype needs_recovery extent flex_bg sparse_super large_file huge_file uninit_bg dir_nlink extra_isize

The file system does not have the 64-bit feature set.  Hence, the
layout of the block grup descriptor is struct ext2_group_desc, and not
struct ext4_group_desc.

I'm guessing that you were using the ext4_group_desc structure (which
is 64 bytes) instead of the ext2_group_desc structure (which is 32
bytes).

I would suggest that you match up the contents of your in-program data
structures, and compare it to the outputs of debugfs and dumpe2fs.

						- Ted
