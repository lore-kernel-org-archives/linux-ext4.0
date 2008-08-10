From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Bug in delayed allocation: really bad block layouts!
Date: Sun, 10 Aug 2008 12:54:00 -0500
Message-ID: <489F2B38.3060104@redhat.com>
References: <E1KSEkA-00009o-CV@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:45181 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113AbYHJRyP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 10 Aug 2008 13:54:15 -0400
In-Reply-To: <E1KSEkA-00009o-CV@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Ts'o wrote:
> Thanks to a comment on a recent blog entry of mine[1], I think I've
> uncovered a rather embarassing bug in mballoc.
> 
> [1]http://thunk.org/tytso/blog/2008/08/08/fast-ext4-fsck-times
> 
> I created a fresh 5 gig ext4 filesystem, and then populating it using a
> single-threaded tar command:
> 
> 	(cd /usr ; tar cf - bin lib) | (cd /mnt; tar xfp -)
> 
> I then unmounted the filesystem, and ran an instrumented e2fsck looking
> for fragmented files, and found a whole series of fragmanted files with
> the following pattern:

Hm, last year I reported "delalloc fragmenting files?" and Alex sent
some patches, I wonder if they all got integrated.  I guess I should
re-run that simple large-file dd test and see how we're doing now...

ok, on a 1G single-threaded write it looks sane:

Discontinuity: Block 53248 is at 100352 (was 98303)
Discontinuity: Block 116736 is at 165888 (was 163839)
Discontinuity: Block 180224 is at 231424 (was 229375)
Discontinuity: Block 243712 is at 296960 (was 294911)

so I suppose this is not the same issue ...

Hm, and I tried writing out 10 files in order as a simple test but
umount/remount brought me back many 0-byte files, I need to update my
patchset I guess.  :)

-Eric
