From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCHv2] fsck: fix strange logic
Date: Wed, 10 Aug 2016 18:54:58 -0400
Message-ID: <20160810225458.GE10523@thunk.org>
References: <1470773576-18604-1-git-send-email-andreas.dilger@intel.com>
 <1470774429-18969-1-git-send-email-andreas.dilger@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <andreas.dilger@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:42538 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752746AbcHJWzC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 10 Aug 2016 18:55:02 -0400
Content-Disposition: inline
In-Reply-To: <1470774429-18969-1-git-send-email-andreas.dilger@intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 09, 2016 at 02:27:09PM -0600, Andreas Dilger wrote:
> llvm warns about the confusingly written comparison:
> 
>                               !strncmp(argv[i+1], "-", 1) == 0) {
>     misc/fsck.c:1178 col 9: warning: logical not is only applied to
>       the left hand side of comparison [-Wlogical-not-parentheses]
>     misc/fsck.c:1178 col 9: note: add parentheses after the '!' to
>       evaluate the comparison first
>     misc/fsck.c:1178 col 9: note: add parentheses around left hand
>       side expression to silence this warning
> 
> It makes sense to simplify this to a character comparison rather
> than using strncmp() to check only one character.
> 
> Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>

Thanks, applied.

						- Ted
