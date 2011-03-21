From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix callers of ext4_handle_release_buffer() API
Date: Sun, 20 Mar 2011 22:43:24 -0400
Message-ID: <20110321024324.GF4135@thunk.org>
References: <AANLkTi=KXX9zjBKSGs18OpZUzOD-yyKj9hNVSBi_iBAB@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:56379 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752543Ab1CUCn2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 20 Mar 2011 22:43:28 -0400
Content-Disposition: inline
In-Reply-To: <AANLkTi=KXX9zjBKSGs18OpZUzOD-yyKj9hNVSBi_iBAB@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 01, 2011 at 03:30:24PM +0200, Amir Goldstein wrote:
> ext4_handle_release_buffer() is an API, which is not being used properly.
> This is not so bad considering that it calls jbd2_journal_release_buffer(),
> which does nothing, but the snapshots implementation of this API does
> something.
> 
> ext4_jbd2.h defines 2 identical wrapper functions:
> ext4_journal_release_buffer() and ext4_handle_release_buffer().
> The former has no callers, so it was removed.

Note that there are some commented-out calls to
ext4_journal_release_buffer() in resize.c; they're probably commented
out because at least today, jbd2_journal_release_buffer() is indeed a
no-op.

I'll update resize.c to use the preferred call.  Speaking of which,
how does on-line resize work in the face of the snapshot feature?  Is
that something that is or isn't supported?

Note also that there may be places where a buffer has
get_write_access() called on it, only for it to be never modified.
resize.c is an example of that.

> There are 2 users of the API:
> ext4_new_inode() calls ext4_handle_release_buffer() and
> ext4_xattr_block_set() calls jbd2_journal_release_buffer() directly.
> The latter was chagned to call the wrapper API.
> 
> Signed-off-by: Amir Goldstein <amir73il@users.sf.net>

I'll apply this patch the changes.

						- Ted
		
