From: Jan Kara <jack@suse.cz>
Subject: Re: journaled quota file question
Date: Mon, 2 Nov 2009 13:31:24 +0100
Message-ID: <20091102123124.GA23161@duck.suse.cz>
References: <871vkpwv4a.fsf@openvz.org> <871vkj4cf3.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37006 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754725AbZKBMbU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Nov 2009 07:31:20 -0500
Content-Disposition: inline
In-Reply-To: <871vkj4cf3.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi,

On Sat 31-10-09 21:59:44, Dmitry Monakhov wrote:
> Dmitry Monakhov <dmonakhov@openvz.org> writes:
> 
> > While looking to ext3/4 quota code I'm wondering
> > Why do we have to place journaled quota file on fs root?
> > In some situations it may be useful to place it deeper for example:
> > /root/dir/quota_file
> > The only reason what comes in to my mind is that some one
> > may rename parent folder rename("/root/dir", "/root/dir2")
> > Is this the only reason?
  Well, the reason is that we have to read & write the files during orphan
recovery on mount. A that time the filesystem is not fully set up so you
cannot use VFS directory traversal code and I didn't want to implement
ext[34] specific one. Also as you write above, if you have quota files in
some subdirectory, there are more possibilities for failure.
  Admittedly, I don't see a big point in having quota files in some other
directory. In fact, they should rather be system files not visible in
any directory but that requires rather non-trivial changes to repquota and
moving quotacheck functionality to fsck and I never got to doing that.

> add an author in cc:
  Thanks.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
