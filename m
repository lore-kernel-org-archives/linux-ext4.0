From: "Peter Teoh" <htmldeveloper@gmail.com>
Subject: Re: Mentor for a GSoC application wanted (Online ext2/3 filesystem checker)
Date: Wed, 23 Apr 2008 00:54:28 +0800
Message-ID: <804dabb00804220954s67d56cacj89098d88697565aa@mail.gmail.com>
References: <f19298770804180720w2e72b821j95b709c1dd1b1c25@mail.gmail.com>
	 <20080419012952.GE25797@mit.edu>
	 <f19298770804190244y5d6a8502p39f98d1c420135a@mail.gmail.com>
	 <20080419185603.GA30449@mit.edu> <480A42F6.2030005@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Theodore Tso" <tytso@mit.edu>,
	"Alexey Zaytsev" <alexey.zaytsev@gmail.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	"Rik van Riel" <riel@surriel.com>
To: "Eric Sandeen" <sandeen@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <480A42F6.2030005@redhat.com>
Content-Disposition: inline
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, Apr 20, 2008 at 3:07 AM, Eric Sandeen <sandeen@redhat.com> wrote:
> Theodore Tso wrote:
>  > On Sat, Apr 19, 2008 at 01:44:51PM +0400, Alexey Zaytsev wrote:
>  >> If it is a block containing a metadata object fsck has already read,
>  >> than we already know what kind of object it is (there must be a way
>  >> to quickly find all cached objects derived from a given block), and
>  >> can update the cached version. And if fsck has not yet read the
>  >> block, it can just be ignored, no matter what kind of data it
>  >> contains. If it contains metadata and fsck is intrested in it, it
>  >> will read it sooner or later anyway. If it contains file data, why
>  >> should fsck even care?
>
>  It seems to me that what the proposed project really does, in essence,
>  is a read-only check of a filesystem snapshot.  It's just that the
>  snapshot is proposed to be constructed in a complex and non-generic (and
>  maybe impossible) way.
>
>  If you really just want to verify a snapshot of the fs at a point in
>  time, surely there are simpler ways.  If the device is on lvm, there's
>  already a script floating around to do it in automated fasion.  (I'd
>  pondered the idea of introducing META_WRITE (to go with META_READ) and
>  maybe lvm could do a "metadata-only" snapshot to be lighter weight?)
>

Can I know where is this script?   Or if u cannot locate it, does it
have any resemblance to all the stuff mentioned below?.

Apologizing for the regression of discussion back to this part again,
(and pardon my superficial knowledge of filesystem, just brainstorming
and eager to learn :-)), I think the idea of "online checker" can be
developed further, taking into consideration all that have been said
in this threads - morphing into "semi-online" (real online is not
feasible eg what have been fscked can be immediately be invalidated by
another subsequent corrupted writes, so the idea of fsck on read-only
snapshot is best we could achieved, and then mark the fsck results
with the timestamp, so that all writes beyond this timestamp may
invalidate the earlier fsck results.   This idea has its equivalence
in the Oracle database world - "online datafile backup" feature, where
all transactions goes to memory + journal logs (a physical file
itself), and datafile is frozen for writing, enabling it to be
physically copied):

a.   First, integrity of the filesystem must be treated as a WHOLE,
and therefore, all WRITES must somehow be frozen at THE SAME TIME,
and, after that point in time, all writes will then go direct to
memory only.   So the permanent storage will be readonly.    This I
guessed is the readonly snapshot part, correct?

b.   Concerning all the different infinite combination of race
condition that can happened, it should not happen here.   This is
because now the entire filesystem's integrity is maintained as a
whole.

c.   The only difficulty i can see is that updates to the journal logs
- can this part of online updates just go to memory temporarily, while
the frozen image is being fsck?

d.   When ALL fsck is done, everything in memory will get resync with
the filesystem.   and during this short period of resyncing, all
writing should be completely frozen - no writing to disk nor memory,
as race condition may arise.   after syncing, all read/writing to go
direct to the disk.

Complexity of cache interaction is beyond my understanding.   Some are
rephrasing or adaptation of what I have read in this thread, so is my
understanding correct?

Thank you for sharing.
-- 
Regards,
Peter Teoh
