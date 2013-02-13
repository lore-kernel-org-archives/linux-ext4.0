From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: REGRESSION: [PATCH 04/12] ext4: Disable merging of uninitialized extents
Date: Wed, 13 Feb 2013 11:26:40 +0400
Message-ID: <87ehgku11r.fsf@openvz.org>
References: <1358510446-19174-1-git-send-email-jack@suse.cz> <1358510446-19174-5-git-send-email-jack@suse.cz> <20130209171015.GC8091@thunk.org> <20130212215832.GA25984@quack.suse.cz> <20130213045759.GE2614@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:36200 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555Ab3BMH0p (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Feb 2013 02:26:45 -0500
Received: by mail-lb0-f170.google.com with SMTP id ge1so736285lbb.1
        for <linux-ext4@vger.kernel.org>; Tue, 12 Feb 2013 23:26:44 -0800 (PST)
In-Reply-To: <20130213045759.GE2614@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 12 Feb 2013 23:57:59 -0500, Theodore Ts'o <tytso@mit.edu> wrote:
> On Tue, Feb 12, 2013 at 10:58:32PM +0100, Jan Kara wrote:
> >   The third patch is a fix which shouldn't cause any issues. So you can
> > take just that one and leave the other two aside until we are able to
> > resolve the issue.
> 
> I thought the third patch depending on the first two?  Certainly it
> doesn't apply cleanly without the first two patches...
My patch fix old issue, but i've prepared it on top of Jan's patches
only for simplicity. I'll send new version which not depend on his
patches today.
Over-all Jan's statment that split should not happen inside end_io
and it is clear sing of a bug is absolutely right decision.
This helps us to spot several hidden issues (number is still unknown)
so may be it is reasonable to split first patch in two parts:
1) disable uninitialized extents merging itself.
2) Print warning if split is required inside end_io(so only warning will
be printed, but w/o data corruption)
3) Get rid of extent split machinery from end_io (because it is not
longer valid situation)

(1) and (2) should be accepted ASAP and will help us to spot and fix
other hidden issues. And we fix all related issues it will be safe
to apply (3)'rd one.
I'll send patches soon.
> 
> 	      	      	      	  	- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
