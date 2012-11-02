From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: ext4: fix metadata checksum calculation for the superblock
Date: Thu, 1 Nov 2012 17:05:58 -0700
Message-ID: <20121102000558.GH19576@blackbox.djwong.org>
References: <20121101071818.GG19576@blackbox.djwong.org>
 <20121101072847.25732.qmail@science.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tm@tao.ma, tytso@mit.edu
To: George Spelvin <linux@horizon.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:48001 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757681Ab2KBAGI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Nov 2012 20:06:08 -0400
Content-Disposition: inline
In-Reply-To: <20121101072847.25732.qmail@science.horizon.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 01, 2012 at 03:28:47AM -0400, George Spelvin wrote:
> > Oh, so ... it's just nfsd that causes the linear fallback?  Regular (i.e.
> > non-nfs) users can see everything in the dir, no error messages?
> 
> Yup.  After it survived one e2fsck -D, I poked at the directory a bit
> to see if I could cause the error.  No success from local access.
> 
> It's also probably an NFSv2 client.  I wonder if it's doing something
> odd with directory seeks that's causing problems; perhaps htree and the
> 32-bit seek cookie limit are not friends?

<shrug> I'm not nfs-wise, sadly.  I _am_ wondering if an ftrace of this might
be useful... or a gigantic glut of data that I'll never finish processing.

Just from a quick read of ext4_find_entry() it looks like the only thing that
results in fallback mode without a kernel message is ext4_bread() failing in
dx_probe()?

> >> I haven't observed it, no.  But the nature of the symptoms suggests it
> >> might be happening.
> 
> > Hum.  When linear scan happens on a hashed dir, it's scanning the same
> > blocks that the hash scan sees.   The htree block looks like a regular
> > directory block with one huge "unused" dirent that wraps all the htree
> > data.  So, the linear scan should find the exact same files as a htree
> > scan would.  If it doesn't, something's wrong.  But you say it isn't,
> > so I imagine it's fine.
> 
> Maybe I was wrong.  I was worried that it was aborting the directory
> scan due to the error and thus files would disappear.  If that doesn't
> happen, no worries.

Oh well, it'll run slowly but at least it won't be throwing up errors.

--D
