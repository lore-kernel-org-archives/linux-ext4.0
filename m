From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: add missing BUFFER_TRACE before
 ext4_journal_get_write_access
Date: Mon, 12 May 2014 22:09:18 -0400
Message-ID: <20140513020918.GA29620@thunk.org>
References: <CADu=CFqLi_L77conWoZDuiF91r+O=NNbotGG_W4JtmD9YD3NHw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca
To: liang xie <xieliang007@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35823 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752153AbaEMCJV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 May 2014 22:09:21 -0400
Content-Disposition: inline
In-Reply-To: <CADu=CFqLi_L77conWoZDuiF91r+O=NNbotGG_W4JtmD9YD3NHw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 16, 2014 at 05:17:43PM +0800, liang xie wrote:
> make them more consistently
> 
> Signed-off-by: xieliang <xieliang@xiaomi.com>

Thanks, applied.

					- Ted
