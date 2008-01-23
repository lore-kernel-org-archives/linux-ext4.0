From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] Fix commit block write in JBD2
Date: Wed, 23 Jan 2008 23:01:23 +0100
Message-ID: <20080123220123.GJ10144@duck.suse.cz>
References: <20080123190943.GG10144@duck.suse.cz> <20080123191054.GH10144@duck.suse.cz> <1201123121.3706.9.camel@alpha.linsyssoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: Girish Shilamkar <Girish.Shilamkar@Sun.COM>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:53835 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751432AbYAWWBY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 Jan 2008 17:01:24 -0500
Content-Disposition: inline
In-Reply-To: <1201123121.3706.9.camel@alpha.linsyssoft.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi,

On Thu 24-01-08 02:48:41, Girish Shilamkar wrote:
> 	The loop was removed in journal checksum patch. There had been a
> discussion (11 Jul 2007: [EXT4 set 8][PATCH 1/1]Add journal checksums)
> about this part of code as checksum info was added to commit block. 
  Ah, OK, thanks for explanation. So for JBD2 we don't need the patch
anymore. But for JBD it's still needed.

									Honza

> On Wed, 2008-01-23 at 20:10 +0100, Jan Kara wrote:
> > On Wed 23-01-08 20:09:43, Jan Kara wrote:
> > >   Hi,
> > > 
> > >   the patch below fixes preparation of commit block in
> > > journal_write_commit_record(). Obviously the bug doesn't really matter
> > > since nobody reported it so far but let's cleanup the code... Andrew, could
> > > you please queue it up? Thanks.
> >   And the same fix for JBD2.
> > 
> > 									Honza
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
