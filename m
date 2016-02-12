From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix potential integer overflow
Date: Fri, 12 Feb 2016 01:16:31 -0500
Message-ID: <20160212061631.GG11298@thunk.org>
References: <1453306688-5528-1-git-send-email-wuninsu@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, taesoo@gatech.edu,
	yeongjin.jang@gatech.edu, insu@gatech.edu, changwoo@gatech.edu
To: Insu Yun <wuninsu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49080 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750714AbcBLGQg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 12 Feb 2016 01:16:36 -0500
Content-Disposition: inline
In-Reply-To: <1453306688-5528-1-git-send-email-wuninsu@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 20, 2016 at 11:18:08AM -0500, Insu Yun wrote:
> Since sizeof(ext_new_group_data) > sizeof(ext_new_flex_group_data),
> integer overflow could be happened.
> Therefore, need to fix integer overflow sanitization.
> 
> Signed-off-by: Insu Yun <wuninsu@gmail.com>

Thanks, applied.

					- Ted
