From: Theodore Tso <tytso@mit.edu>
Subject: Re: EXT3 file system with unsupported revision level can be
	mounted in R/W mode
Date: Tue, 17 Feb 2009 15:36:17 -0500
Message-ID: <20090217203617.GO23758@mini-me.lan>
References: <4885AFBF.2010409@uniadex.co.jp> <48A90371.6070700@uniadex.co.jp> <48A9439C.4010007@uniadex.co.jp> <48B5B2BC.4050303@redhat.com> <D457AE0D137B9143B30CDD9EB9B2F8D509FDD525@ZZ01X1MB24.ixas.unisys.co.jp> <499A7A64.8040608@uniadex.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: sandeen@redhat.com, linux-ext4@vger.kernel.org
To: Tadao Uchiyama <Tadao.Uchiyama@uniadex.co.jp>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:48789 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752566AbZBQV4U (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 Feb 2009 16:56:20 -0500
Content-Disposition: inline
In-Reply-To: <499A7A64.8040608@uniadex.co.jp>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 17, 2009 at 05:50:44PM +0900, Tadao Uchiyama wrote:
> Sorry for the long delay in my response.  I agree that the mount of
> a file with a too-high revision level should be rejected, if the
> current revision level is never going to change again, because the
> too-high revision level must be an indication of some corruption in
> this case.  The problem is when we should fail the mount. It seems
> to be too late to fail the mount after the related super block has
> been updated in group_extend or clear_journal_error.  It=E2=80=99ll b=
e safe
> to make the revision somewhere earlier stage, at least before doing
> clear_journal_error and group_extend.

I'd just probably add something right after the magic number check
(i.e., around line 2072 in fs/ext4/super.c, in ext4_fill_super()).

It's highly unlikely we would ever change the revision number at this
point, given that we have the feature compatibility bitmasks as the
primary way we indicate format changes in the filesystem these days.
So I wouldn't even allow a read-only mount, I'd just fail the mount
altogether, and very early; basically, treat it as part of the magic
number.

						- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
