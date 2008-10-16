From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Remove compilation warnings in fs/ext4/mballoc.c
Date: Thu, 16 Oct 2008 11:12:13 -0400
Message-ID: <20081016151213.GA12962@mit.edu>
References: <ea11fea30810160303w5a87b86bv88f181164fff9790@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 <linux-ext4@vger.kernel.org>
To: Manish Katiyar <mkatiyar@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:33949 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751226AbYJPPMS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 16 Oct 2008 11:12:18 -0400
Content-Disposition: inline
In-Reply-To: <ea11fea30810160303w5a87b86bv88f181164fff9790@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 16, 2008 at 03:33:02PM +0530, Manish Katiyar wrote:
> I think a cleaner fix would be to call these functions only when
> CONFIG_PROC_FS is set and cleanup EXT4_PROC_HANDLER to be always
> defined . Also since s_proc in sb only makes sense when procfs is
> configured should that also be ifdef'd in the structure itself ??
> Let me know if these cleanup can be done in a better way (or the way
> you would prefer :-) . I can do this.

What I put into the patch queue comments out all of
ext4_mb_init_per_dev_proc() and ext4_mb_destroy_per_dev_proc() if
CONFIG_PROC_FS is not defined.  This not the common case, (even "make
allnoconfig" leaves CONFIG_PROC_FS defined), so don't think it's worth
messing with #ifdef'ing the structure, and adding to add even more
#ifdef's into the code.  For a similar reason it's not worth it to add
#ifdef's to the call sites of these functions.  It just clutters the
code more, and gcc should be able to optimize out a call to an empty
static function anyway.

						- Ted
