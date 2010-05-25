From: tytso@mit.edu
Subject: Re: [PATCH 2/2] ext4: Clear the EXT4_EOFBLOCKS_FL flag only when
 warranted
Date: Tue, 25 May 2010 09:03:31 -0400
Message-ID: <20100525130331.GC5556@thunk.org>
References: <20100525041737.GB5556@thunk.org>
 <1274761117-26560-2-git-send-email-tytso@mit.edu>
 <87zkzola0r.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:48878 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753878Ab0EYNDg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 May 2010 09:03:36 -0400
Content-Disposition: inline
In-Reply-To: <87zkzola0r.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 25, 2010 at 11:23:48AM +0400, Dmitry Monakhov wrote:
> This condition was triggered during fsstress test. So I consider
> it as rare but possible in real life. Nor than less it is better
> to fix it now, than fix it in response from a midnight call from some
> crazy customer :)

Fair enough, I just didn't have an 8-core system handy when I was
dealing with it, so hand-crafted an fs image.

BTW, whatever happened to the xfstests patch that you created in

https://bugzilla.kernel.org/show_bug.cgi?id=15792

Did you submit it to the xfstests folks for inclusion?

    	       	     	 	  	- Ted
