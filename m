From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] blkid: use /dev/mapper/<name> rather than /dev/dm-<N>
Date: Sat, 2 May 2009 22:05:28 -0400
Message-ID: <20090503020528.GA25826@mit.edu>
References: <1240837258-5440-1-git-send-email-kzak@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>
To: Karel Zak <kzak@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:58943 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751491AbZECCFf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 2 May 2009 22:05:35 -0400
Content-Disposition: inline
In-Reply-To: <1240837258-5440-1-git-send-email-kzak@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 27, 2009 at 03:00:57PM +0200, Karel Zak wrote:
> The libblkid (since v1.41.1) returns private device-mapper names (e.g.
> /dev/dm-0). It's because the probe_one() function scans /dev before
> /dev/mapper.

Checked in, thanks.  Debian-derived distributions don't create
/dev/dm-X names, which is why I didn't notice this issue.  However,
because of this, I modified your patch to keep this chunk which you removed:

> -	/* Do a short-cut scan of /dev/mapper first */
> -	if (!devname)
> -		blkid__scan_dir("/dev/mapper", devno, 0, &devname);

For distributions that don't create /dev/dm-X devices, your check
above won't find the device name, so after searching /dev, we need to
do a short-cut scan of /dev/mapper before we do a full brute force
search via blkid_devno_to_devname.

							- Ted
