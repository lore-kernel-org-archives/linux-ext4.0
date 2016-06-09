From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH e2fsprogs] fuse2fs: might need librt
Date: Thu, 9 Jun 2016 16:57:16 -0400
Message-ID: <20160609205716.GB17343@thunk.org>
References: <1465469851-2074-1-git-send-email-gustavo@zacarias.com.ar>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Gustavo Zacarias <gustavo@zacarias.com.ar>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:34230 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750771AbcFIU5Y (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 9 Jun 2016 16:57:24 -0400
Content-Disposition: inline
In-Reply-To: <1465469851-2074-1-git-send-email-gustavo@zacarias.com.ar>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 09, 2016 at 07:57:31AM -0300, Gustavo Zacarias wrote:
> It uses clock_gettime() which in older glibc versions is in librt.
> 
> Signed-off-by: Gustavo Zacarias <gustavo@zacarias.com.ar>

Thanks, applied.

						- Ted
