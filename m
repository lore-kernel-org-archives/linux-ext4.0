From: Theodore Tso <tytso@mit.edu>
Subject: Re: [EXT2] Discard unused sectors
Date: Fri, 15 Aug 2008 08:02:35 -0400
Message-ID: <20080815120235.GJ13048@mit.edu>
References: <1218704379.4620.46.camel@pmac.infradead.org> <1218704748.4620.50.camel@pmac.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: David Woodhouse <dwmw2@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:43943 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752941AbYHOMCh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 15 Aug 2008 08:02:37 -0400
Content-Disposition: inline
In-Reply-To: <1218704748.4620.50.camel@pmac.infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 14, 2008 at 10:05:48AM +0100, David Woodhouse wrote:
> I'm not sure how to do this for ext[34]. The sb_issue_discard() funct=
ion
> issues its requests as a soft barrier, because for na=EFve callers it
> needs to ensure that the discard happens _before_ any subsequent writ=
es
> to the same sectors (if they get reallocated immediately).
>=20
> But ext[34] can probably do better than that, and submit the discard
> requests _without_ barriers of their own. If someone with a bit more
> clue does it, that is.

It's worse than this.  We can't call sb_issue_discard() until the
transaction commits, since if we crash before the commit, the undelete
will not have happened.  (The block/inode bitmaps, inode table,
et. al., aren't allowed to go out to disk until the transaction
commit, and similarly, those sectors aren't allowed to get reused
until the commit happens, as well.) =20

This is going to be true of any filesystem which is doing journaling.
What makes life a bit more difficult for ext4 is that we are doing
physical block journaling, so we're not keeping track which blocks are
getting discarded.  (In contrast, systems that do logical journaling
are keeping track of specific lists of blocks that are getting freed,
since that's what they write to the journal.)  This means we'll have
to keep our own in-memory list of extents for which we should call
sb_issue_discard() when the transaction finally commits.  So this is
something that we would have to track in the jbd/jbd2 layer, hanging
off of the transaction structure.  If we do this right, it will also
be what OCFS2 can use too (since it uses the jbd layer as well.)

   	      	      	  	    	     - Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
