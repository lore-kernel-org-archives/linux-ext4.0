From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Enable quota enforcement based on mount options
Date: Thu, 28 Jul 2016 11:58:07 -0400
Message-ID: <20160728155807.GA27400@thunk.org>
References: <1468841157-8083-1-git-send-email-jack@suse.cz>
 <20160728140411.GB19398@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53370 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161006AbcG1P6K (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 Jul 2016 11:58:10 -0400
Content-Disposition: inline
In-Reply-To: <20160728140411.GB19398@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 28, 2016 at 04:04:11PM +0200, Jan Kara wrote:
> On Mon 18-07-16 13:25:57, Jan Kara wrote:
> > When quota information is stored in quota files, we enable only quota
> > accounting on mount and enforcement is enabled only in response to
> > Q_QUOTAON quotactl. To make ext4 behavior consistent with XFS, we add a
> > possibility to enable quota enforcement on mount by specifying
> > corresponding quota mount option (usrquota, grpquota, prjquota).
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> 
> Ping Ted?

The reason why I hadn't taken this patch yet was purely a matter of
timing.  It was bit too close to the merge window; yes, it was a fairly
simple patch so it was relatively low risk, so it was a close call
whether to include it, but ultimately I decided to hold off.

	   	       	   	      		- Ted
