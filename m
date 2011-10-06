From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Free resources in some error path in
 ext4_fill_super.
Date: Thu, 6 Oct 2011 11:58:57 -0400
Message-ID: <20111006155857.GB19049@thunk.org>
References: <1313767689-2786-1-git-send-email-tm@tao.ma>
 <1313767689-2786-2-git-send-email-tm@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:33686 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964980Ab1JFP66 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 6 Oct 2011 11:58:58 -0400
Content-Disposition: inline
In-Reply-To: <1313767689-2786-2-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 19, 2011 at 11:28:09PM +0800, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> Some of the error path in ext4_fill_super don't release the
> resouces properly. So this patch just try to release them
> in the right way.
> 
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>

Thanks, applied.

						- Ted
