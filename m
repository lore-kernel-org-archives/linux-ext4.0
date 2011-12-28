From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2] jbd2: clear revoked flag on buffers before a new
 transaction started
Date: Wed, 28 Dec 2011 18:31:02 -0500
Message-ID: <20111228233102.GF12370@thunk.org>
References: <1321695125-2237-1-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:35392 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751998Ab1L1XbG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 28 Dec 2011 18:31:06 -0500
Content-Disposition: inline
In-Reply-To: <1321695125-2237-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Nov 19, 2011 at 05:32:05PM +0800, Yongqiang Yang wrote:
> Currently, we clear revoked flag only when a block is reused.  However,
> this can tigger a false journal error.  Consider a situation when a block
> is used as a meta block and is deleted(revoked) in ordered mode, then the
> block is allocated as a data block to a file.  At this moment, user changes
> the file's journal mode from ordered to journaled and truncates the file.
> The block will be considered re-revoked by journal because it has revoked
> flag still pending from the last transaction and an assertion triggers.
> 
> We fix the problem by keeping the revoked status more uptodate - we clear
> revoked flag when switching revoke tables to reflect there is no revoked
> buffers in current transaction any more.
> 
> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>

Oops, I replied the wrong message.  This is the version of the patch
which I applied...

					- Ted
