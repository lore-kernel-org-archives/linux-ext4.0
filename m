From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix error handling in ext4_fill_super()
Date: Thu, 8 Nov 2012 15:15:56 -0500
Message-ID: <20121108201556.GM19977@thunk.org>
References: <alpine.LFD.2.00.1210081424290.25096@localhost>
 <1349699574-32194-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:60071 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757106Ab2KHWLB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 8 Nov 2012 17:11:01 -0500
Content-Disposition: inline
In-Reply-To: <1349699574-32194-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 08, 2012 at 02:32:54PM +0200, Lukas Czerner wrote:
> There are some places in ext4_fill_super() where we would not return
> proper error code if something fails. The confusion is caused probably
> due to the fact that we have two "kind-of" return variables 'ret'and
> 'err'.
> 
> 'ret' is used to return error code from ext4_fill_super() where err is
> used to store return values from other functions within ext4_fill_super().
> However some places were missing the obligatory 'ret = err'. We could
> put the assignment where it is missing, but we can have better "future
> proof" solution. Or we could convert the code to use just one, but it
> would require more rewrites.
> 
> This commit fixes the problem by returning value from 'err' variable if
> it is set and 'ret' otherwise in error handling branch of the
> ext4_fill_super(). The reasoning is that 'ret' value is often set to
> default "-EINVAL" or explicit value, where 'err' is used to store
> return value from other functions and should be otherwise zero.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Applied, thanks.

						- Ted
