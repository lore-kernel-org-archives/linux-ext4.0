From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix the deadlock in ext4_ordered_write_end()
Date: Thu, 20 Oct 2011 18:53:31 -0400
Message-ID: <20111020225331.GI17210@thunk.org>
References: <4E964780.4080105@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	adilger.kernel@dilger.ca
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:44660 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998Ab1JUBMp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 Oct 2011 21:12:45 -0400
Content-Disposition: inline
In-Reply-To: <4E964780.4080105@rs.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 13, 2011 at 11:05:52AM +0900, Akira Fujita wrote:
> From: Akira Fujita <a-fujita@rs.jp.nec.com>
> 
> If ext4_jbd2_file_inode() in ext4_ordered_write_end() fails
> for some reasons, this function returns to caller
> without unlocking the page.
> It leads to the deadlock, and the patch fixes this issue.
> 
> Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>

Thanks, applied.

					- Ted
