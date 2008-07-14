From: Theodore Tso <tytso@mit.edu>
Subject: Re: [patch 1/4] ext4: error proc entry creation when the fs/ext4
	is not correctly created
Date: Sun, 13 Jul 2008 21:07:45 -0400
Message-ID: <20080714010745.GA7938@mit.edu>
References: <200807130626.m6D6QKa3007907@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, linux-ext4@vger.kernel.org, shen@cn.fujitsu.com
To: akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:46970 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754049AbYGNBIU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 13 Jul 2008 21:08:20 -0400
Content-Disposition: inline
In-Reply-To: <200807130626.m6D6QKa3007907@imap1.linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jul 12, 2008 at 11:26:19PM -0700, akpm@linux-foundation.org wrote:
> From: Shen Feng <shen@cn.fujitsu.com>
> 
> When the directory fs/ext4 is not correctly created under proc, the entry
> under this directory should not be created.
> 
> Signed-off-by: Shen Feng <shen@cn.fujitsu.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Thanks, applied.

					- Ted
