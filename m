From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 2/3] mke2fs: print extra information about existing
 ext2/3/4 file systems
Date: Mon, 5 May 2014 16:38:37 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1405051629270.2223@localhost.localdomain>
References: <1399295044-24489-1-git-send-email-tytso@mit.edu> <1399295044-24489-2-git-send-email-tytso@mit.edu> <alpine.LFD.2.00.1405051541080.2223@localhost.localdomain> <20140505140401.GD22287@thunk.org> <20140505142808.GF22287@thunk.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1048189599-1399300720=:2223"
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, kzak@redhat.com,
	linux-fsdevel@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20140505142808.GF22287@thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1048189599-1399300720=:2223
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

On Mon, 5 May 2014, Theodore Ts'o wrote:

> Date: Mon, 5 May 2014 10:28:08 -0400
> From: Theodore Ts'o <tytso@mit.edu>
> To: Luká¨ Czerner <lczerner@redhat.com>
> Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
> Subject: Re: [PATCH 2/3] mke2fs: print extra information about existing
>     ext2/3/4 file systems
> 
> On Mon, May 05, 2014 at 10:04:01AM -0400, Theodore Ts'o wrote:
> > The basic idea behinid these patches is that we now get a bit more
> > context with the warning message for ext2/3/4 file systems:
> > 
> > % ./misc/mke2fs -t ext4 /dev/heap/media
> > mke2fs 1.42.9 (4-Feb-2014)
> > /dev/heap/media contains a ext4 file system labelled 'media'
> > 		  last mounted on /media on Mon May  5 08:59:53 2014
> > Proceed anyway? (y,n) 
> 
> And actually, the place where this context is critically important is
> in this case (where let's say, the user typo's sdc3 when they meant to
> type sdd3):
> 
> % ./misc/mke2fs -t ext4 /dev/sdc3
> mke2fs 1.42.9 (4-Feb-2014)
> /dev/sdc3 contains a ext4 file system
> 	last mounted on /SOX-backups on Mon May  5 08:59:53 2014
> Proceed anyway? (y,n) 
> 
> ... where this becomes a last-ditch saving through against the
> accidental wiping of the enterprise's Sarbanes-Oxley records.  :-)
> 
> 						- Ted

Yep, it's really useful. I just was not sure what is this all about since
there was not description and I was missing context from the other patches.

But this makes me think that it would be very useful if blkid could
gather this information for other file system if possible :). This
might be very useful if we can get some overlap with other file
system with the information provided in superblock.

Karel, what do you think ?

-Lukas
--8323328-1048189599-1399300720=:2223--
