From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/3] mke2fs: print extra information about existing
 ext2/3/4 file systems
Date: Mon, 5 May 2014 10:28:08 -0400
Message-ID: <20140505142808.GF22287@thunk.org>
References: <1399295044-24489-1-git-send-email-tytso@mit.edu>
 <1399295044-24489-2-git-send-email-tytso@mit.edu>
 <alpine.LFD.2.00.1405051541080.2223@localhost.localdomain>
 <20140505140401.GD22287@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49854 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932713AbaEEO2L (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 May 2014 10:28:11 -0400
Content-Disposition: inline
In-Reply-To: <20140505140401.GD22287@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 05, 2014 at 10:04:01AM -0400, Theodore Ts'o wrote:
> The basic idea behinid these patches is that we now get a bit more
> context with the warning message for ext2/3/4 file systems:
> 
> % ./misc/mke2fs -t ext4 /dev/heap/media
> mke2fs 1.42.9 (4-Feb-2014)
> /dev/heap/media contains a ext4 file system labelled 'media'
> 		  last mounted on /media on Mon May  5 08:59:53 2014
> Proceed anyway? (y,n) 

And actually, the place where this context is critically important is
in this case (where let's say, the user typo's sdc3 when they meant to
type sdd3):

% ./misc/mke2fs -t ext4 /dev/sdc3
mke2fs 1.42.9 (4-Feb-2014)
/dev/sdc3 contains a ext4 file system
	last mounted on /SOX-backups on Mon May  5 08:59:53 2014
Proceed anyway? (y,n) 

... where this becomes a last-ditch saving through against the
accidental wiping of the enterprise's Sarbanes-Oxley records.  :-)

						- Ted
