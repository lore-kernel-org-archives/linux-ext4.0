From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 07/11] ext4: serialize unlocked dio reads with truncate
Date: Sat, 29 Sep 2012 15:43:48 +0400
Message-ID: <87626xawaz.fsf@openvz.org>
References: <1348847051-6746-1-git-send-email-dmonakhov@openvz.org> <1348847051-6746-8-git-send-email-dmonakhov@openvz.org> <20120929044904.GA2583@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, jack@suse.cz, lczerner@redhat.com
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:40366 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753770Ab2I2Lnv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 29 Sep 2012 07:43:51 -0400
Received: by lbon3 with SMTP id n3so2793373lbo.19
        for <linux-ext4@vger.kernel.org>; Sat, 29 Sep 2012 04:43:49 -0700 (PDT)
In-Reply-To: <20120929044904.GA2583@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, 29 Sep 2012 00:49:04 -0400, "Theodore Ts'o" <tytso@mit.edu> wrote:
> On Fri, Sep 28, 2012 at 07:44:07PM +0400, Dmitry Monakhov wrote:
> >  	if (attr->ia_valid & ATTR_SIZE) {
> > -		if (attr->ia_size != i_size_read(inode))
> > +		if (attr->ia_size != inode->i_size) {
> 
> Why this change?   Why are you not using i_size_read() here?
Since we hold i_mutex no one is able to change i_size, and it
is safe to access it directly.
> 
>     	 	       	       	   - Ted
