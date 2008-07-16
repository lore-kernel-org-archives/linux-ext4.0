From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH, RFC] Add more intelligent handling of the mke2fs.conf
	installation process
Date: Wed, 16 Jul 2008 19:08:23 -0400
Message-ID: <20080716230823.GM2167@mit.edu>
References: <E1KITeX-0001PV-Pv@closure.thunk.org> <487BAA6B.7030001@redhat.com> <20080714195526.GA3382@mit.edu> <1216172323.8292.23.camel@mingming-laptop> <20080716023532.GO8185@mit.edu> <1216227720.6424.7.camel@mingming-laptop> <20080716175257.GF2167@mit.edu> <20080716212949.GV6239@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mingming Cao <cmm@us.ibm.com>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:52071 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758354AbYGPXI0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Jul 2008 19:08:26 -0400
Content-Disposition: inline
In-Reply-To: <20080716212949.GV6239@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 16, 2008 at 03:29:49PM -0600, Andreas Dilger wrote:
> On Jul 16, 2008  13:52 -0400, Theodore Ts'o wrote:
> > So if /etc/mk2fs.conf exists, but does not mention ext4dev, we will
> > move it aside to /etc/mke2fs.conf.e2fsprogs-old and then install the
> > new mke2fs.conf.  If the /etc/mke2fs.conf file exists but does mention
> > ext4dev, we install the new mke2fs.conf file as
> > /etc/mke2fs.conf.e2fsprogs-new.  In both we print warning to the user
> > so they can manually make any changes as needed.
> 
> What about just adding the ext4/ext4dev stanzas into the existing file?

There are other changes would be highly recommended beyond just the
ext4 and ext4dev stanzas.  Also, it will be a relatively small set of
people that will be installing e2fsprogs via "make install", so I
decided to keep things simple.

I suppose I could check and see if the md5sum of mke2fs matched the
versions shipped in v1.40 and 1.40.1..1.40.8 and if they matched, to
just overwrite it with the current distributed default (which is what
a package manager effectively does), but I figured it wasn't worth the
trouble.

						- Ted
