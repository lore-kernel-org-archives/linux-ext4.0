From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4 blocks up
Date: Mon, 2 Jul 2012 11:14:42 -0400
Message-ID: <20120702151442.GB18074@thunk.org>
References: <1341231316.2979.11.camel@sauron.fi.intel.com>
 <20120702144444.GA18074@thunk.org>
 <1341240862.2979.23.camel@sauron.fi.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Mailing List <linux-ext4@vger.kernel.org>,
	Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
	Linux Kernel Maling List <linux-kernel@vger.kernel.org>
To: Artem Bityutskiy <dedekind1@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:53954 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750793Ab2GBPOp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Jul 2012 11:14:45 -0400
Content-Disposition: inline
In-Reply-To: <1341240862.2979.23.camel@sauron.fi.intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 02, 2012 at 05:54:22PM +0300, Artem Bityutskiy wrote:
> On Mon, 2012-07-02 at 10:44 -0400, Theodore Ts'o wrote:
> > Can you tell me *which* xfstest this was blocking on?
> 
> Test 068 which runs fsstress.

Hmmm, I had just started an xfstests -g auto run using standard ext4
defaults with 3.5-rc2, and I'm not noting any problems.  And I've
gotten past test 68 w/o any problems.

Can you tell me more about your KVM config?

I'm using a 512 megs of memory and 2 CPU's under KVM, with a 5 gig
test partition running on a 5400 RPM laptop drive.

						- Ted
