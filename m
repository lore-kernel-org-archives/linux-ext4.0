From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2] Rename copy_file_range to copy_file_chunk
Date: Mon, 1 Jan 2018 23:41:22 -0500
Message-ID: <20180102044122.GI2532@thunk.org>
References: <20171229035539.GB11757@thunk.org>
 <20171229181951.24886-1-palmer@dabbelt.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, patches@groups.riscv.org
To: Palmer Dabbelt <palmer@dabbelt.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41598 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750819AbeABElY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 1 Jan 2018 23:41:24 -0500
Content-Disposition: inline
In-Reply-To: <20171229181951.24886-1-palmer@dabbelt.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 29, 2017 at 10:19:51AM -0800, Palmer Dabbelt wrote:
> As of 2.27, glibc will have a copy_file_range library call to wrap the
> new copy_file_range system call.  This conflicts with the function in
> misc/create_inode.c, which this patch renames _copy_file_range.

Thanks, applied.

					- Ted
