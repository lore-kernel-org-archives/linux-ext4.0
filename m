From: Theodore Tso <tytso@mit.edu>
Subject: Re: Fix device too big bug in mainline?
Date: Tue, 4 Aug 2009 19:56:03 -0400
Message-ID: <20090804235603.GQ28678@mit.edu>
References: <20090730215302.GA31141@shell> <20090802002833.GB8680@mit.edu> <20090802022209.GC8680@mit.edu> <20090804182811.GG9324@shell>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>,
	Ric Wheeler <rwheeler@redhat.com>
To: Valerie Aurora <vaurora@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:58827 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932480AbZHDX4R (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Aug 2009 19:56:17 -0400
Content-Disposition: inline
In-Reply-To: <20090804182811.GG9324@shell>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 04, 2009 at 02:28:11PM -0400, Valerie Aurora wrote:
> Oh, geez, those are an old patch set!  I did go back and fix the
> temporary commits and dangly semi-colons, plus reimplemented progress
> meters the way you wanted:

I just pulled in the reimplemented progress meter from the
shared-64bits-handover patches and merged it into e2fsprogs patch
queue.

While I was testing it, I noticed that it was buggy; it was printing
progress reports of the form:

Allocating group tables:  3/ 0

This was because the printf format being used was %d/%d, but the
arguments being printed were unsigned long long's.  Now fixed.

						- Ted
