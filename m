From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: chattr: improve the description for 'j' option in manpage
Date: Wed, 12 Feb 2014 12:29:23 -0500
Message-ID: <20140212172923.GA12218@thunk.org>
References: <1391053576-31308-1-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:57142 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751492AbaBLR3a (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 Feb 2014 12:29:30 -0500
Content-Disposition: inline
In-Reply-To: <1391053576-31308-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 30, 2014 at 11:46:16AM +0800, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> Ext4 file system also supports to set/clear 'j' attribute, but it just
> say that this option is only useful for ext3 in manpage.  This commit
> fixes it.
> 
> Cc: Theodore Ts'o <tytso@mit.edu>
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

Thanks, applied.

					- Ted
