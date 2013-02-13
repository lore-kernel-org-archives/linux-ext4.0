From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: REGRESSION: [PATCH 04/12] ext4: Disable merging of uninitialized
 extents
Date: Tue, 12 Feb 2013 23:57:59 -0500
Message-ID: <20130213045759.GE2614@thunk.org>
References: <1358510446-19174-1-git-send-email-jack@suse.cz>
 <1358510446-19174-5-git-send-email-jack@suse.cz>
 <20130209171015.GC8091@thunk.org>
 <20130212215832.GA25984@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dmitry Monakhov <dmonakhov@openvz.org>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:48065 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752490Ab3BME6O (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 Feb 2013 23:58:14 -0500
Content-Disposition: inline
In-Reply-To: <20130212215832.GA25984@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 12, 2013 at 10:58:32PM +0100, Jan Kara wrote:
>   The third patch is a fix which shouldn't cause any issues. So you can
> take just that one and leave the other two aside until we are able to
> resolve the issue.

I thought the third patch depending on the first two?  Certainly it
doesn't apply cleanly without the first two patches...

	      	      	      	  	- Ted
