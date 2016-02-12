From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2] ext4: remove unused parameter "newblock" in
 convert_initialized_extent()
Date: Fri, 12 Feb 2016 01:23:54 -0500
Message-ID: <20160212062354.GI11298@thunk.org>
References: <1455117406-15497-2-git-send-email-guaneryu@gmail.com>
 <1455120544-17524-1-git-send-email-guaneryu@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eryu Guan <guaneryu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49134 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750773AbcBLGXz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 12 Feb 2016 01:23:55 -0500
Content-Disposition: inline
In-Reply-To: <1455120544-17524-1-git-send-email-guaneryu@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 11, 2016 at 12:09:04AM +0800, Eryu Guan wrote:
> The "newblock" parameter is not used in convert_initialized_extent(),
> remove it.
> 
> Signed-off-by: Eryu Guan <guaneryu@gmail.com>

Applied, thanks.

					- Ted
