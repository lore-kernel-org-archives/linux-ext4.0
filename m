From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH, E2FSPROGS] On-disk format definition for 64-bit support
Date: Wed, 18 Oct 2006 13:43:34 -0400
Message-ID: <20061018174327.GA9565@thunk.org>
References: <E1Ga4l7-0003mU-46@candygram.thunk.org> <45362C90.4030305@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:16574 "EHLO thunker.thunk.org")
	by vger.kernel.org with ESMTP id S1751514AbWJRRoI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Oct 2006 13:44:08 -0400
To: Valerie Clement <valerie.clement@bull.net>
Content-Disposition: inline
In-Reply-To: <45362C90.4030305@bull.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Oct 18, 2006 at 03:30:56PM +0200, Valerie Clement wrote:
>   Should 64-bit support also imply BIG_BG support?
> Yes. There is no flag added for the support of the big block groups, we 
> just use the INCOMPAT_64BIT flag.

But the Big BG code is not in the mainline kernel yet, and while the
64-bit code probably isn't getting used by anyone other than the ext4
developers, if it is going to be assumed by the BIG_BG code, we need
to get the Big BG format changes locked down and the Big BG code
merged into mainline ASAP.  If we can't get it done soon, we will need
to add a flag, since otherwise users will get confused about whether
or not thier kernel will support a filesystem that has big blockgroups
enabled.

						- Ted
