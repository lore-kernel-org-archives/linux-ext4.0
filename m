From: Andreas Dilger <adilger@sun.com>
Subject: Re: ext4 64bit (disk >16TB) question
Date: Tue, 15 Jul 2008 14:12:19 -0600
Message-ID: <20080715195116.GL6239@webber.adilger.int>
References: <87bq10w8gv.fsf@frosties.localdomain>
 <20080715132734.68c64000@ichigo>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Goswin von Brederlow <goswin-v-b@web.de>,
	linux-ext4@vger.kernel.org
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:37259 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753548AbYGOUMY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Jul 2008 16:12:24 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m6FKCMXb021280
	for <linux-ext4@vger.kernel.org>; Tue, 15 Jul 2008 13:12:23 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K4200901D9Q0300@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Tue, 15 Jul 2008 13:12:22 -0700 (PDT)
In-reply-to: <20080715132734.68c64000@ichigo>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jul 15, 2008  13:27 -0500, Jose R. Santos wrote:
> On Mon, 14 Jul 2008 21:50:56 +0200
> Goswin von Brederlow <goswin-v-b@web.de> wrote:
> > we are using lustre on a cluster of servers and raid boxes. Currently
> > lustre is based on the ext3 code and has a limit of 8TiB for each
> > filesystem. For us that results on having to split a servers storage
> > into up to 4 chunks and run one fs on each which I would rather avoid.
> > The solution for this would be to rebase the lustre patches to use
> > ext4 instead, which should also reduce the patch set considerably.
> > Lustre already patches a lot of ext4 features into the ext3 base.
> > 
> > 
> > But before I start rebasing lustre I though I would first test out
> > plain ext4 so I know any bugs I find will be from my rebasing and not
> > already existing in ext4 itself. And there I run into a big problem:
> > Current e2fsprogs (1.41) seem to be totaly unable to handle the ext4 64BIT
> > feature, i.e. filesystems larger than 16TiB. The mkfs.ext4 always
> > stops saying the disk exceeds the 32bit block count. And looking at
> > the code I see a lot of blk_t (instead of blk64_t) and unsigned long
> > (instead of unsigned long long [or even better blk64_t]) usage.
> > 
> > I found ext4 64bit patches for e2fsprogs 1.39 that fix at least
> > mkfs. Does anyone know if there is an updated patch set for 1.41
> > anywhere? And when will that be added to e2fsprogs upstream?
> 
> I've recently submitted a set of patches that covers most of the API
> changes needed to support >16TB file systems (missing Ted bitmap
> support of course).  Once the bitmap support is included, it _SHOULD_
> be relatively painless to add mke2fs support with this series of patches.

Jose,
while waiting for the "efficient bitmap" support, how hard would it be
to implement "inefficient bitmaps" that just malloc some GB of memory
if needed?  This would at least allow people with huge devices to test
mke2fs/ext4/e2fsck in the meantime.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

