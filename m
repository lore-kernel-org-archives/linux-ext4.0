From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH,RFC] Adding quotacheck functionality to e2fsck
Date: Fri, 26 Mar 2010 11:57:33 +0100
Message-ID: <20100326105733.GC3055@quack.suse.cz>
References: <E1NuxHe-0005cj-JN@closure.thunk.org>
 <20100326004738.GJ3145@quack.suse.cz>
 <20100326033824.GC21658@thunk.org>
 <9E7C0FF6-B02F-4470-B70A-4DBF5D5D6E0E@oracle.com>
 <87hbo37ay3.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <andreas.dilger@oracle.com>, tytso@mit.edu,
	Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:49333 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753486Ab0CZK5U (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 26 Mar 2010 06:57:20 -0400
Content-Disposition: inline
In-Reply-To: <87hbo37ay3.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 26-03-10 11:18:28, Dmitry Monakhov wrote:
> > If there isn't a reason to continue using unjournaled quota (i.e. it
> > doesn't break to just move to journaled quota everywhere), then these
> > could just become aliases for the journaled quota implementation.  The
> > other alternative is to deprecate these options in the next kernel and
> > have it print out a warning on the console to tell the user to switch
> > over to the journaled version.
> The only reason to not use journalled quota by default is the currently
> it is a bit slower than unjournalled variant.
> This is because each quota change result in synchronous quotafile 
> update in per-sb-page-cache. And this update is protected by i_mutex.
> and dqio_mutex. It may be fixed easily. I've sent a RFC patch two
> month ago. I'll update it and will submit it this weekend. 
  Well, there is also some overhead caused by more IO we have to do for
quota journaling and that is essentially unavoidable. But still I believe
we should transition people to journaled quotas...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
