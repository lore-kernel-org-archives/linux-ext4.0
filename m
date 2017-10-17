From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Recover from a "deleted inode referenced" situation
Date: Tue, 17 Oct 2017 12:48:04 -0400
Message-ID: <20171017164804.nh5e5x4dwfvmk25c@thunk.org>
References: <CAJz=VjEUqxMNo6zShYaV5ffioxaj6+a5Av0imtfdtCDf7wqY=A@mail.gmail.com>
 <32D25551-5517-4B17-B89B-2A1D60249ABA@dilger.ca>
 <CAJz=VjG+7Q0j7erfNC8ocwnkkgtrDXK-Ma_pRLSu7yiGZXH88w@mail.gmail.com>
 <CAJz=VjEOnU=wsdjmHitxQsTXvW7AMgYRiKFJPGq_imPUbu5+GQ@mail.gmail.com>
 <2938B452-C59B-4D39-AE6F-1741A38B28A7@dilger.ca>
 <CAJz=VjEiP9-bepzSoZm-TeUWY=Pc=m3gXFH2rRJtFqKR6PXTMA@mail.gmail.com>
 <20171015124800.zjsqu623rivp27qv@thunk.org>
 <CAJz=VjFWWZoTH1+BEnFwk=8CK0ZZtOAQW7hzE6JhX8A5pZWW6g@mail.gmail.com>
 <20171016012852.pz63e7hd67c7ipy5@thunk.org>
 <CAJz=VjF_BGVuCrhDbQA7H3nwVLVF2PyWppwCe5mV6DDPAZ6UWQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org
To: Kilian Cavalotti <kilian.cavalotti.work@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:57706 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1763378AbdJQQsG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 17 Oct 2017 12:48:06 -0400
Content-Disposition: inline
In-Reply-To: <CAJz=VjF_BGVuCrhDbQA7H3nwVLVF2PyWppwCe5mV6DDPAZ6UWQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 17, 2017 at 08:32:52AM -0700, Kilian Cavalotti wrote:
> On Sun, Oct 15, 2017 at 6:28 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> >> Is there any possibility that the filesystem could appear to be
> >> resized (extended) with the actual inode table still referencing the
> >> pre-resize one?
> >
> > It's possible, I suppose.  If the vendor script unmounted the file
> > system and then attempted to run e2fsck -fy to fix the file system,
> > perhaps.  In which case the damage could also have been done by the
> > e2fsck -fy run, depending on how badly the file system was corrupted
> > before this whole procedure was started.
> 
> In that case, is there any way to re-shrink the filesystem to its
> pre-expansion size, and try to read the pre-expansion inode table from
> another superblock? Or did the r/w remount over-write all the existing
> superblocks with the same new, corrupted information?

Unfortunately, if this is what happened, then the true damage was done
when the file system was remounted read/write, and because the
allocation bitmaps were incorrect, portions of the inode table were
overwritten with file data.  (As I mentioned, with modern file systems
there is a safety check which is now enabled by default which will
notice when there is an attempt to allocate blocks that are part of
the inode table, and stop this Very Bad Thing from happening.  It does
take a tiny bit of extra CPU overhead, but we ultimately decided It
Was Worth It.  Unfortunately, it was not enabled by default in the
3.10 kernel.)

There's not really any recovery possible in that case, unfortunately.  :-(

	    	       			    - Ted
