From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH -v2] ext4: add max_dir_size_kb mount option
Date: Sat, 11 Aug 2012 15:26:48 -0400
Message-ID: <20120811192648.GA9363@thunk.org>
References: <20120810215811.GA1137@thunk.org>
 <1344649235-9289-1-git-send-email-tytso@mit.edu>
 <C9EF93CD-99DF-483E-BE66-713616B12D8C@whamcloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:44149 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752320Ab2HKT0u (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 11 Aug 2012 15:26:50 -0400
Content-Disposition: inline
In-Reply-To: <C9EF93CD-99DF-483E-BE66-713616B12D8C@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 10, 2012 at 09:22:39PM -0600, Andreas Dilger wrote:
> 
> In our patch, it returns EFBIG, since it isn't really a case of
> being out of space for blocks or inodes.

I agree, EFBIG seems to be a better errno.

How did you configure the directory size limit, BTW?  Did you use a
mount option, if so, what did you name it?

Regards,

					- Ted
