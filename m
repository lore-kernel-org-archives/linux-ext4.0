From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Patch adding e2p_feature_to_string
Date: Thu, 18 Dec 2014 22:21:27 -0500
Message-ID: <20141219032127.GC3474@thunk.org>
References: <CAC80aehVQyWfkd6X339n2bhkDU574hTMWEKXcxzeJrwP4K8E+A@mail.gmail.com>
 <7EB7C92E-036C-4460-A132-344C06F83336@dilger.ca>
 <CAC80aeigBG9vdbG-RY9wV7vezd6uw+XcdnFQ81A7Bkq3pdSWxw@mail.gmail.com>
 <40442828-1968-444E-AA4E-F0A1D28EC057@dilger.ca>
 <CAC80aejg3USDDeaVQ-F72aWoAk1daqdpTRCOiOac=GjVsqj6Pg@mail.gmail.com>
 <7F6D52D2-77D3-4F64-A1CB-DC43E3CD72D4@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ? Wade <wadetregaskis@google.com>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35360 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751163AbaLSDVb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Dec 2014 22:21:31 -0500
Content-Disposition: inline
In-Reply-To: <7F6D52D2-77D3-4F64-A1CB-DC43E3CD72D4@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 18, 2014 at 02:58:38PM -0700, Andreas Dilger wrote:
> 
> It is really a bad idea to be using a feature bit that isn't at least
> _registered_ in e2fsprogs, even if the full support isn't there, since
> you run a real risk of someone else using that feature bit for some
> completely different feature, and mass problems may result (e.g. e2fsck
> incorrectly thinking it understands the feature when it doesn't).

Well, it can happen if you are fuzz-testing.  The other possibility is
that I happen to know that the version of e2fsprogs that Wade was
using is rather old, for hysterical reasons.  (We should fix this, and
in fact there had been some suggestions that we fix this for other
reasons, but we've just not gotten around to it.)

> > I can do either, if you insist.  What would you prefer:
> > 
> > a) Statically defining the various FEATURE_foo strings, as you describe.
> > b) Duplicating the implementation of the two functions so that
> > e2p_feature2string() can retain its prior behaviour of returning a
> > string constant in the common cases.

A third possibiltiy is to change e2p_feature_to_string to only use the
passed-in buffer if it is given an unknown feature, but other times,
it will return a static constant string, just as e2p_feature2string
does today.  That is, change the contract of e2p_feature_to_string
such that the buffer MAY be used by e2p_feature_to_string, instead of
MUST be used....

I believe I've seen other cases where the foo_r() version of a foo()
function works in this way; the passed-in buffer is used if it's
necessary for thread-safety, but it is not guaranteed that the buffer
is used; only that foo_r() is thread-safe.

Cheers,

						- Ted
