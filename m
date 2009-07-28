From: Theodore Tso <tytso@mit.edu>
Subject: Re: [BUG] NULL pointer dereference with corrupted image
Date: Mon, 27 Jul 2009 23:17:48 -0400
Message-ID: <20090728031748.GA11111@mit.edu>
References: <1247651649.4097.23.camel@queen> <1248085450.3794.4.camel@queen>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Sesterhenn <eric.sesterhenn@lsexperts.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:54532 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751146AbZG1DR5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 27 Jul 2009 23:17:57 -0400
Content-Disposition: inline
In-Reply-To: <1248085450.3794.4.camel@queen>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 20, 2009 at 12:24:10PM +0200, Eric Sesterhenn wrote:
> The following patch fixes the issue.
> 
> If an error happens ext4_decode_error() misses a check if there is a 
> valid journal. If there is no journal we dereference a NULL pointer,
> when we try to print the matching error string.

Applied to the ext4 patch queue, thanks.

						- Ted
