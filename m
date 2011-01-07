From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Problems with e4defrag -c
Date: Fri, 7 Jan 2011 14:38:10 -0500
Message-ID: <20110107193810.GP21922@thunk.org>
References: <E1PWFc1-0002cm-QV@tytso-glaptop>
 <4D256E18.3010708@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Kazuya Mio <k-mio@sx.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:60746 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753955Ab1AGTiP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 7 Jan 2011 14:38:15 -0500
Content-Disposition: inline
In-Reply-To: <4D256E18.3010708@sx.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> > What really matters are the number of extents which are non-tail
> > extents, and smaller than some threshold (probably around 256 MB for
> > most HDD's), and not forced by skips in the logical block numbering
> > (i.e., caused by a file being sparse).  The basic idea here is to go
> > back to why fragments are bad, which is that they slow down file access.
> > If every few hundred megabytes, you need to seek to another part of the
> > disk, it's really not the end of the world.
> 
> What does 256MB mean? If "some threshold" means the maximum size of
> one extent, I think the size is 128MB.

256MB was an arbitrary number I picked out of thin air.  My point was
that when we start thinking about defragmentation, especially from a
holistic optimize-the-entire-filesystem perspective, one of the things
that we need to think about is whether a file's fragmentation is "good
enough".  In fact, depending on the flex blockgroup size, it might not
be possible to have contiguous block allocations larger than 32MB or
128MB.

The reason why this matters is because humans will see the
fragmentation score, not just programs, and it's better if the
fragmentation score more accurately reflects the desired end-result.
What I didn't like was the fact that files that were actually
contiguous, but small (say, in a 6k file that was contiguously
allocated), were scored worse than a medium-sized file that was broken
into two pieces.  And if we have a really, really large file, that was
say 2TB, but broken into chunks of 256MB each --- how should these
three example files be scored?

A file which is contiguous is obviously perfect, and there's no reason
to defrag it, so it should have a very good score.  For a really large
file, each of which (aside from the last "tail" fragment) is broken up
into large fragments of 128MB or 256MB each, I'd argue should also be
left alone, and so it should also get a very good score.

If we do it that way, I'm not sure we really need to have access to
the superblock to get various file system values.  I can imagine
requesting certain parameters --- if you have root access, you can
grab the superblock and adjust the "threshold of perfection" down from
256MB to 32MB if flex_bg is not enabled, or based on the size of the
flex_bg groups.  But if you don't have access, it might be smarter
just to use some default "threshold of perfection", as opposed to
having lots of "do we have root" checks sprinkled all over the
program.

> Currently, e2fsprogs has two commands that report how badly
> fragmented a file might be. So, it is smart for e2fsprogs to drop -c
> option from e4defrag.  e4defrag -c shows whether we need to execute
> e4defrag or not. For this, I think we should add "fragmentation
> score" included in e4defrag -c to the output of filefrag.

Hmm, maybe the right answer is that we have a single function, located
in libe2p, that calculates the "fragmentation score".  We can separate
that out from the e4defrag code, and make it be a library function.
The programs that want to use it can call that library function.
(Parameters to the fragmentation score, such as the "threshold of
perfection", would be passed into the library function, along with a
file descriptor to the file so that FIEMAP could be called on that
file.)

> However, sometimes we want to check the fragmentation not only for a
> single file but also for many files in the same directory. e4defrag
> -c gets the extent information of all files in a directory, and
> calculates the fragmentation score based on this information. But
> I'm not sure that I should add this feature to filefrag by adding
> new option or some other way.

I'm not sure how useful it is to do a recursive tree walk just to
display the information for all the files in the directory.  Filefrag
will already take a list of files on the command-line, and if you want
to do a recursive tree walk, you can do a "find /path/to/dir -type f |
xargs filefrag".

The main reason why I could see e4defrag wanting to know the
fragmentation scores of all of the files in the directory is so it
could make decisions about whether or not to even attempt to defrag a
file.  If a file has a very good score, then maybe we should just
leave well enough alone and not even try to defrag it.  I'm reminded
of the earliest Norton Utilities, that would spend hours trying to
defrag a disk to perfection.  Later versions added the concept of
"good enough"; if the disk was good enough, sometimes it's better to
leave well enough alone, as opposed to spending hours and hours, and
lots of disk bandwidth, striving for perfection.

					- Ted
