From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Avoid stamping on other memories in
 ext4_ext_insert_index.
Date: Sat, 8 Oct 2011 17:19:21 -0400
Message-ID: <20111008211921.GM7948@thunk.org>
References: <1317375304-5829-1-git-send-email-tm@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:46442 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754055Ab1JHVTW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 8 Oct 2011 17:19:22 -0400
Content-Disposition: inline
In-Reply-To: <1317375304-5829-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 30, 2011 at 05:35:04PM +0800, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> In ext4_ext_insert_index, we initialize 'ix' before checking its validity, so
> we have a chance to stamp on memories out of the block. So move the check
> before we do the work.
> 
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>

Applied, thanks.

						- Ted
