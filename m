From: Theodore Tso <tytso@mit.edu>
Subject: Re: Concise description of disk layout?
Date: Wed, 15 Apr 2009 20:28:09 -0400
Message-ID: <20090416002809.GG21586@mit.edu>
References: <1239838392.12688.4.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Frank Mayhar <fmayhar@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:52729 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753642AbZDPA2R (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 15 Apr 2009 20:28:17 -0400
Content-Disposition: inline
In-Reply-To: <1239838392.12688.4.camel@bobble.smo.corp.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 15, 2009 at 04:33:12PM -0700, Frank Mayhar wrote:
> Does such a thing exist anywhere?  I.e. "inodes are here, data blocks
> are here, etc., etc."  I need to come up with something like this but if
> one already exists that would save a lot of time.

At what level?  You mean something like this:

   http://e2fsprogs.sourceforge.net/ext2intro.html

but updated for ext4?

Hmm, not really.  Fragments of what's there can be found in various
slide decks and papers, here:

      http://ext4.wiki.kernel.org/index.php/Publications

If you'd like to write up something comprehensive for the ext4 wiki,
that would be great.  :-)

					- Ted
