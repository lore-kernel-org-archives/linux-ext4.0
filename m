From: Arnd Bergmann <arnd.bergmann@linaro.org>
Subject: Re: [PATCH 2/3] ext4: Context support
Date: Thu, 14 Jun 2012 21:55:31 +0000
Message-ID: <201206142155.32009.arnd.bergmann@linaro.org>
References: <1339411562-17100-1-git-send-email-saugata.das@stericsson.com> <201206132043.47962.arnd.bergmann@linaro.org> <20120614020757.GB8226@thunk.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Alex Lemberg <Alex.Lemberg@sandisk.com>,
	HYOJIN JEONG <syr.jeong@samsung.com>,
	Saugata Das <saugata.das@linaro.org>,
	Artem Bityutskiy <dedekind1@gmail.com>,
	Saugata Das <saugata.das@stericsson.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mmc@vger.kernel.org, patches@linaro.org, venkat@linaro.org,
	"Luca Porzio (lporzio)" <lporzio@micron.com>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-mmc-owner@vger.kernel.org>
In-Reply-To: <20120614020757.GB8226@thunk.org>
Sender: linux-mmc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thursday 14 June 2012, Ted Ts'o wrote:
> On Wed, Jun 13, 2012 at 08:43:47PM +0000, Arnd Bergmann wrote:
> > > It might be worth considering the hueristic of a series of files
> > > written by a single process close together in time as belonging to a
> > > single context.  That still might not be quite right in the case of a
> > > git checkout for example, most of the time I think that hueristic
> > > would be quite valid.
> > 
> > I agree that using the process as an indication would be nice, but
> > I could not come up with a way to ensure that we use the same
> > context ID if two processes are writing to the same file.
> 
> Oh, well *that's* easy.  Whichever process opens the file drops a
> context ID into fs-specific inode structure (for ext4, that would be
> struct ext4_inode_info), and if a second process opens the file, we
> use the same context ID.  When the last file descriptor for the inode
> is closed, we zap the context ID.

Right, that would work.

> It also occurs to me that if a file is being written to by two
> processes, it's likely that it's a update-in-place database, and we
> want to treat those special; no matter what the size, we probably
> don't want to group that file into the same context as the others.
> More generally, if a file is opened without O_CREAT, it's probably a
> good bet that it wants to either be in a context by itself, or not
> part of any context.

I think in the latter case, we actually want the database file to
be in its own context as well, to let the device know that it's
different from the other data that we send without a context.
Saugata just proposed on IRC that we could split the available
set of contexts into some that are used for linear access and
others that are used for random access. We can also make use
of POSIX_FADV_SEQUENTIAL/POSIX_FADV_RANDOM in an application
to put a file into one of these categories.

As soon as we get into the territory of the file system being
smart about keeping separate contexts for some files rather than
just using the low bits of the inode number or the pid, we get
more problems:

* The block device needs to communicate the number of available
  contexts to the file system
* We have to arbitrate between contexts used on different partitions
  of the same device

> The files which we would probably find most interesting is the files
> which are created from scratch, and more specifically, for files which
> are dumped out all at once: i.e., open w/O_CREAT, optional fallocate,
> write, optional fsync, and close.  If we can detect a series of file
> operations with this characteristic originating from the same process,
> when we detect a second open w/O_CREAT very shortly after the first
> O_CREAT in the same directory from the same process, we simply reuse
> the context ID for the second and subsequent files.

Yes, makes sense.

> > I think ideally we would also want to write small files separately from
> > large files in the file system, and that would also make support for
> > contexts less useful.
> 
> Well, for file systems with delayed allocation, this is actually
> pretty easy.  By the time we do the writeback for a file with delayed
> allocation, if it's substantially bigger than the erase block size and
> we haven't yet written any blocks for the file, we should give it a
> new context ID.  And furthermore, your idea that we should try to
> align the file on an erase block boundary would be a great thing to
> do.

My feeling is that we would actually benefit much more from the
erase block alignment than from the context for the large files.

There is one more option we have to give the best possible performance,
although that would be a huge amount of work to implement:

Any large file gets put into its own context, and we mark that
context "write-only" "unreliable" and "large-unit". This means the
file system has to write the file sequentially, filling one erase
block at a time, writing only "superpage" units (e.g. 16KB) or
multiples of that at once. We can neither overwrite nor read back
any of the data in that context until it is closed, and there is
no guarantee that any of the data has made it to the physical medium
before the context is closed. We are allowed to do read and write
accesses to any other context between superpage writes though.
After closing the context, the data will be just like any other
block again.

Right now, there is no support for large-unit context and also not for
read-only or write-only contexts, which means we don't have to
enforce strict policies and can basically treat the context ID
as a hint. Using the advanced features would require that we
keep track of the context IDs across partitions and have to flush
write-only contexts before reading the data again. If we want to
do that, we can probably discard the patch series and start over.

> > For eMMC at least the erase block size is information that we should
> > be able to figure out. While I've seen devices that are lying there,
> > the representatives of the eMMC manufactures that I talked to basically
> > agreed that we should take the provided information to be correct
> > and if it happens to be wrong, that should be considered a firmware
> > bug that may result in bad performance and should be fixed in the
> > next version.
> 
> What would be *great* is if the erase block size were exposed in
> sysfs, and that the blockid library (which is how mke2fs and other
> similar mkfs programs get other storage device parameters) were
> enhanced to return this information.

For eMMC and SD devices, it's available in the preferred_erase_size
sysfs attribute, but other devices don't have that. What we've also
discussed in the past is to make that size available to the
I/O scheduler in order to implement a way to flush out all writes
for a given erase block at once, because that essentially comes
for free once we do the first write into that erase block.

That value would have to be user-selectable though, and we need
to come up with a way to do that for partitioned devices. While it
would be nice for ext4 to be able to set the property of the
block device based on the superblock data, that would fail as soon
as we have multiple partitions with conflicting settings.

> > For SD cards, almost everyone is lying and we cannot trust the
> > information, and for USB flash, there is no way to ask the device.
> > In both of these cases, we probably want to detect the erase block
> > size at mkfs time using some timing attack that I worked on before.
> > Note that those devices also do not offer support for context IDs.
> 
> Yes, although presumably aligning large files to erase block
> boundaries would still be useful, yes?

Yes, very much so.

> So adding an erase block size to the ext2/3/4 superblock sounds like a
> first great step.  By making it be a superblock field, that way it's
> possible to override the value returned by the hardware if it turns
> out to be a lie, and we can also use programs like flashbench to
> figure out the erase block size and populate the superblock value via
> some userspace process.  (Possibly called out of mke2fs directly if we
> can automate it completely, and make it dead reliable.)

I think this is something we can do in the Linaro storage team.
We actually have plans to also put the erase block size in the swap
header, so we should be able to use the same code in mke2fs and mkswap,
and potentially others. What we discussed in the storage team meeting
today is that we start out by making ext4 aware of the erase block
size through the superblock and aligning extents for large files to
erase block boundaries.

If that works out well, the second step would be to detect which small
files are use a random-write pattern and group them in erase blocks
that are distinct from erase blocks for linear-write files.

	Arnd
