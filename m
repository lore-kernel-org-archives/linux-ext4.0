From: Pavel Roskin <proski@gnu.org>
Subject: Re: [PATCH] ext4: ext4_mb_initialize_context() forgets to
 initialize some fields
Date: Mon, 13 Jul 2009 17:27:07 -0400
Message-ID: <1247520427.3865.1.camel@mj>
References: <20090710204754.18406.15771.stgit@mj.roinet.com>
	 <4A57AB9A.4050208@redhat.com>  <20090713134653.GD12833@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:38055 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752293AbZGMV1J (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 Jul 2009 17:27:09 -0400
In-Reply-To: <20090713134653.GD12833@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 2009-07-13 at 09:46 -0400, Theodore Tso wrote:
> On Fri, Jul 10, 2009 at 03:59:06PM -0500, Eric Sandeen wrote:
> > 
> > At this point I think we are initializing almost all of the 22
> > allocation context members and 16 of those are 0/NULL; perhaps it'd be
> > simpler and/or more efficient to just start with a memset(0), but either
> > way.
> 
> Agreed, it should be more efficient.  This is the patch which I just
> added to the ext4 patch queue.

Thanks!  I confirm that kmemcheck is silent about ext4 after this patch
is applied.

-- 
Regards,
Pavel Roskin
