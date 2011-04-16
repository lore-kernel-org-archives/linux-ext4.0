From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: release page cache in ext4_mb_load_buddy error
 path
Date: Sat, 16 Apr 2011 19:07:31 -0400
Message-ID: <20110416230731.GA3806@thunk.org>
References: <20110414064441.GA3499@darkstar>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Yang Ruirui <ruirui.r.yang@tieto.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:53769 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751008Ab1DPXHg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 16 Apr 2011 19:07:36 -0400
Content-Disposition: inline
In-Reply-To: <20110414064441.GA3499@darkstar>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 14, 2011 at 02:44:41PM +0800, Yang Ruirui wrote:
> Add missing page_cache_release in the error path of ext4_mb_load_buddy
> 
> Signed-off-by: Yang Ruirui <ruirui.r.yang@tieto.com>

Thanks, added to the ext4 tree.

					- Ted
