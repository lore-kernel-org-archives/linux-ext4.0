From: Karel Zak <kzak@redhat.com>
Subject: Re: [PATCH] blkid: use /dev/mapper/<name> rather than /dev/dm-<N>
Date: Tue, 5 May 2009 21:54:23 +0200
Message-ID: <20090505195423.GB4460@nb.net.home>
References: <1240837258-5440-1-git-send-email-kzak@redhat.com> <20090503020528.GA25826@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:43137 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752346AbZEETy1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 5 May 2009 15:54:27 -0400
Content-Disposition: inline
In-Reply-To: <20090503020528.GA25826@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, May 02, 2009 at 10:05:28PM -0400, Theodore Tso wrote:
> On Mon, Apr 27, 2009 at 03:00:57PM +0200, Karel Zak wrote:
> > The libblkid (since v1.41.1) returns private device-mapper names (e.g.
> > /dev/dm-0). It's because the probe_one() function scans /dev before
> > /dev/mapper.
> 
> Checked in, thanks.  Debian-derived distributions don't create
> /dev/dm-X names, which is why I didn't notice this issue.  However,
> because of this, I modified your patch to keep this chunk which you removed:

 You needn't this chunk.

> > -	/* Do a short-cut scan of /dev/mapper first */
> > -	if (!devname)
> > -		blkid__scan_dir("/dev/mapper", devno, 0, &devname);
> 
> For distributions that don't create /dev/dm-X devices, your check

 I guess that all distributions have "dm-X" names in /proc/partitions, it
 means my check

   if (!strncmp(ptname, "dm-", 3) && isdigit(ptname[3]))
       blkid__scan_dir("/dev/mapper", devno, 0, &devname);

 works everywhere and you needn't to check /dev before /dev/mapper for 
 dm-X ptnames.

> above won't find the device name, so after searching /dev, we need to
> do a short-cut scan of /dev/mapper before we do a full brute force
> search via blkid_devno_to_devname.

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
