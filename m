From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC PATCH 0/3] Stop clearing uptodate flag on write IO error
Date: Mon, 16 Jan 2012 17:01:36 +0100
Message-ID: <20120116160136.GC16431@quack.suse.cz>
References: <1325774407-28531-1-git-send-email-jack@suse.cz>
 <CA+55aFy0sidnCzPkP6yjnarLZx3a=7QSpgfaf2mUNVy14y3vCw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	LKML <linux-kernel@vger.kernel.org>,
	Edward Shishkin <edward@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFy0sidnCzPkP6yjnarLZx3a=7QSpgfaf2mUNVy14y3vCw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat 14-01-12 18:19:02, Linus Torvalds wrote:
> On Thu, Jan 5, 2012 at 6:40 AM, Jan Kara <jack@suse.cz> wrote:
> >
> > =A0for mostly historical reasons we still clear buffer_uptodate fla=
g on write
> > IO errors. This is not only semantically wrong (buffer still has co=
rrect data
> > in it)
>=20
> That statement is so nonsensical that I can't get past it.
>=20
> When you understand why it is nonsensical, you understand why the bit
> is cleared.
  Hum, let me understand this. I understand the meaning of buffer_uptod=
ate
bit as "the buffer has at least as new content as what is on disk". Now
when storage cannot write the block under the buffer, the contents of t=
he
buffer is still "at least as new as what is (was) on disk". Therefore I
made above statement about clearing buffer_uptodate bit being wrong. Bu=
t
apparently you have a different definition of buffer_uptodate or I was =
not
clear enough in explaining what I mean... Which is the case?

								Honza
--=20
Jan Kara <jack@suse.cz>
SUSE Labs, CR
