From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Journal async commit broken for data=ordered?
Date: Tue, 14 Feb 2012 13:56:30 -0700
Message-ID: <15A0337B-5C65-4C36-9AD9-BE5D0E8EF812@dilger.ca>
References: <20120214155536.GA16561@quack.suse.cz>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Ted Tso <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 128.177.190.114.available.above.net ([128.177.190.114]:54249
	"EHLO p1335.superclick.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1761581Ab2BOBQM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 14 Feb 2012 20:16:12 -0500
In-Reply-To: <20120214155536.GA16561@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-02-14, at 8:55 AM, Jan Kara wrote:
>  I've just realized that JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT breaks
> guarantees of data=ordered mode in ext4. The problem is that async commit
> code assumes that when a checksum of a transaction in the journal matches,
> all necessary data is on disk. This is true for metadata but need not be so
> for data - the whole transaction may be correctly on pernament storage
> while some data is still sitting in drive's caches. Thus if a power failure
> happens at that moment, we have broken guarantees of data=ordered mode.
> Seeing that async commit code isn't used by default anyway (I remember
> there used to be some problems with it), shouldn't we just rip it out?

A better long-term solution would be to submit the block IO in advance of
marking the metadata dirty, so the data is safe on disk before the journal
becomes involved.  That would also avoid the problem of entangling the
journal commit latency with IO waiting to be flushed to disk.

Cheers, Andreas





