From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: delalloc fragmenting files?
Date: Mon, 05 Nov 2007 12:54:34 -0600
Message-ID: <472F66EA.9080908@redhat.com>
References: <47225B1E.2060708@redhat.com> <20071026221938.GV3042@webber.adilger.int> <4728ED3B.1060407@redhat.com> <47291F62.3000008@gmail.com> <4729EEB2.9090406@redhat.com> <472A2384.2010001@redhat.com> <472AE644.1040102@gmail.com> <472B453F.8010608@redhat.com> <472E1114.7060206@gmail.com> <472F54EE.9030904@redhat.com> <20071105185133.GA3900@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Eric Sandeen <sandeen@redhat.com>,
	Alex Tomas <bzzz.tomas@gmail.com>,
	ext4 development <linux-ext4@vger.kernel.org>,
	Kalpak Shah <Kalpak.Shah@Sun.COM>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:40747 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753263AbXKESyk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Nov 2007 13:54:40 -0500
In-Reply-To: <20071105185133.GA3900@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Andreas Dilger wrote:

> On a related note - the FIEMAP patches to filefrag also include a new
> output format that is much more useful, IMHO.  The new format is like:
> 
> {filename}
> ext: [logical start.. end kB]: phys start..end kB    :           kB:lun: flags
>   0: [         0..     30207]:     401416..    522251:       120828: 0 :
>   1: [     30208..     60927]:     532480..    655359:       122880: 0 :
>   2: [     60928..    121855]:     790536..    916484:       125948: 0 :
> 
> Hopefully Kalpak will be able to post the updated patches here soon.

yep, I hacked existing filefrag to do something like this, the existing
format is pretty hard to glance over :)

One thing I like about xfs_bmap is that it can tell you which Allocation
Group the blocks are in; most filesystems have some concept of
sub-regions of the filesystem, such as BGs or resource groups or whatnot
- do you think there is room for this in the FIEMAP interface?  Hm, or
should this just be calculated from knowing the size of the sub-regions...

-Eric
