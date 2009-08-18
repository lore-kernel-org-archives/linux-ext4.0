From: Theodore Tso <tytso@mit.edu>
Subject: Re: Questions on ext4 and writeback
Date: Tue, 18 Aug 2009 12:39:09 -0400
Message-ID: <20090818163909.GD28560@mit.edu>
References: <6601abe90908130909v582df37aq773e95f49f4a1248@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:46651 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750934AbZHRQjQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 18 Aug 2009 12:39:16 -0400
Content-Disposition: inline
In-Reply-To: <6601abe90908130909v582df37aq773e95f49f4a1248@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 13, 2009 at 09:09:58AM -0700, Curt Wohlgemuth wrote:
> But the actual submittal of I/O for the previous extent might cause
> pages_skipped to be bumped, right?  Removing these increments might cause
> the accounting to be incorrect, it seems to me.

I don't see where the submission of an extent of pages for I/O would
cause page_skipped to be incremented or changed --- am I missing
something?

						- Ted
