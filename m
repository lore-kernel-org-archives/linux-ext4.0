From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [4/4,v2] ext4: fix possible use-after-free
 ext4_remove_li_request()
Date: Fri, 20 May 2011 14:22:22 -0400
Message-ID: <20110520182222.GA10378@thunk.org>
References: <1305890442-16361-4-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, sandeen@redhat.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:40018 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934989Ab1ETSWZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 20 May 2011 14:22:25 -0400
Content-Disposition: inline
In-Reply-To: <1305890442-16361-4-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 20, 2011 at 01:20:42AM -0000, Lukas Czerner wrote:
> We need to take reference to the s_li_request after we take a mutex,
> because it might be freed since then, hence result in accessing old
> already freed memory. Also we should protect the whole
> ext4_remove_li_request() because ext4_li_info might be in the process of
> being freed in ext4_lazyinit_thread().
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>

I've merged all four lazyinit patches into the ext4 tree, thanks.

     	    	     	      	      	   - Ted
