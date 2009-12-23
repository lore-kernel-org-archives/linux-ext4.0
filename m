From: tytso@mit.edu
Subject: Re: [patch 1/1] fs/ext4/super.c: fix printk warning
Date: Wed, 23 Dec 2009 07:49:28 -0500
Message-ID: <20091223124928.GD21594@thunk.org>
References: <200912220025.nBM0Phi7005152@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:44390 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755151AbZLWMte (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 Dec 2009 07:49:34 -0500
Content-Disposition: inline
In-Reply-To: <200912220025.nBM0Phi7005152@imap1.linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 21, 2009 at 04:25:42PM -0800, akpm@linux-foundation.org wrote:
> From: Andrew Morton <akpm@linux-foundation.org>
> 
> sparc64 allmodconfig:
> 
> fs/ext4/super.c: In function `lifetime_write_kbytes_show':
> fs/ext4/super.c:2174: warning: long long unsigned int format, long unsigned int arg (arg 4)
> fs/ext4/super.c:2174: warning: long long unsigned int format, long unsigned int arg (arg 4)
> 
> Cc: Theodore Ts'o <tytso@mit.edu>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Thanks, added to the ext4 tree.

						- Ted
