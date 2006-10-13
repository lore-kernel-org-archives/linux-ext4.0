From: Theodore Tso <tytso@mit.edu>
Subject: Re: Design alternatives for fragments/file tail support in ext4
Date: Fri, 13 Oct 2006 08:23:26 -0400
Message-ID: <20061013122325.GA1668@thunk.org>
References: <E1GXeYv-0006rP-RV@candygram.thunk.org> <20061013081002.GR6221@schatzie.adilger.int> <20061013104947.GB5519@thunk.org> <m3y7rkeb69.fsf@bzzz.home.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@clusterfs.com>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:22971 "EHLO thunker.thunk.org")
	by vger.kernel.org with ESMTP id S1751646AbWJMMX4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 13 Oct 2006 08:23:56 -0400
To: Alex Tomas <alex@clusterfs.com>
Content-Disposition: inline
In-Reply-To: <m3y7rkeb69.fsf@bzzz.home.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Oct 13, 2006 at 02:56:46PM +0400, Alex Tomas wrote:
> >>>>> Theodore Tso (TT) writes:
> 
>  TT> I suggest this be tunable by superblock field, and not by a /proc
>  TT> tunable.  This is the sort of thing which might be different
>  TT> per-filesystem, and the algorithm will be most effective if the
>  TT> filesystem always use the same cluster size from the time when it was
>  TT> first created.  I'd be happy to assign a superblock field for this
>  TT> purpose, and add the appropriate tune2fs support if we have general
>  TT> agreement on this point.
> 
> that would be good. there is even a stride option to mke2fs?

Yes, there is.  And just as we have -E stride=stripe-size and -E
resize=max-online-resize, we can also -E cluster-size=bytes parameter
in mke2fs.  It would also make sense to make this be something that
can be defaulted in /etc/mke2fs.conf, since even for IDE or SATA disks
it probably makes sense to make the cluster size be 16k or 32k or
maybe even higher.  We probably need to do some benchmarks to see
whether or not this makes sense.

							- Ted

