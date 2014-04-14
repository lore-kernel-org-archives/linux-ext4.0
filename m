From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH V2] e2fsprogs: misc/mke2fs.c: return error when failed to
 populate fs
Date: Mon, 14 Apr 2014 11:44:12 -0400
Message-ID: <20140414154412.GA26487@thunk.org>
References: <1395885787-25947-1-git-send-email-liezhi.yang@windriver.com>
 <20140330090825.GA4394@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Robert Yang <liezhi.yang@windriver.com>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:54177 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866AbaDNPoT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Apr 2014 11:44:19 -0400
Content-Disposition: inline
In-Reply-To: <20140330090825.GA4394@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Mar 30, 2014 at 05:08:25PM +0800, Zheng Liu wrote:
> On Thu, Mar 27, 2014 at 10:03:07AM +0800, Robert Yang wrote:
> > We need return retval when "mke2fs -d" failed, otherwise the "$?" would
> > be 0 which is misleading.
> > 
> > Signed-off-by: Robert Yang <liezhi.yang@windriver.com>
> 
> Thanks for fixing this.
> Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>

Thanks, applied.

						- Ted
