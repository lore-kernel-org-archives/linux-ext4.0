From: Andreas Dilger <adilger@sun.com>
Subject: Re: ext3 on latest -git: BUG: unable to handle kernel NULL pointer
	dereference at 0000000c
Date: Thu, 17 Jul 2008 17:06:58 -0600
Message-ID: <20080717230658.GH6239@webber.adilger.int>
References: <19f34abd0807170639p838d14blc9a13d2104313f38@mail.gmail.com>
 <20080717135746.GB14133@unused.rdu.redhat.com>
 <19f34abd0807170725p13e81e3dq4daad32ad2a83931@mail.gmail.com>
 <20080717141333.GC14133@unused.rdu.redhat.com>
 <19f34abd0807170735p5d2cba31kec3fb65c5b8c7b3f@mail.gmail.com>
 <20080717141655.GD14133@unused.rdu.redhat.com>
 <19f34abd0807170744r79e46a78odfcfbd67687d2ceb@mail.gmail.com>
 <20080717150812.GU2167@mit.edu>
 <19f34abd0807170816p4788a352qc35b42fd7647d00f@mail.gmail.com>
 <20080717154051.GW2167@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
To: Theodore Tso <tytso@mit.edu>,
	Vegard Nossum <vegard.nossum@gmail.com>,
	Josef Bacik <jbacik@redhat.com>,
	Josef Bacik <josef@toxicpanda.com>, linux-ext4@vger.kernel.org,
	sct@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:42704 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758183AbYGQXHD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Jul 2008 19:07:03 -0400
In-reply-to: <20080717154051.GW2167@mit.edu>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jul 17, 2008  11:40 -0400, Theodore Ts'o wrote:
> On Thu, Jul 17, 2008 at 05:16:39PM +0200, Vegard Nossum wrote:
> > Is there a way to override the
> > 
> >     "Errors behavior:          Continue"
> > 
> > information which is present in the filesystem?
> 
> tune2fs -e remount-ro /dev/XXXX
> 
> I should probably make the default configurable, and not "continue"....

Yes, it has been that way on Debian for many years...  I was going to
say the same thing, but you beat me to it.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

