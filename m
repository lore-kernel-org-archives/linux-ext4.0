From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 08/10] debugfs: remove dead code
Date: Tue, 7 Jan 2014 10:58:35 -0800
Message-ID: <20140107185835.GB9229@birch.djwong.org>
References: <1389106394-31898-1-git-send-email-tytso@mit.edu>
 <1389106394-31898-8-git-send-email-tytso@mit.edu>
 <52CC35FF.8000302@redhat.com>
 <20140107172548.GE2822@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20108 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbaAGS6k (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Jan 2014 13:58:40 -0500
Content-Disposition: inline
In-Reply-To: <20140107172548.GE2822@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 07, 2014 at 12:25:48PM -0500, Theodore Ts'o wrote:
> On Tue, Jan 07, 2014 at 11:14:39AM -0600, Eric Sandeen wrote:
> > 
> > Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> > 
> > FWIW, Darrick had already sent this as part of
> > 
> > "[PATCH 1/2] misc: fix resource leaks in e2fsprogs"
> > 
> > - but I suppose small targeted patches are better.
> 
> Whoops, I somehow managed to lose this patch in my inbox.  I see it in
> patchwork, though.  I'll have to double check which of the other fixes
> in his patch are still needed.

As far as coverity bugs go, I put my name on all the bugs that I fixed, and
left the rest alone.

--D
> 
> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
