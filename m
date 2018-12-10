Return-Path: <SRS0=P4kf=OT=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:40324 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726268AbeLJAI0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 9 Dec 2018 19:08:26 -0500
Date: Sun, 9 Dec 2018 19:08:22 -0500
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        kernel@collabora.com, linux-ext4@vger.kernel.org,
        krisman@collabora.com
Subject: Re: [PATCH v4 00/23] Ext4 Encoding and Case-insensitive support
Message-ID: <20181210000822.GD1840@mit.edu>
References: <20181206230903.30011-1-krisman@collabora.com>
 <20181208194128.GE20708@thunk.org>
 <CAHk-=wg2JvjXfdZ8K5Tv3vm6+bKRedotF5cr5AwVZVBypVfdAQ@mail.gmail.com>
 <CAHk-=wg9J+9H4kvzF0SmBP_CoSrBTxPc6xMRJKb3fDnOUs0DNw@mail.gmail.com>
 <20181209050326.GA28659@mit.edu>
 <CAHk-=wgLYy3pRFDxwXB1THf4ev2C6VOmK5m7tfSwwv+EC9pM3Q@mail.gmail.com>
 <20181209201043.GA1840@mit.edu>
 <CAHk-=wh9CXVF6VZ8ZN5aRoRZyPb5ZME3LqNspPNd3LwQFHJT0Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHk-=wh9CXVF6VZ8ZN5aRoRZyPb5ZME3LqNspPNd3LwQFHJT0Q@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Dec 09, 2018 at 12:54:38PM -0800, Linus Torvalds wrote:
> First off, there is no such thing as "one" unicode table for case
> folding. There are lots and lots of tables, and I'm not clear what
> table it is all about.
> 
> For example, both OS X and Windows do some form of case folding on
> unicode. They don't do the *same* folding, though.

So things are much better in recent years.  In the past it was kind of
a disaster, but the world is converging enough that the latest
versions of Mac OS'x APFS and Windows NTFS behave pretty much the same
way.  They are both case-insensitive, case-preserving and
normalization-preserving, normalization-insensitive with respect to
filenames.

In the bad old-days, MacOS X's HFS+ was not normalization-preserving.
So it would force filenames to NFD form --- so if the user tried to
create a file named Å, and passed in the Unicode string U+212B to
creat(2), HFS+ would store it as U+0041,U+030A and that is what
readdir(2) would return.  Apple has effectively admitted this was a
mistake, and their new APFS doesn't do this any more.

Now, both file systems basically say, "we don't care whether you pass
in U+212B or U+0041,U+030A; on the screen it looks identical, Å, so we
will treat it as the same filename; but readdir(2) will return what
you gave us."

It's been a *long* time since Unicode has changed case folding rules
for pre-existing characters.  The tables have only changed with
respect to the new character sets have been added.  If you have a set
of filenames which were all legal under Unicode 5.0, how they case
fold didn't change with respect to Unicode 6.0, 7.0, 8.0 9.0, 10.0 or
11.0.

Unicode 11.0 added some character sets like Ancient Sanskrit, a bunch
of new emoji's, and the copyleft symbol, and to the extent that
Ancient Sanskrit had case, the tables might have been *extended*.  But
that doesn't break backwards compatibility.

And, of course, MacOS and Windows have been aggressively tracking
Unicode updates because everybody wants the latest emoji's.  :-)

And it's not just SAMBA/CIFS.  The NFSv4 protocol also provides for
case/normalization preserving filenames, and you can specify a NFSv4
mount option whether or not file name lookups should be
case/normalization insensitive.  And the NFSv4 protocol specs also
specify the use of the Unicode thables, of which the latest versions
can be downloaded here:

	http://www.unicode.org/Public/11.0.0/ucd/

So how about this?  We'll put the unicode handling functions in a new
directory, fs/unicode, just to make it really clear that this will now
be changing any of the legacy fs/nls functions which other file
systems will use.  By putting it in a separate directory, it will be
easier for other file systems to use it, whether it's for better Samba
or NFSv4 support.

						- Ted
