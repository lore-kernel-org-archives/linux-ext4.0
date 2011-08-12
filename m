From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] ext4: Deprecate data=journal mount option
Date: Fri, 12 Aug 2011 16:57:19 -0400
Message-ID: <20110812205719.GA1670@infradead.org>
References: <1309260363-19012-1-git-send-email-lczerner@redhat.com>
 <alpine.LFD.2.00.1108111700500.29009@dhcp-27-109.brq.redhat.com>
 <BEF6D87F-AEA5-4BF8-B71D-6BBA540C3731@dilger.ca>
 <alpine.LFD.2.00.1108121013280.4535@dhcp-27-109.brq.redhat.com>
 <4E44E374.7080103@redhat.com>
 <CAO81RMYcvpd2--Y-u2xOb2+3U=fOK2UtaW7d9iP43_u38hYgZA@mail.gmail.com>
 <alpine.LFD.2.00.1108121803210.3088@dhcp-27-109.brq.redhat.com>
 <20110812181330.GG31181@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Lukas Czerner <lczerner@redhat.com>,
	Curt Wohlgemuth <curtw@google.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	Andreas Dilger <adilger@dilger.ca>,
	linux-ext4 List <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>, Eric Sandeen <sandeen@redhat.com>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:34773
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751364Ab1HLU5Y (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 12 Aug 2011 16:57:24 -0400
Content-Disposition: inline
In-Reply-To: <20110812181330.GG31181@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 12, 2011 at 02:13:30PM -0400, Ted Ts'o wrote:
> I have a rather long list of expected failures, mostly having to do
> with xfstests assuming that O_DIRECT has to be supported.  On my todo
> list is to scrub through the list failures that I've seen, make sure
> they are indeed related to O_DIRECT, and then see if I can figure out
> some way of telling xfstests to skip O_DIRECT tests via some
> environment variable or command line option.

If you do it please do it by returning a defined failure from the
test programs and then just exiting the test with _notrun.  But given
that xfstests does a lot of O_DIRECT testing it might be quite involved.

To be honest I'd expect a Linux filesystem without O_DIRECT not working
overly well in practical setup - it's pretty widely used these days.
A better fix might be simply accept O_DIRECT for data=journal, but
use the pagecache with a use once hint.

> BTW, with the very latest xfstests, I'm seeing new across-the-board
> (not just data=journal) failures for tests #62 (caused by the presence
> of the lost+found directory

062 fails because Andreas changed the error returns from the xattr
calls.  He sent me a patch to accept the new errors, but I'm still
undecided wether the new ones are correct enough.  I'll wait another
kernel release to see if real users complain about the change, and
will apply it then.

> and differences in error code returns for
> xattrs) and #79 (a failure in the append-only handling which I don't
> completely understand yet).

This was discussed on fsdevel lately.  All filesystem but xfs inherit
the append only bit from directories to files created inside them.
This not only is not very useful behaviour, but also exposes a bug
in the vfs that allows to create these new files, but fail the open
unless using O_APPEND which is against the posix create semantics.

We'll have to either adopt the oether filesystems to the xfs semantics,
or adopt xfs to the common dumb semantics and fix that O_CREAT bug.

