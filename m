From: tytso@mit.edu
Subject: Re: e4defrag and immutable files
Date: Tue, 1 Jun 2010 18:26:43 -0400
Message-ID: <20100601222643.GI4426@thunk.org>
References: <4C002427.3010706@zytor.com>
 <4C05604D.2070401@oracle.com>
 <20100601194924.GF4426@thunk.org>
 <4C0574DF.3030303@redhat.com>
 <4C057B68.9040205@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	"H. Peter Anvin" <hpa@zytor.com>, linux-ext4@vger.kernel.org,
	Joel Becker <Joel.Becker@oracle.com>,
	Mark Fasheh <mfasheh@suse.com>
To: Sunil Mushran <sunil.mushran@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:41716 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754694Ab0FAW0r (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Jun 2010 18:26:47 -0400
Content-Disposition: inline
In-Reply-To: <4C057B68.9040205@oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 01, 2010 at 02:28:08PM -0700, Sunil Mushran wrote:
> 
> We had thought of the term static because we wanted the inode to
> be frozen. Entire metadata including the mapping. Our aim is to
> do away with cluster locks for such inodes. For ios, we were planning
> to limit it to only odirect and not change the mtime. That also means
> no links, touch. Yes, "static" does not fit it like a glove but that's the
> best we could come up with.

Hmm, maybe "fixed_metadata"?  The one thing that worries a bit is not
touching mtime is definitely icky.  I suppose it would improve
performance even on local-disk file systems if we don't update mtime,
ctime, or atime.  So maybe that would be useful for folks who are
trying to extract the last bit of performance out of their enterprise
database.

One thing I do like about fixed_metadata is that as far as chattr and
lsattr is concerned 's' and 'S' are already taken.  But 'f' and 'F'
aren't allocated yet.  :-)

					- Ted
