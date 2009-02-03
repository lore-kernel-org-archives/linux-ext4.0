From: Theodore Tso <tytso@mit.edu>
Subject: Re: htree indexing and 64-bit file systems
Date: Tue, 3 Feb 2009 18:31:08 -0500
Message-ID: <20090203233108.GW14762@mit.edu>
References: <20090203222202.GK20654@shell>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@sun.com>
To: Valerie Aurora Henson <vaurora@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:46378 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752375AbZBCXbM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 Feb 2009 18:31:12 -0500
Content-Disposition: inline
In-Reply-To: <20090203222202.GK20654@shell>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 03, 2009 at 05:22:02PM -0500, Valerie Aurora Henson wrote:
> I've just been ignoring htree indexing for now, but the regression
> failure in Ted's rebased 64bit tree looks suspiciously htree-related.
> 
> What's the interaction between htree and 64 bit file systems?  What
> needs to change, if anything?

There shouldn't be any.  The block numbers used in htree are logical
block numbers (i.e., block 0 is the first block in the directory,
block 1 is the 2nd block i the directory, etc.)

						- Ted
