From: Theodore Tso <tytso@mit.edu>
Subject: Re: fsck errors encountered when applying patch "ext4: fix BUG
	when calling ext4_error with locked block group"
Date: Fri, 20 Feb 2009 20:50:26 -0500
Message-ID: <20090221015026.GD12966@mini-me.lan>
References: <d5ca277e0902201531g6e32691cweda3fd8f6d1dbbff@mail.gmail.com> <20090221012908.GC12966@mini-me.lan> <532480950902201737j5162125teea57eedbd01873f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Xiang Wang <xiangw@google.com>, linux-ext4@vger.kernel.org,
	aneesh.kumar@linux.vnet.ibm.com,
	Curt Wohlgemuth <curtw@google.com>,
	Chad Talbott <ctalbott@google.com>,
	Frank Mayhar <fmayhar@google.com>
To: Michael Rubin <mrubin@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:41252 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750766AbZBUFAT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 21 Feb 2009 00:00:19 -0500
Content-Disposition: inline
In-Reply-To: <532480950902201737j5162125teea57eedbd01873f@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 20, 2009 at 05:37:35PM -0800, Michael Rubin wrote:
> We know. Our qualifying process is not the most light weight and the
> kernel moves fast. Normally we take a snapshot and qualify it, trying
> to take upstream patches when we can and then also publishing bugs we
> find. The problem is that with ext4 still undergoing active dev we
> want to be able to keep our ext4 portion of the tree as up to date as
> possible.

I understand, and it's not a burden to answer questions like this.  I
was just pointing out the effort that it will likely take to backport
the percpu counter patches, since you will need to scan the your
sources and make sure the behavioural changes in percpu_counter_sum
isn't going to cause problems for you elsewhere, and that this sort of
thing is probably going to get harder as time goes by, not easier.  I
know how painful it can be, since I've been having a hard time
backporting fixes to the 2.6.27 stable tree.

The good news is that ext4 development is settling down, so if you
manage to take another snapshot around 2.6.29 or 2.6.30, I suspect
life will be much easier (at least as far as backporting patches for
ext4 is concerned.)

Best regards,

					- Ted
