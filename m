From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: A tree to pull into linux-next
Date: Mon, 20 Jul 2009 23:15:35 -0700
Message-ID: <20090720231535.5e6a927a.akpm@linux-foundation.org>
References: <20090715193742.GA18583@duck.suse.cz>
	<20090716164826.f4edbd42.sfr@canb.auug.org.au>
	<20090716114751.GE21267@mit.edu>
	<20090716115221.GA24875@atrey.karlin.mff.cuni.cz>
	<20090721160852.65038f6c.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	Stephen Tweedie <sct@redhat.com>, linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger@sun.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33503 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751504AbZGUGQF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 21 Jul 2009 02:16:05 -0400
In-Reply-To: <20090721160852.65038f6c.sfr@canb.auug.org.au>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 21 Jul 2009 16:08:52 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Andrew,
> 
> On Thu, 16 Jul 2009 13:52:21 +0200 Jan Kara <jack@suse.cz> wrote:
> >
> > > On Thu, Jul 16, 2009 at 04:48:26PM +1000, Stephen Rothwell wrote:
> > > > 
> > > > I am happy to include this, but (no offense) I would like to hear from
> > > > the ext3 and jbd maintainers (cc'd) about it.
> > > > 
> > > 
> > > The main isssue would be that akpm often has ext3 changes stashed in
> > > -mm.  Having a separate ext3 tree makes sense, and if Jan wants to
> > > maintain it, that makes good sense to me, but we should get Andrew's
> > > sign off, and Jan should make sure he has any ext3/jbd patches that
> > > might be in -mm, to avoid any potential patch conflicts.
> >   Yeah. It's upto Andrew. I think he pulls linux-next so he should notice
> > conflicts. Anyway, I don't mind pushing the changes through him if he
> > likes it more that way but I've felt that he's rather busy and this
> > hopefully helps him a bit...
> 
> Any comments?

Sure, I'm OK with sending ext3/jbd stuff in Jan's direction.

Just don't break it ;)
