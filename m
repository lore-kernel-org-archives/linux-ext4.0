From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: poor performance of mount due to libblkid
Date: Wed, 9 May 2007 17:30:05 -0700
Message-ID: <20070510003005.GV6375@schatzie.adilger.int>
References: <20070509170646.C12805@cbr.shaptech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Shapor Naghibzadeh <shapor@shapor.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:37408 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755452AbXEJAaH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 May 2007 20:30:07 -0400
Content-Disposition: inline
In-Reply-To: <20070509170646.C12805@cbr.shaptech.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On May 09, 2007  17:06 -0500, Shapor Naghibzadeh wrote:
> There is a serious performance degradation with the mount command after
> mounting many unique devices when compiled with libblkid support.  A simple
> "mount" command to display the list of mounted filesystem can take minutes to
> run.  This is due to a call to libblkid's blkid_get_cache and a
> relatively large /etc/blkid.tab (tens of thousands of lines, a few megs in
> size).
>
> The file is able to grow to a large size because it does not know that device
> mapper devices have been removed and will never be created again.

Is there something unusual about your system or startup scripts that is
causing so many entries in /etc/blkid.tab file?

> libblkid api nor blkid command line appear to even provide a facility for
> removing entries if you wanted to do so manually on device removal.

Using "blkid -c /dev/null" skips the cache load, but I also see it doesn't
write out a new /etc/blkid.tab file.

> Combined with no (reasonable) bound on the size of the blkid.tab file, this
> causes the mount command to get slower over time.  To make matters worse, the
> cost of reading the file in to memory is n-squared (which happens every time
> the mount command is run, even with "-h" for help!).

I hadn't looked at that previously (it's been a long time since I looked
at the blkid code), and I also don't have the mount code handy.  Can you
be more specific? 

> 1) mount has libblkid support hacked in sloppily.  It shouldn't attempt to
> read the blkid.tab unless it is trying to guess the filesystem type.  Even if
> it is, what is the point?  Is reading blkid.tab and parsing xml really an
> optimization over reading the superblock (which we are about to do when we
> mount the filesystem) and determining the fs type?

The reason for libblkid is twofold:
- centralize the detection of filesystem types into one library
- allow userspace applications to find device content type without needing
  root or read access to the device (hence reason for /etc/blkid.tab)


> It doesn't even seem to
> help the normal case, and really hurts the worst case badly.  If mount is to
> use the file, it should scan through it only in the case it is actually
> trying to detect the filesystem type, and stop when it finds the entry.

That makes a lot of sense, but that should be sent to the mount(8) maintainer.

> 2) The in-memory data structure of the blkid cache was not designed with scale
> in mind.  It should not have to scan the entire list locate a device,
> which happens on every insert when reading it.
> 
> 3) The use of XML in /etc is not very unixy.  It is difficult for both
> computers and humans to parse.

Yeah, but when I wrote it that was what people told me to use.  I guess the
late 90's was the time when XML was cool.  I don't think people would complain
too loudly if the blkid code was changed to have a plain-text formatted file,
so long as that was not initially the default, and the XML parsing support was
kept around for a while to allow apps which are statically linked to libblkid
to continue working.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
