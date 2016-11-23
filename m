From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [ext4:dev 21/26] file.c:undefined reference to `dax_iomap_fault'
Date: Tue, 22 Nov 2016 23:27:31 -0500
Message-ID: <20161123042731.kgo4whi4un6i4pa4@thunk.org>
References: <201611220402.CuudYzqp%fengguang.wu@intel.com>
 <20161122120805.GE3973@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45730 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932294AbcKWE1e (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 22 Nov 2016 23:27:34 -0500
Content-Disposition: inline
In-Reply-To: <20161122120805.GE3973@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 22, 2016 at 01:08:05PM +0100, Jan Kara wrote:
> Ah, I forgot to select FS_IOMAP when DAX was enabled and having ext2
> enabled in my test builds has hidden this problem. Attached patch fixes the
> build failure for me. Ted, please add this fix to your tree. Thanks!

Thanks, applied.

						- Ted
