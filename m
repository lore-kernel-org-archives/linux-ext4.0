From: Jeremy Allison <jra@samba.org>
Subject: Re: avoid leak upon failed realloc
Date: Fri, 22 Jun 2007 14:02:12 -0700
Message-ID: <20070622210212.GA11851@samba1>
References: <87ejkbbycq.fsf@rho.meyering.net> <1182175456.13184.7.camel@kleikamp.austin.ibm.com> <87wsy15p5n.fsf@rho.meyering.net> <20070622064144.GC17097@thunk.org> <20070622172704.GA10211@samba1> <20070622202020.GJ15285@thunk.org>
Reply-To: Jeremy Allison <jra@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jeremy Allison <jra@samba.org>, Jim Meyering <jim@meyering.net>,
	samba-technical@lists.samba.org, linux-ext4@vger.kernel.org,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.samba.org ([66.70.73.150]:38062 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752874AbXFVVC1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Jun 2007 17:02:27 -0400
Content-Disposition: inline
In-Reply-To: <20070622202020.GJ15285@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jun 22, 2007 at 04:20:20PM -0400, Theodore Tso wrote:
> 
> Hmm.... There are actually several realloc calls in the tdb sources,
> not just the one which Jim pointed out.  If it's better I can just
> simply hack one of my patches to provide a realloc wrapper that deals
> with all of the cases in one fell swoop.

I checked. I think all other realloc uses in tdb are safe.

Jeremy.
