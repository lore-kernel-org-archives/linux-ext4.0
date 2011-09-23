From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] Add better example about how to compress e2image raw
 image
Date: Fri, 23 Sep 2011 17:51:24 -0300
Message-ID: <20110923205124.GD26962@andromeda.usersys.redhat.com>
References: <1316803672-25550-1-git-send-email-cmaiolino@redhat.com>
 <BAB1C1C4-D0BB-4398-89A5-EC8B1E20801B@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59712 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752244Ab1IWUwa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 23 Sep 2011 16:52:30 -0400
Content-Disposition: inline
In-Reply-To: <BAB1C1C4-D0BB-4398-89A5-EC8B1E20801B@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 23, 2011 at 02:24:23PM -0600, Andreas Dilger wrote:
> On 2011-09-23, at 12:47 PM, Carlos Maiolino wrote:
> > The current example in the man page uses bzip2 to compress
> > the raw image file created by the e2image, but, bzip2 does
> > not honors sparse files, which causes the image to have the
> > same size of the filesystem.
> > Using tar together with bzip2 will make the compressed file
> > to honor the sparsed file, which makes it more transportable
> > than the current one if the filesystem is large.
> > 
> > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > ---
> > misc/e2image.8.in |    2 +-
> > 1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/misc/e2image.8.in b/misc/e2image.8.in
> > index 74d2a0b..fcf3d20 100644
> > --- a/misc/e2image.8.in
> > +++ b/misc/e2image.8.in
> > @@ -115,7 +115,7 @@ as part of bug reports to e2fsprogs.  When used in this capacity, the
> > recommended command is as follows (replace hda1 with the appropriate device):
> > .PP
> > .br
> > -\	\fBe2image \-r /dev/hda1 \- | bzip2 > hda1.e2i.bz2\fR
> > +\	\fBe2image \-r /dev/hda1 hda1.e2i && tar Sjcvf e2i.tar.bz2 hda1.e2i\fR
> 
> Even better would be the use of the QCOW2 format that Lukas added, if it could also be operated on directly by the e2fsprogs utils (I don't know if that is possible or not).
> 
The QCOW2 format can only be operated with qcow2 capable tools like qemu-img =[ to use directly with e2fsprogs tools, we still need to use raw images.

-- 
--Carlos
