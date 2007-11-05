From: Andreas Dilger <adilger@sun.com>
Subject: Re: delalloc fragmenting files?
Date: Tue, 6 Nov 2007 02:51:33 +0800
Message-ID: <20071105185133.GA3900@webber.adilger.int>
References: <47225B1E.2060708@redhat.com> <20071026221938.GV3042@webber.adilger.int> <4728ED3B.1060407@redhat.com> <47291F62.3000008@gmail.com> <4729EEB2.9090406@redhat.com> <472A2384.2010001@redhat.com> <472AE644.1040102@gmail.com> <472B453F.8010608@redhat.com> <472E1114.7060206@gmail.com> <472F54EE.9030904@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alex Tomas <bzzz.tomas@gmail.com>,
	ext4 development <linux-ext4@vger.kernel.org>,
	Kalpak Shah <Kalpak.Shah@Sun.COM>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:41271 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbXKESvm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 5 Nov 2007 13:51:42 -0500
Content-Disposition: inline
In-Reply-To: <472F54EE.9030904@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Nov 05, 2007  11:37 -0600, Eric Sandeen wrote:
> Alex Tomas wrote:
> > thanks for the data. the attached patch should fix couple issues:
> > broken history output and policy in that smaller usable chunk to
> > be used. can you give it a spin, please?
> 
> This looks *much* better:
> 
> First block: 100355
> Last block: 2342657
> Discontinuity: Block 30208 is at 133120 (was 130562)
> Discontinuity: Block 60928 is at 165891 (was 163839)
> Discontinuity: Block 90368 is at 197634 (was 195330)
> Discontinuity: Block 121856 is at 232448 (was 229121)
> Discontinuity: Block 150528 is at 263170 (was 261119)
> Discontinuity: Block 181504 is at 296963 (was 294145)
> Discontinuity: Block 210944 is at 328706 (was 326402)
> Discontinuity: Block 241664 is at 361474 (was 359425)
> Discontinuity: Block 272896 is at 395264 (was 392705)
> Discontinuity: Block 303360 is at 427010 (was 425727)
> Discontinuity: Block 334080 is at 459778 (was 457729)
> Discontinuity: Block 365568 is at 493568 (was 491265)
> Discontinuity: Block 395264 is at 525314 (was 523263)
> Discontinuity: Block 426240 is at 558082 (was 556289)
> ....

On a related note - the FIEMAP patches to filefrag also include a new
output format that is much more useful, IMHO.  The new format is like:

{filename}
ext: [logical start.. end kB]: phys start..end kB    :           kB:lun: flags
  0: [         0..     30207]:     401416..    522251:       120828: 0 :
  1: [     30208..     60927]:     532480..    655359:       122880: 0 :
  2: [     60928..    121855]:     790536..    916484:       125948: 0 :

Hopefully Kalpak will be able to post the updated patches here soon.

Cheers, Andreas
--
Andreas Dilger
Sr. Software Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
