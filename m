From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH V2 37/49] fs/ext4: Use vzalloc
Date: Sun, 19 Dec 2010 22:22:09 -0500
Message-ID: <20101220032209.GF23626@thunk.org>
References: <alpine.DEB.2.00.1011031108260.11625@router.home>
 <960a7efc569f61a50346257835ce5f457a0d4c99.1288925425.git.joe@perches.com>
 <F35C793E-7CBA-4631-8928-C34D5B39F148@dilger.ca>
 <1288941511.18440.63.camel@Joe-Laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	Jiri Kosina <trivial@kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
To: Joe Perches <joe@perches.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:43121 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752374Ab0LTDWO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 19 Dec 2010 22:22:14 -0500
Content-Disposition: inline
In-Reply-To: <1288941511.18440.63.camel@Joe-Laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 05, 2010 at 12:18:31AM -0700, Joe Perches wrote:
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
> differences from V1:
> Andreas Dilger requested a block be moved so that
> sbi->s_flex_groups isn't tested for NULL twice.
> Also coalesced a ext4_msg printk format.

Thanks, applied to the ext4 tree

					- Ted
