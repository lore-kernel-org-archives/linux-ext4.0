From: Jan Kara <jack@suse.cz>
Subject: Re: Updated ext4 quota design document
Date: Tue, 22 Jun 2010 22:29:27 +0200
Message-ID: <20100622202927.GA9413@quack.suse.cz>
References: <E1OQg7e-0001mI-AB@closure.thunk.org>
 <20100622142047.GF3338@quack.suse.cz>
 <20100622200853.GD6843@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46431 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754714Ab0FVU3w (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 22 Jun 2010 16:29:52 -0400
Content-Disposition: inline
In-Reply-To: <20100622200853.GD6843@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 22-06-10 16:08:53, tytso@mit.edu wrote:
> On Tue, Jun 22, 2010 at 04:20:47PM +0200, Jan Kara wrote:
> >   It might be reasonable to checksum dquots so that we get closer to
> > all-metadata-are-checksummed state. I'm just thinking whether checksumming
> > each dquot is so useful. For example OCFS2 checksums each quota block. That
> > has an advantage that also quota file tree blocks and headers are
> > protected. Also it's possible to use the generic block checksumming
> > framework in JBD2 for this case. OTOH ext4 seems to have chosen to checksum
> > each group descriptor individually so checksumming each dquot structure
> > would seem more consistent.
> 
> Well, the reason why I suggested just checksuming the each quota entry
> is that it was the simplest thing to do, and wouldn't require making
> huge changes to the rest of the quota_tree code.  It also means we
> don't need to do any kind of special locking to make sure there isn't
> another process modifying another quota entry in the same block at the
> same time that we are calculating the per-block checksum --- i.e.,
> some of the headaches that we're seeing with the DIF code.
  With metadata which get journaled it should be quite easy. JBD already
must know before you go and modify buffer contents - that's why
journal_get_write_access and friends exist. It also makes sure that your
data cannot be modified from the moment the buffer enters commit upto the
moment the commit is finished. So you can use buffer commit hook to compute
and store block checksum safely.

> >   So I don't have a strong opinion which checksumming scheme should be
> > chosen. I just wanted to point out that there's another reasonable option.
> > Generic quota code can easily handle both (including leaving some bytes at
> > the end of each block for checksums as it does for OCFS2 now).
> 
> I assume OCFS2 is just using dqdh_pad2 or dqdh_pad1 for its checksum?
  No. quota_tree code sets info->dqi_usable_bs to something smaller than
1 << info->dqi_qtree_depth. Thus quota code leaves a few bytes in each
block unused and ocfs2 stores there the checksum.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
