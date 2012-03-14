From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: getdents - ext4 vs btrfs performance
Date: Wed, 14 Mar 2012 10:38:24 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1203141032260.5379@dhcp-27-109.brq.redhat.com>
References: <CADDYkjS5VJeYyHzqumazQ0qKg+HwA6GO+zYSJj7rkHNZFwjcoQ@mail.gmail.com> <alpine.LFD.2.00.1203091158430.4487@dhcp-27-109.brq.redhat.com> <BCAD47C1-B95A-4EDB-8EFB-3D4E325DE57D@whamcloud.com> <20120310044804.GB5652@thunk.org> <4F5F9A97.5060404@ubuntu.com>
 <20120313195339.GA24124@thunk.org> <4F5FAC9C.9070607@gmail.com> <20120313213304.GB11969@thunk.org> <alpine.LFD.2.00.1203140825090.5379@dhcp-27-109.brq.redhat.com> <CAGBYx2Y8NwAiT5M1ZvPbuYspUGVDGy-H+ZPCL0aQ+AjJ6rphYw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-336910903-1331717908=:5379"
Cc: Lukas Czerner <lczerner@redhat.com>, "Ted Ts'o" <tytso@mit.edu>,
	Phillip Susi <phillsusi@gmail.com>,
	Andreas Dilger <adilger@whamcloud.com>,
	Jacek Luczak <difrost.kernel@gmail.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGBYx2Y8NwAiT5M1ZvPbuYspUGVDGy-H+ZPCL0aQ+AjJ6rphYw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-336910903-1331717908=:5379
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Wed, 14 Mar 2012, Yongqiang Yang wrote:

> On Wed, Mar 14, 2012 at 4:12 PM, Lukas Czerner <lczerner@redhat.com> wrote:
> > On Tue, 13 Mar 2012, Ted Ts'o wrote:
> >
> >> On Tue, Mar 13, 2012 at 04:22:52PM -0400, Phillip Susi wrote:
> >> >
> >> > I think a format change would be preferable to runtime sorting.
> >>
> >> Are you volunteering to spearhead the design and coding of such a
> >> thing?  Run-time sorting is backwards compatible, and a heck of a lot
> >> easier to code and test...
> >
> > Actually I am in the process of creating some projects for the local
> > universities and this certainly sounds like something that some student
> > can do. I have already put that into the proposal, so we might have
> > someone looking into this in the near future. Since the problem has been
> > there since forever, I think that it's not that critical to solve it
> > right away.
> >
> > I kind of like the idea about having the separate btree with inode
> > numbers for the directory reading, just because it does not affect
> > allocation policy nor the write performance which is a good thing. Also
> > it has been done before in btrfs and it works very well for them. The
> > only downside (aside from format change) is the extra step when removing
> > the directory entry, but the positives outperform the negatives.
> >
> >
> > Maybe this might be even done in a way which does not require format
> > change. We can have new inode flag (say EXT4_INUM_INDEX_FL) which will
> > tell us that there is a inode number btree to use on directory reads.
> > Then the pointer to the root of that tree would be stored at the end of
> > the root block of the hree (of course if there is still some space for
> > it) and the rest is easy.
> dx_root takes 32 bytes from 60 bytes of i_data.  The beginning of
> dx_entries is controlled by info_length, that is, dx_root->info +
> dx_root->info->info_length.   It seems that we can put the new tree
> root behind dx_root and add the length of the new tree root to
> info_length.  Then the old code can handle new filesystem and new code
> can handle old filesystem because of the flag you described above.

Yes, there might be other places where we can store the new root. The
first idea was just from top of my head, we can certainly polish it a
bit more.

> 
> If no one attempts to do it ,  I can do it as a google summer of code project.

As I wrote in the first paragraph this project is already taken :). It
will be the student project for our local universities. Actually I have
already finished the proposal. I can not stop you from doing it as a
soc project, although I am not sure that in this case it would be good
to have two people working on exactly the same problem.

Thanks!
-Lukas

> 
> Yongqiang.
> >
> > So If we mount the old file system with the new code, there will not be
> > the flag, but with newly added directories it could be used anyway. Also
> > e2fsck could easily add the inumber tree into the directory if it is
> > missing.
> >
> > If we mount the new file system with the old code (the one which does
> > not know about this feature), everything would stay the same and we
> > would not touch the inumber tree at all. Of course there is a
> > possibility that we would rewrite the end of the root htree, overwriting
> > the pointer to the inumber tree and effectively losing one block. We
> > would not actually care that we rewrote this information because we
> > do not actually need it, so the only downside is the one block lost,
> > which is not that bad I guess.
> >
> > Now, we have rewritten the pointer to the inumber tree and we're going
> > to mount it with the new code again. It would expect the the inumber
> > tree to be there, but not blindly. Some king of magic information would
> > have to be stored in the inumber root pointer so we can be sure that it
> > really is what we're looking for and if it is not there, well then we do
> > not care and walk the directory in the old way. And we can alway create
> > the inumber tree in the new directory. And again e2fsck should be able
> > to fix that for us as well.
> >
> > So that is just an idea, I have not looked at the actual code to see it
> > it would be really possible, but it certainly seems like so. Am I
> > missing something ?
> >
> >
> > Anyway, if there is going to be a format change I agree that having
> > solution for those who are not comfortable with the format change is
> > equally as important. But maybe there will be better solution which does
> > not require the format change.
> >
> > Thanks!
> > -Lukas
> >
> >>
> >> The reality is we'd probably want to implement run-time sorting
> >> *anyway*, for the vast majority of people who don't want to convert to
> >> a new incompatible file system format.  (Even if you can do the
> >> conversion using e2fsck --- which is possible, but it would be even
> >> more code to write --- system administrators tend to be very
> >> conservative about such things, since they might need to boot an older
> >> kernel, or use a rescue CD that doesn't have an uptodate kernel or
> >> file system utilities, etc.)
> >>
> >> > So the index nodes contain the hash ranges for the leaf block, but
> >> > the leaf block only contains the regular directory entries, not a
> >> > hash for each name?  That would mean that adding or removing names
> >> > would require moving around the regular directory entries wouldn't
> >> > it?
> >>
> >> They aren't sorted in the leaf block, so we only need to move around
> >> regular directory entries when we do a node split (and at the moment
> >> we don't support shrinking directories), so we don't have to worry the
> >> reverse case.
> >>
> >> > I would think that hash collisions are rare enough that reading a
> >> > directory block you end up not needing once in a blue moon would be
> >> > chalked up under "who cares".  So just stick with hash, offset pairs
> >> > to map the hash to the normal directory entry.
> >>
> >> With a 64-bit hash, and if we were actually going to implement this as
> >> a new incompatible feature, you're probably right in terms of
> >> accepting the extra directory block search.
> >>
> >> We would still have to implement the case where hash collisions *do*
> >> exist, though, and make sure the right thing happens in that case.
> >> Even if the chance of that happening is 1 in 2**32, with enough
> >> deployed systems (i.e., every Android handset, etc.) it's going to
> >> happen in real life.
> >>
> >>                                       - Ted
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 
> 

-- 
--8323328-336910903-1331717908=:5379--
