From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: The default assignee for the ext4 component goes nowhere
Date: Sun, 2 Nov 2008 19:32:26 -0800
Message-ID: <20081102193226.df026896.akpm@linux-foundation.org>
References: <E1Kwkhw-0007O5-Mr@closure.thunk.org>
	<20081102134803.28c12d8b.akpm@linux-foundation.org>
	<20081102230806.GN8134@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: bugme-admin@linux-foundation.org, linux-ext4@vger.kernel.org,
	Sami Liedes <sliedes@cc.hut.fi>,
	Francois Valenduc <francois.valenduc@tvcablenet.be>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55431 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754374AbYKCDdM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Nov 2008 22:33:12 -0500
In-Reply-To: <20081102230806.GN8134@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, 2 Nov 2008 18:08:06 -0500 Theodore Tso <tytso@mit.edu> wrote:

> On Sun, Nov 02, 2008 at 01:48:03PM -0800, Andrew Morton wrote:
> > 
> > I think the normal way of doing this is to create an account at bugzilla
> > called linux-ext4@vger.kernel.org then you can log in using that account
> > and add it to various assignees using the "users to watch" feature.
> 
> Ah, so the fs_ext4@kernel-bugs.osdl.org is really a bugzilla
> pseudo-user?

I guess so.

>   But for the ext3 component was set to assign bugs to you
> by default, as opposed to creating a fs_ext3 pseudo-user?

Ah.  We'll need to change that.  You don't want all my bugzilla traffic
landing on linux-ext4 :)

> I'm just trying to figure out how the bugzilla system is supposed to
> be working...

I'm far from a definitive source on that matter.

I'm not sure who's reading bugme-admin at present.
