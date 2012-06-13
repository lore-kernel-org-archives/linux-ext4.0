From: Arnd Bergmann <arnd.bergmann@linaro.org>
Subject: Re: [PATCH 2/3] ext4: Context support
Date: Wed, 13 Jun 2012 20:43:47 +0000
Message-ID: <201206132043.47962.arnd.bergmann@linaro.org>
References: <1339411562-17100-1-git-send-email-saugata.das@stericsson.com> <201206131944.35351.arnd.bergmann@linaro.org> <20120613200033.GB17990@thunk.org>
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
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20120613200033.GB17990@thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wednesday 13 June 2012, Ted Ts'o wrote:
> On Wed, Jun 13, 2012 at 07:44:35PM +0000, Arnd Bergmann wrote:
> > 
> > I think using the inode number is a reasonable fit. Using the
> > inode number of the parent directory might be more appropriate
> > but it breaks with hard links and cross-directory renames (we
> > must not use the same LBA with conflicting context numbers,
> > or flush the old context inbetween).
> 
> I think the inode number of the parent directory by itself is actually
> not a good idea, because there are plenty of cases where files in
> the same directory do not have the same life time.  For example,
> consider your openoffice files in ~/Documents, for example.  Or worse,
> the files in ~/Downloads written by your web browser.

Well, using the lower 4 bits of the inode number has an even higher chance
of putting stuff in the same category that does not belong there.
E.g. if you write 1000 small files in a row, they are likely to be
in just one directory, or a small number of directories, but using the
inode number as the context ID, we end up spreading them over all 15
contexts even though it would be appropriate to have them all in the
same one.

> It might be worth considering the hueristic of a series of files
> written by a single process close together in time as belonging to a
> single context.  That still might not be quite right in the case of a
> git checkout for example, most of the time I think that hueristic
> would be quite valid.

I agree that using the process as an indication would be nice, but
I could not come up with a way to ensure that we use the same
context ID if two processes are writing to the same file.

> One thing that would be worth consider when trying to decide the
> right granularity for a context would be the size of the erase block.
> If the erase block is 2 megs, and we are writing a lot of 8 meg files,
> a per-inode context granularity probably makes a lot of sense.
> 
> OTOH, if the erase block size is 8mb, and we are writing a whole bunch
> of small files, we probably want to use a much more aggressive way of
> aggregating relating blocks than just "inodes" that average in size of
> say, 32k or 128k.

I think ideally we would also want to write small files separately from
large files in the file system, and that would also make support for
contexts less useful.

For any large (sufficiently larger than erasesize) files, it would also
be nice if the extents were aligned on erase block boundaries. Again,
if we do this, using context annotations should have no benefit over
just using the default context.

> Getting this information may requiring leaning
> rather hard on the eMMC manufacturers, since they (irrationally, in my
> opinion) think this should be trade secret information.  :-(

For eMMC at least the erase block size is information that we should
be able to figure out. While I've seen devices that are lying there,
the representatives of the eMMC manufactures that I talked to basically
agreed that we should take the provided information to be correct
and if it happens to be wrong, that should be considered a firmware
bug that may result in bad performance and should be fixed in the
next version.

For SD cards, almost everyone is lying and we cannot trust the
information, and for USB flash, there is no way to ask the device.
In both of these cases, we probably want to detect the erase block
size at mkfs time using some timing attack that I worked on before.
Note that those devices also do not offer support for context IDs.

	Arnd
