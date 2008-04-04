From: Paul Slootman <paul@wurtel.net>
Subject: Re: #blocks per group too big: 37265
Date: Fri, 4 Apr 2008 14:56:29 +0200
Message-ID: <20080404125629.GA28519@msgid.wurtel.net>
References: <20080403161904.GA31670@msgid.wurtel.net> <20080404092120.GA28403@msgid.wurtel.net> <20080404120808.GA29297@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lw.wurtel.net ([82.192.92.211]:3600 "EHLO lw.wurtel.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760065AbYDDM4d (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 4 Apr 2008 08:56:33 -0400
Received: from wurtel.local ([192.168.1.1]:50577 helo=wurtel-ws.wurtel.net)
	by mx.wurtel.net with esmtps (TLS-1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.63)
	(envelope-from <paul@wurtel.net>)
	id 1JhlT6-0004Bg-Bn
	for linux-ext4@vger.kernel.org; Fri, 04 Apr 2008 14:56:32 +0200
Received: from paul by wurtel-ws.wurtel.net with local (Exim 4.69)
	(envelope-from <paul@wurtel-ws.wurtel.net>)
	id 1JhlT3-0007jI-Nf
	for linux-ext4@vger.kernel.org; Fri, 04 Apr 2008 14:56:29 +0200
Content-Disposition: inline
In-Reply-To: <20080404120808.GA29297@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 04 Apr 2008, Theodore Tso wrote:
> On Fri, Apr 04, 2008 at 11:21:20AM +0200, Paul Slootman wrote:
> > I still end up with a "blocks per group" of 37265, and when mounted I'm
> > greeted with the message "EXT4-fs: #blocks per group too big: 37265".
> > Is the ext4 code in the 2.6.25-rc8 kernel too old? According to the
> > source the number of block per group must be <= 8 * blocksize; with 4k
> > blocks that would mean 32768, not 37265.
> > 
> > Even passing the -g option to explicitly set the blocks per group gets
> > ignored.
> 
> I didn't notice it initially, but it looks like you're using a 1.38
> mke2fs program and 1.39-tyt3 libraries.  I'm guessing that was

I downloaded e2fsprogs-64bit-x86_64.tar.bz2 from somewhere
(unfortunately I can't recall from where, but it was some link from a
page about ext4) and used the mkfs.ext3 from there, which ldd tells me
is statically linked. Apparently that version is too old.

> I was referring to e2fsprogs.  The latest version is available in the
> git repository, at:
> 
>     git://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git
>     http://git.kernel.org/?p=fs/ext2/e2fsprogs.git;a=summary

Thanks for your help, I'll get that version and try again :-)

> that's where to find it.  (Please think very carefully before doing
> anything with production data, though!  We try to be very careful, but
> it's your data on the line at the end of the day.  :-)

This is on a system that provides 2nd stage backup (long term storage).
As I've just replaced the old 400G disks with 1TB disks, all the old
data is gone anyway, so any crashes or whatever won't immediataly lead
to problems :-)


Paul Slootman
