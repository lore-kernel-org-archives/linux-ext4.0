Return-Path: <SRS0=yq1P=MY=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45698 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726054AbeJMC6C (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 12 Oct 2018 22:58:02 -0400
Date: Fri, 12 Oct 2018 15:24:01 -0400
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Gabriel Krisman Bertazi <krisman@collabora.co.uk>,
        linux-ext4@vger.kernel.org
Subject: Re: [PATCH RESEND v2 00/25] Ext4 Encoding and Case-insensitive
 support
Message-ID: <20181012192401.GA20322@thunk.org>
References: <20180924215655.3676-1-krisman@collabora.co.uk>
 <20181011222359.GB24824@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181011222359.GB24824@magnolia>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 11, 2018 at 03:23:59PM -0700, Darrick J. Wong wrote:
> 
> Hmmm, I'm curious, why pick NFKD specifically?  AFAICT Linux userspace
> environments (I only tried with GNOME and KDE) use NF[K]C....
>
> Is there a particular reason you picked NFKD?  Ohhh, right, because this
> series is a derivative of the ~2014 XFS case folding patchset.  Hmm, so
> looking at the ext4 changes, I guess what you do is add a custom ->d_hash
> function so that the dentries are hashed by hash(nfkd(fname))?  Which
> makes it easy to have link() look for names that will conflict after
> normalization?

This would be true for NFKC or NFC as well though, right?  So the
tradeoff of NF[K]C vs NF[K]D is that NFC is more efficient from an
encoding perspective.  For e with a grave accent, NFC would encode it
as C3 A9, while NFD would encode it as 65 CC 81.  So from an encoding
perspective there would be a benefit to use 'C' versus 'D'.  But MacOS
X by default canonicalizes to 'D', not 'C'.  I assume that's the
rationale for using NFKD versus NFKC?

As far as the 'K' versus "non-K" distinction, I imagine the main issue
is that a user could cut and paste something like "She\uFB03eld" which
it makes sense to canonicalize this to "Sheffield".  This is *not* a
canoncalization which MacOS X does (it uses NFD, not NFKD) but from a
compatibility perspective, it's not a problem since:

NFD:	Sheffield -> Sheffield
	She\uFB03eld -> She\uFB03eld

NFKD:	Sheffield -> Sheffield
	She\uFB03eld -> Sheffield

Given it's really painful to type the string She\uFB03eld into a
terminal, it seems to make sense that even if the user tries to create
a file with that string, that the actual file name that should get
created should be "Sheffield".

And hence, that's the argument for why the best on-disk encoding for
Linux file systems should be NFKD.

Does that seem right to everyone?

						- Ted
