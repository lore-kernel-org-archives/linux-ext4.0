From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: defragmentation code cleanup
Date: Thu, 11 Apr 2013 23:33:11 -0400
Message-ID: <20130412033311.GB4865@thunk.org>
References: <1365520559-6622-1-git-send-email-dmonakhov@openvz.org>
 <516509FD.7060209@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dmitry Monakhov <dmonakhov@openvz.org>, linux-ext4@vger.kernel.org
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:33704 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750731Ab3DLDdS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Apr 2013 23:33:18 -0400
Content-Disposition: inline
In-Reply-To: <516509FD.7060209@rs.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 10, 2013 at 03:43:09PM +0900, Akira Fujita wrote:
> Hi,
> 
> (2013/04/10 0:15), Dmitry Monakhov wrote:
> > - grab_cache_page_write_begin() may not wait on page's writeback since
> >    (1d1d1a767206). But it is still reasonable to wait on page's writeback
> >    here in order to be on the safe side.
> > 
> > - Fix miss typo: pass 'length' instead of 'end' to __block_write_begin()
> >    https://bugzilla.kernel.org/show_bug.cgi?id=56241
> 
> Looks good to me, thanks.
> 
> Reviewed-by: Akira Fujita <a-fujita.rs.jp.nec.com>

Applied, thanks.

					- Ted
