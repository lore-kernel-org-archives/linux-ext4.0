From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/3] ext4: Context support
Date: Wed, 13 Jun 2012 22:07:57 -0400
Message-ID: <20120614020757.GB8226@thunk.org>
References: <1339411562-17100-1-git-send-email-saugata.das@stericsson.com>
 <201206131944.35351.arnd.bergmann@linaro.org>
 <20120613200033.GB17990@thunk.org>
 <201206132043.47962.arnd.bergmann@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alex Lemberg <Alex.Lemberg@sandisk.com>,
	HYOJIN JEONG <syr.jeong@samsung.com>,
	Saugata Das <saugata.das@linaro.org>,
	Artem Bityutskiy <dedekind1@gmail.com>,
	Saugata Das <saugata.das@stericsson.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mmc@vger.kernel.org, patches@linaro.org, venkat@linaro.org,
	"Luca Porzio (lporzio)" <lporzio@micron.com>
To: Arnd Bergmann <arnd.bergmann@linaro.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <201206132043.47962.arnd.bergmann@linaro.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jun 13, 2012 at 08:43:47PM +0000, Arnd Bergmann wrote:
> > It might be worth considering the hueristic of a series of files
> > written by a single process close together in time as belonging to a
> > single context.  That still might not be quite right in the case of a
> > git checkout for example, most of the time I think that hueristic
> > would be quite valid.
> 
> I agree that using the process as an indication would be nice, but
> I could not come up with a way to ensure that we use the same
> context ID if two processes are writing to the same file.

Oh, well *that's* easy.  Whichever process opens the file drops a
context ID into fs-specific inode structure (for ext4, that would be
struct ext4_inode_info), and if a second process opens the file, we
use the same context ID.  When the last file descriptor for the inode
is closed, we zap the context ID.

It also occurs to me that if a file is being written to by two
processes, it's likely that it's a update-in-place database, and we
want to treat those special; no matter what the size, we probably
don't want to group that file into the same context as the others.
More generally, if a file is opened without O_CREAT, it's probably a
good bet that it wants to either be in a context by itself, or not
part of any context.

The files which we would probably find most interesting is the files
which are created from scratch, and more specifically, for files which
are dumped out all at once: i.e., open w/O_CREAT, optional fallocate,
write, optional fsync, and close.  If we can detect a series of file
operations with this characteristic originating from the same process,
when we detect a second open w/O_CREAT very shortly after the first
O_CREAT in the same directory from the same process, we simply reuse
the context ID for the second and subsequent files.

> I think ideally we would also want to write small files separately from
> large files in the file system, and that would also make support for
> contexts less useful.

Well, for file systems with delayed allocation, this is actually
pretty easy.  By the time we do the writeback for a file with delayed
allocation, if it's substantially bigger than the erase block size and
we haven't yet written any blocks for the file, we should give it a
new context ID.  And furthermore, your idea that we should try to
align the file on an erase block boundary would be a great thing to
do.

> For eMMC at least the erase block size is information that we should
> be able to figure out. While I've seen devices that are lying there,
> the representatives of the eMMC manufactures that I talked to basically
> agreed that we should take the provided information to be correct
> and if it happens to be wrong, that should be considered a firmware
> bug that may result in bad performance and should be fixed in the
> next version.

What would be *great* is if the erase block size were exposed in
sysfs, and that the blockid library (which is how mke2fs and other
similar mkfs programs get other storage device parameters) were
enhanced to return this information.

> For SD cards, almost everyone is lying and we cannot trust the
> information, and for USB flash, there is no way to ask the device.
> In both of these cases, we probably want to detect the erase block
> size at mkfs time using some timing attack that I worked on before.
> Note that those devices also do not offer support for context IDs.

Yes, although presumably aligning large files to erase block
boundaries would still be useful, yes?

So adding an erase block size to the ext2/3/4 superblock sounds like a
first great step.  By making it be a superblock field, that way it's
possible to override the value returned by the hardware if it turns
out to be a lie, and we can also use programs like flashbench to
figure out the erase block size and populate the superblock value via
some userspace process.  (Possibly called out of mke2fs directly if we
can automate it completely, and make it dead reliable.)

    	     		    	     	- Ted
