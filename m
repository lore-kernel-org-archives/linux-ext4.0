From: Jan Kara <jack@suse.cz>
Subject: Re: A tree to pull into linux-next
Date: Thu, 16 Jul 2009 13:52:21 +0200
Message-ID: <20090716115221.GA24875@atrey.karlin.mff.cuni.cz>
References: <20090715193742.GA18583@duck.suse.cz> <20090716164826.f4edbd42.sfr@canb.auug.org.au> <20090716114751.GE21267@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Stephen Tweedie <sct@redhat.com>, linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger@sun.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38717 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753729AbZGPLwW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 16 Jul 2009 07:52:22 -0400
Content-Disposition: inline
In-Reply-To: <20090716114751.GE21267@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> On Thu, Jul 16, 2009 at 04:48:26PM +1000, Stephen Rothwell wrote:
> > 
> > I am happy to include this, but (no offense) I would like to hear from
> > the ext3 and jbd maintainers (cc'd) about it.
> > 
> 
> The main isssue would be that akpm often has ext3 changes stashed in
> -mm.  Having a separate ext3 tree makes sense, and if Jan wants to
> maintain it, that makes good sense to me, but we should get Andrew's
> sign off, and Jan should make sure he has any ext3/jbd patches that
> might be in -mm, to avoid any potential patch conflicts.
  Yeah. It's upto Andrew. I think he pulls linux-next so he should notice
conflicts. Anyway, I don't mind pushing the changes through him if he
likes it more that way but I've felt that he's rather busy and this
hopefully helps him a bit...

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
