From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4 blocks up
Date: Mon, 2 Jul 2012 11:20:32 -0400
Message-ID: <20120702152032.GC18074@thunk.org>
References: <1341231316.2979.11.camel@sauron.fi.intel.com>
 <20120702144444.GA18074@thunk.org>
 <1341240862.2979.23.camel@sauron.fi.intel.com>
 <20120702151442.GB18074@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Artem Bityutskiy <dedekind1@gmail.com>,
	Ext4 Mailing List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:53959 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754047Ab2GBPUe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Jul 2012 11:20:34 -0400
Content-Disposition: inline
In-Reply-To: <20120702151442.GB18074@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've removed linux-fsdevel and linux-kernel to avoid spamming folks
who don't need to see the blow-by-blow debugging....

On Mon, Jul 02, 2012 at 11:14:42AM -0400, Theodore Ts'o wrote:
> On Mon, Jul 02, 2012 at 05:54:22PM +0300, Artem Bityutskiy wrote:
> > On Mon, 2012-07-02 at 10:44 -0400, Theodore Ts'o wrote:
> > > Can you tell me *which* xfstest this was blocking on?
> > 
> > Test 068 which runs fsstress.

How reliably can you reproduce this hang-up?  I've just run the
equivalent of "check 68,68,68,68,68" and I haven't gotten hung up
once. 

And this is a stock 4k ext4 filesystem, right?  Created with "mke2fs
-t ext4" w/o any other options?

							- Ted
