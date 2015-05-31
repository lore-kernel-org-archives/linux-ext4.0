From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] ext4 crypto: release crypto resource when module exit
Date: Sun, 31 May 2015 13:38:31 -0400
Message-ID: <20150531173831.GD11642@thunk.org>
References: <002801d099bb$13ec4610$3bc4d230$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: 'Ext4 Developers List' <linux-ext4@vger.kernel.org>,
	mhalcrow@google.com, jaegeuk@kernel.org
To: Chao Yu <chao2.yu@samsung.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39427 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758526AbbEaRid (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 31 May 2015 13:38:33 -0400
Content-Disposition: inline
In-Reply-To: <002801d099bb$13ec4610$3bc4d230$@samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 29, 2015 at 10:55:37AM +0800, Chao Yu wrote:
> Crypto resource should be released when ext4 module exits, otherwise
> it will cause memory leak.
> 
> Signed-off-by: Chao Yu <chao2.yu@samsung.com>

Thanks, applied.

						- Ted
