From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: save goal group and offset in struct
 ext4_allocation_context.ac_g_ex
Date: Fri, 1 Aug 2014 08:40:37 -0400
Message-ID: <20140801124037.GB15110@thunk.org>
References: <1406108861-2581-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
 <20140729135819.GA2256@thunk.org>
 <20140731153255.GE1566@thunk.org>
 <53DAE9CD.5090308@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, adilger@dilger.ca, lczerner@redhat.com
To: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:40150 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754684AbaHAMkm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 1 Aug 2014 08:40:42 -0400
Content-Disposition: inline
In-Reply-To: <53DAE9CD.5090308@cn.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 01, 2014 at 09:13:49AM +0800, Xiaoguang Wang wrote:
> > I'm not sure why, and right now I don't have time to investigate.  If
> > someone who has time and experience wading into fs/ext4/mballoc.c, it
> > would be great if someone could take a closer look.
> 
> I'll investigate it and have full tests, thanks!

Thanks!  

The patch *looked* correct, and it was pretty obvious, so I don't
entirely blame you for not running tests --- but it's why I tend to
run smoke tests regularly when merging in patches, and I do encourage
folks to run the smoke test for any patch, no matter how simple.  Yes,
it takes 30 minutes, but it's worth it.

I suspect there may be some underlying bug which your patch unmasked,
so it would be good for us to understand why it caused the failure.

      	       	    	      		     - Ted




