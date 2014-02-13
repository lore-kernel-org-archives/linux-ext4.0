From: Jon Bernard <jbernard@tuxion.com>
Subject: Re: kernel bug at fs/ext4/resize.c:409
Date: Thu, 13 Feb 2014 09:53:23 -0500
Message-ID: <20140213145323.GA6296@helmut>
References: <20140203182634.GA28811@shaniqua>
 <20140203185633.GA22856@thunk.org>
 <20140206210844.GA4335@helmut>
 <87sirnp2m3.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:36323 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751403AbaBMOx1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Feb 2014 09:53:27 -0500
Received: from compute5.internal (compute5.nyi.mail.srv.osa [10.202.2.45])
	by gateway1.nyi.mail.srv.osa (Postfix) with ESMTP id 9643F20C6F
	for <linux-ext4@vger.kernel.org>; Thu, 13 Feb 2014 09:53:26 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <87sirnp2m3.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* Dmitry Monakhov <dmonakhov@openvz.org> wrote:
> On Thu, 6 Feb 2014 16:08:44 -0500, Jon Bernard <jbernard@tuxion.com> wrote:
> Non-text part: multipart/mixed
> > * Theodore Ts'o <tytso@mit.edu> wrote:
> > > On Mon, Feb 03, 2014 at 01:26:34PM -0500, Jon Bernard wrote:
> > > > Hello all,
> > > > 
> > > > A coworker is seeing the following bug when attempting to resize a root
> > > > volume (during init by calling resizefs) from 1GB to the size of the
> > > > underlying partition size of 20GB.
> > > > 
> > > > If the partition size is changed (to i.e. 10GB), the bug seems to not
> > > > trigger.  I have access to this machine, if there are any experiments
> > > > that would provide more useful information - please let me know.
> > > 
> > > Here are three questions to start:
> > > 
> > > 1)  What kernel version was this oops coming from?
> > 
> > 3.12.9-301.fc20.x86_64
> > 
> > > 2)  Could you please send me the output of dumpe2fs of the file system?
> > 
> > Dump attached.
> > 
> > > 3)  Can you reproduce the problem?
> > 
> > It happens every time with this particular filesystem image.  A new
> > image built with slightly different variables (size, contents, etc)
> > usually yields a filesystem that behaves correctly.  But once they have
> > a bad one, it breaks on resize every time.
> > 
> > Let me know if I can provide any other information.  I have access to
> > the machine for some time, so I can run a modified kernel or module and
> > post results if that would help.
> > 
> > Thanks,
> > 
> Yepp..  same BUGON was recently triggered by one of our customers
> on ovzkernel kernel which is based on RHEL6's (2.6.32) kernel:
> Resize the image /vz/private/2345.private_temporary-XXXX/root.hdd to
> 536870912K
> resize2fs 1.42.3 (14-May-2012)
> Filesystem at /dev/ploop15153p1 is mounted on
> /vz/private/2345.private_temporary-XXXX/root.hdd/root.hds.mnt; on-line
> resizing required
> old_desc_blocks = 1, new_desc_blocks = 32
> <4>[ 1043.647040] ------------[ cut here ]------------
> <2>[ 1043.647067] kernel BUG at fs/ext4/resize.c:375!
> 
> But after that image was destroyed, and we can not reproduce this bug at
> the moment.
> 
> Can you please share image created via e2image and blkimage size:
> #e2image -r /dev/$YOUR_DEV - | bzip2 > img.e2i.bz2
> #blockdev --getsz /dev/$YOUR_DEV
> and resize2fs arguments.

The image should be available here:

http://c5a6e06e970802d5126f-8c6b900f6923cc24b844c506080778ec.r72.cf1.rackcdn.com/fedora_resize_fails.qcow2

The md5sum is: 267fd37e3a5e1c4d50bd133dd2835c98

-- 
Jon
