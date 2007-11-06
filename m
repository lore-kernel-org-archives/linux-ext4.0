From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH e2fsprogs] - remove timestamps from .po files
Date: Tue, 6 Nov 2007 09:55:20 -0500
Message-ID: <20071106145520.GB9086@thunk.org>
References: <472F8792.6030808@redhat.com> <m2sl3j1xkq.fsf@vador.mandriva.com> <47307B3D.2010708@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Thierry Vignaud <tvignaud@mandriva.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:50744 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751720AbXKFO4T (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 Nov 2007 09:56:19 -0500
Content-Disposition: inline
In-Reply-To: <47307B3D.2010708@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Nov 06, 2007 at 08:33:33AM -0600, Eric Sandeen wrote:
> Apparently there was some issue with this, once upon a time, which
> resulted in our rpms needing to update the po files... I guess I need to
> do a bit more code archeology / research.  It looks like sct added this
> when the pkg updated to 1.36, though there is no comment about why.

One potential reason could be that we are using ancient libintl files,
and there was some compatibility problem --- although I can't think of
a reason that would require updating the po files.

I know there is currently an issue on Debian because the po files are
getting intstalled in the wrong locations and the gettext shared
libraries are looking for them somewhere else, but I only vaguely
recall what was going on.  I had only enough time to start doing a
quick investigation to see why the translation files were getting
ignored, and didn't have time to try to fix it.

If someone would like to update the po directory and the configure.in
hunks for -po to something less antediluvian, patches would be greatly
appreciated....

						- Ted
