From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Fix a double free in ext4_register_li_request.
Date: Mon, 4 Apr 2011 17:08:32 -0400
Message-ID: <20110404210832.GC2832@thunk.org>
References: <1301297857-3839-1-git-send-email-tm@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, stable@kernel.org
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:50198 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755428Ab1DDVIf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 4 Apr 2011 17:08:35 -0400
Content-Disposition: inline
In-Reply-To: <1301297857-3839-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 28, 2011 at 03:37:37PM +0800, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> In ext4_register_li_request, we malloc a ext4_li_request and
> inserts it into ext4_li_info->li_request_list. In case of any
> error later, we free it in the end. But if we have some error
> in ext4_run_lazyinit_thread, the whole li_request_list will be
> dropped and freed in it. So we will double free this ext4_li_request.
> 
> This patch just sets elr to NULL after it is inserted to the list
> so that the latter kfree won't double free it.
> 
> Cc: stable@kernel.org
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>

Thanks, I've added this to the ext4 tree for 2.6.39-rcX.

	     	   	       	    - Ted
