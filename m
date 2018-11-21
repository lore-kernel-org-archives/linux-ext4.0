Return-Path: <SRS0=ZxZh=OA=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38848 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726862AbeKVKbL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 22 Nov 2018 05:31:11 -0500
Date: Wed, 21 Nov 2018 18:54:32 -0500
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: alexey.lyashkov@gmail.com
Cc: linux-ext4@vger.kernel.org
Subject: Re: [PATCH 2/3] Fix panic with journal superblock flags printing.
Message-ID: <20181121235432.GE10588@thunk.org>
References: <20181119091650.81803-1-alexey.lyashkov@gmail.com>
 <20181119091650.81803-3-alexey.lyashkov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181119091650.81803-3-alexey.lyashkov@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The summary really isn't right; "panic" is something that kernels do,
not userspace programs.

> -	if (dump_super) {
> +	if (dump_all || dump_super) {
>  		e2p_list_journal_super(out_file, jsb_buffer,
> -				       current_fs->blocksize, 0);
> +				       1024, 0);

This makes no sense to me.  Why is hard-coding the expected blocksize
to be 1024 a good thing to do here?

					- Ted
