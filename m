Return-Path: <SRS0=oRRr=OR=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:36826 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726168AbeLHRpm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 8 Dec 2018 12:45:42 -0500
Date: Sat, 8 Dec 2018 12:45:38 -0500
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Gabriel Krisman Bertazi <krisman@collabora.com>
Cc: kernel@collabora.com, linux-ext4@vger.kernel.org
Subject: Re: [PATCH e2fsprogs v4 0/9] Support encoding awareness and casefold
Message-ID: <20181208174538.GB20708@thunk.org>
References: <20181201003910.18982-1-krisman@collabora.com>
 <20181203051806.GA6639@thunk.org>
 <87ftvetjfn.fsf@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ftvetjfn.fsf@collabora.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 03, 2018 at 04:00:12PM -0500, Gabriel Krisman Bertazi wrote:
> I didn't want to load the table in those functions because I didn't want
> to fail there if the nls_table wasn't found.  If the user has some new
> unsupported encoding, e2fsprogs could provide some functionality, even
> if it can't deal with the file tree itself.  Failing during open seemed
> too harsh.

Unfortunately, I think the only thing we can do is to fail at open or
mount if the encoding is unknown.  The problem is that we can't
correctly handle case-folded directories which have htree enabled.
The problem is that we might have encoding-oblivious applications,
such as fuse2fs (for example) where if they use the high-level
libext2fs interfaces, they don't *need* to be encoding aware.

But if we don't fail the open, then what do we do if the library
routine to calculate a directory hash is called?  Most applications
(or callers in libext2fs for that matter) won't gracefully handle an
error there.

It's one thing if we only support Unicode version N, and the file
system is Unicode version N+1.  So long as the user isn't trying to
use the new scripts, things are mostly OK.

But what if the alternate encoding is something completely different?
Say, EBCDIC, or UTF-EBCDIC[1]?  :-) There really is nothing we can do
sanely but to fail the mount.

This also effectively means that new encodings are effectively
incompatible features, but I think that's OK.

						- Ted
						

[1] Which really is a thing[2].  Oh, the horror....
[2] https://www.unicode.org/reports/tr16/
