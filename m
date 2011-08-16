From: Jan Kara <jack@suse.cz>
Subject: Re: DIO process stuck apparently due to dioread_nolock (3.0)
Date: Tue, 16 Aug 2011 15:53:25 +0200
Message-ID: <20110816135325.GD23416@quack.suse.cz>
References: <4E456436.8070107@msgid.tls.msk.ru>
 <1313251371-3672-1-git-send-email-tm@tao.ma>
 <4E4836A8.3080709@msgid.tls.msk.ru>
 <4E48390E.9050102@msgid.tls.msk.ru>
 <4E488625.609@tao.ma>
 <4E48D231.5060807@msgid.tls.msk.ru>
 <4E48DF31.4050603@msgid.tls.msk.ru>
 <CAFgt=MAfbU_muEzmxx-8CK8w7=nGR5dUZSgBQ1dN6XkyrTbO9g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Michael Tokarev <mjt@tls.msk.ru>, Tao Ma <tm@tao.ma>,
	linux-ext4@vger.kernel.org, sandeen@redhat.com,
	Jan Kara <jack@suse.cz>
To: Jiaying Zhang <jiayingz@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41383 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751377Ab1HPNxk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 16 Aug 2011 09:53:40 -0400
Content-Disposition: inline
In-Reply-To: <CAFgt=MAfbU_muEzmxx-8CK8w7=nGR5dUZSgBQ1dN6XkyrTbO9g@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 15-08-11 16:53:34, Jiaying Zhang wrote:
> On Mon, Aug 15, 2011 at 1:56 AM, Michael Tokarev <mjt@tls.msk.ru> wro=
te:
> > 15.08.2011 12:00, Michael Tokarev wrote:
> > [....]
> >
> > So, it looks like this (starting with cold cache):
> >
> > 1. rename the redologs and copy them over - this will
> > =A0 make a hot copy of redologs
> > 2. startup oracle - it will complain that the redologs aren't
> > =A0 redologs, the header is corrupt
> > 3. shut down oracle, start it up again - it will succeed.
> >
> > If between 1 and 2 you'll issue sync(1) everything will work.
> > When shutting down, oracle calls fsync(), so that's like
> > sync(1) again.
> >
> > If there will be some time between 1. and 2., everything
> > will work too.
> >
> > Without dioread_nolock I can't trigger the problem no matter
> > how I tried.
> >
> >
> > A smaller test case. =A0I used redo1.odf file (one of the
> > redologs) as a test file, any will work.
> >
> > =A0$ cp -p redo1.odf temp
> > =A0$ dd if=3Dtemp of=3Dfoo iflag=3Ddirect count=3D20
> Isn't this the expected behavior here? When doing
> 'cp -p redo1.odf temp', data is copied to temp through
> buffer write, but there is no guarantee when data will be
> actually written to disk. Then with 'dd if=3Dtemp of=3Dfoo
> iflag=3Ddirect count=3D20', data is read directly from disk.
> Very likely, the written data hasn't been flushed to disk
> yet so ext4 returns zero in this case.
  No it's not. Buffered and direct IO is supposed to work correctly
(although not fast) together. In this particular case we take care to f=
lush
dirty data from page cache before performing direct IO read... But
something is broken in this path obviously.

I don't have time to dig into this in detail now but what seems to be t=
he
problem is that with dioread_nolock option, we don't acquire i_mutex fo=
r
direct IO reads anymore. Thus these reads can compete with
ext4_end_io_nolock() called from ext4_end_io_work() (this is called und=
er
i_mutex so without dioread_nolock the race cannot happen).

Hmm, the new writepages code seems to be broken in combination with dir=
ect
IO. Direct IO code expects that when filemap_write_and_wait() finishes,
data is on disk but with new bio submission code this is not true becau=
se
we clear PageWriteback bit (which is what filemap_fdatawait() waits for=
) in
ext4_end_io_buffer_write() but do extent conversion only after that in
convert workqueue. So the race seems to be there all the time, just wit=
hout
dioread_nolock it's much smaller.

=46ixing this is going to be non-trivial - I'm not sure we can really m=
ove
clearing of PageWriteback bit to conversion workqueue. I think we alrea=
dy
tried that once but it caused deadlocks for some reason...

> > Now, first 512bytes of "foo" will contain all zeros, while
> > the beginning of redo1.odf is _not_ zeros.
> >
> > Again, without aioread_nolock it works as expected.
> >
> >
> > And the most important note: without the patch there's no
> > data corruption like that. =A0But instead, there is the
> > lockup... ;)

								Honza
--=20
Jan Kara <jack@suse.cz>
SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
