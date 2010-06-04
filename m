From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 4/4] jffs2: update ctime when changing the file's
 permission by setfacl
Date: Fri, 4 Jun 2010 19:32:46 +0100
Message-ID: <20100604183246.GF31073@ZenIV.linux.org.uk>
References: <1275664075-4703-1-git-send-email-jack@suse.cz>
 <1275664075-4703-5-git-send-email-jack@suse.cz>
 <1275664442.17903.91.camel@macbook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: David Woodhouse <dwmw2@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:37450 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753942Ab0FDScu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Jun 2010 14:32:50 -0400
Content-Disposition: inline
In-Reply-To: <1275664442.17903.91.camel@macbook.infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 04, 2010 at 04:14:02PM +0100, David Woodhouse wrote:
> On Fri, 2010-06-04 at 17:07 +0200, Jan Kara wrote:
> > jffs2 didn't update the ctime of the file when its permission was changed.
> 
> Thanks. I have a couple more JFFS2 bug fixes that Al pointed out a day
> or two ago, which I want to submit for 2.6.35; I'll merge this through
> my tree with those if that's OK.

How much else is currently in your tree?  I'm going to push to Linus in
a bit and I'd simply pull your tree first if that's all there is...
