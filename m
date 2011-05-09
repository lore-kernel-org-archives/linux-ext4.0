From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2] ext4: Remove redundant check for first_not_zeroed
 in ext4_register_li_request.
Date: Sun, 8 May 2011 22:02:47 -0400
Message-ID: <20110509020247.GF4138@thunk.org>
References: <1301321153-3171-1-git-send-email-tm@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:58535 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932156Ab1EICCt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 8 May 2011 22:02:49 -0400
Content-Disposition: inline
In-Reply-To: <1301321153-3171-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 28, 2011 at 10:05:53PM +0800, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> We have checked first_not_zeroed == ngroups already above,
> so remove this redundant check.
> 
> sbi->s_li_request = NULL above is also removed since
> it is NULL already.
> 
> Cc: Lukas Czerner <lczerner@redhat.com>
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>

Thanks, added to the ext4 tree.

						- Ted
