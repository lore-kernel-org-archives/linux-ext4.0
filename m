From: Ted Ts'o <tytso@mit.edu>
Subject: Re: +
 fs-ext4-superc-ext4_register_li_request-fix-use-uninitialised.patch added
 to -mm tree
Date: Thu, 6 Jan 2011 21:43:00 -0500
Message-ID: <20110107024300.GC2857@thunk.org>
References: <201101062331.p06NVAjJ021943@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, lczerner@redhat.com
To: akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:44015 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751866Ab1AGCnD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 6 Jan 2011 21:43:03 -0500
Content-Disposition: inline
In-Reply-To: <201101062331.p06NVAjJ021943@imap1.linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 06, 2011 at 02:57:42PM -0800, akpm@linux-foundation.org wrote:
> Subject: fs/ext4/super.c:ext4_register_li_request(): fix use-uninitialised
> From: Andrew Morton <akpm@linux-foundation.org>
> 
> fs/ext4/super.c: In function 'ext4_register_li_request':
> fs/ext4/super.c:2936: warning: 'ret' may be used uninitialized in this function
> 
> It looks buggy to me, too.

Thanks, added to the ext4 tree.

					- Ted
