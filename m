From: Arnd Bergmann <arnd.bergmann@linaro.org>
Subject: Re: [PATCH 2/3] ext4: Context support
Date: Tue, 12 Jun 2012 13:29:25 +0000
Message-ID: <201206121329.25953.arnd.bergmann@linaro.org>
References: <1339411562-17100-1-git-send-email-saugata.das@stericsson.com> <20120611122736.GA14051@thunk.org> <CAKLKtzeo1x+0Kxd0+29yqvXh4FBiS+p=T7b1-BWb6HXH5e1hhQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: "Ted Ts'o" <tytso@mit.edu>, Artem Bityutskiy <dedekind1@gmail.com>,
	Saugata Das <saugata.das@stericsson.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mmc@vger.kernel.org, patches@linaro.org, venkat@linaro.org
To: Saugata Das <saugata.das@linaro.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CAKLKtzeo1x+0Kxd0+29yqvXh4FBiS+p=T7b1-BWb6HXH5e1hhQ@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tuesday 12 June 2012, Saugata Das wrote:
> On 11 June 2012 17:57, Ted Ts'o <tytso@mit.edu> wrote:
> > On Mon, Jun 11, 2012 at 02:41:31PM +0300, Artem Bityutskiy wrote:
> > The proof-of-concept patches seem to use the inode number as a way of
> > trying to group related writes, but what about at a larger level than
> > that?  For example, if we install a RPM or deb package where all of
> > the files will likely be replaced together, should that be given the
> > same context?
> 
> In this patch, context is used at file level based on inode number.
> So, in the above example, multiple contexts will be used for the
> directory, file updates during RPM installation.
> 
> >
> > How likely does it have to be that related blocks written under the
> > same context must be deleted at the same time for this concept to be
> > helpful?
> 
> There is no restriction that related blocks within the MMC context
> needs to be deleted together

I don't think that is correct. The most obvious implementation in eMMC
hardware for this would be to group all data from one context to be
written into the same erase block, in order to reduce the amount
of garbage collection that needs to happen at erase time. AFAICT,
the main interest here is, as Ted is guessing correctly, to make sure
that all data which gets written into one context has roughly the
same life time before it gets erased or overwritten.

> > If we have a context where it is the context assumption does
> > not hold (example: a database where you have a random access
> > read/write pattern with blocks updated in place) how harm will it be
> > to the device format if those blocks are written under the same
> > context?
> >
> 
> MMC context allows the data blocks to be overwritten or randomly accessed

That is of course the defined behavior of a block device that does
not change with the use of contexts. To get the best performance,
a random-write database file would always reside in a context by itself
and not get mixed with long-lived write-once data. If we have a way
in the file system to tell whether a file is written linearly or randomly
(e.g. by looking at the O_APPEND or O_CREAT flag), it might make sense
to split the context space accordingly.

> > The next set of questions we need to ask is how generalizable is this
> > concept to devices that might be more sophisticated than simple eMMC
> > devices.  If we're going to expose something all the way out to the
> > file system layer, it would be nice if it worked on more than just
> > low-end flash devices, but also on more sophisticated devices as well.
> >
> 
> This context mechanism will be used on both UFS and MMC devices. If
> there are some alternate suggestions on what can be used as context
> from file system perspective, then please  suggest.

One suggestion that has been made before was to base the context on
the process ID rather than the inode number, but that has many other
problems, e.g. when the same file gets written by multiple processes.

	Arnd
