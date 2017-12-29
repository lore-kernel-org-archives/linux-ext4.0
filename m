From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] Rename copy_file_range to _copy_file_range
Date: Thu, 28 Dec 2017 22:55:39 -0500
Message-ID: <20171229035539.GB11757@thunk.org>
References: <20171229021828.5661-1-palmer@dabbelt.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, patches@groups.riscv.org
To: Palmer Dabbelt <palmer@dabbelt.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:34266 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753732AbdL2Dzl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 28 Dec 2017 22:55:41 -0500
Content-Disposition: inline
In-Reply-To: <20171229021828.5661-1-palmer@dabbelt.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 28, 2017 at 06:18:28PM -0800, Palmer Dabbelt wrote:
> As of 2.27, glibc will have a copy_file_range library call to wrap the
> new copy_file_range system call.  This conflicts with the function in
> misc/create_inode.c, which this patch renames _copy_file_range.

Could you resend the patch renaming it to copy_file_chunk()?  That's
less likely to cause confusion with the copy_file_range system call.

Thanks,

					-	 Ted
