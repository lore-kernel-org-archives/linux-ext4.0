From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Pretty-printing file.f_mode and file.f_flags in trace points
Date: Fri, 11 Apr 2014 18:57:04 -0400
Message-ID: <20140411225704.GA30629@thunk.org>
References: <nsxa9brqyys.fsf@closure.thunk.org>
 <FEAE2135-C0C3-409C-A162-9BC3D9ABDECA@primarydata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	rostedt@goodmis.org
To: Trond Myklebust <trond.myklebust@primarydata.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53034 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755030AbaDKW5J (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 11 Apr 2014 18:57:09 -0400
Content-Disposition: inline
In-Reply-To: <FEAE2135-C0C3-409C-A162-9BC3D9ABDECA@primarydata.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 11, 2014 at 06:47:52PM -0400, Trond Myklebust wrote:
> > I could just cut and paste these and drop them in
> > include/trace/events/ext4.h, but it would probably be better to hav=
e a
> > common header file.  The question is where to put them.  Does
> > include/trace/fs.h make sense to everyone?   Or should put them
> > somewhere else, such as linux/fs.h?
>=20
> I=E2=80=99d vote for creating a new file, rather than reusing
> include/linux/fs.h. The latter is included in way too many other
> headers...

That was my preference as well.  Assuming Steve is OK with
include/trace/fs.h, any objections if I carry a patch in the ext4 tree
which moves these macros from fs/nfs/nfstrace.h into that new file?

Cheers,

					- Ted

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
