From: Theodore Tso <tytso@mit.edu>
Subject: Re: ext3 on latest -git: BUG: unable to handle kernel NULL pointer
	dereference at 0000000c
Date: Thu, 17 Jul 2008 11:40:51 -0400
Message-ID: <20080717154051.GW2167@mit.edu>
References: <1b7401870807170634u14492a53k3931ddcddbd1e098@mail.gmail.com> <19f34abd0807170639p838d14blc9a13d2104313f38@mail.gmail.com> <20080717135746.GB14133@unused.rdu.redhat.com> <19f34abd0807170725p13e81e3dq4daad32ad2a83931@mail.gmail.com> <20080717141333.GC14133@unused.rdu.redhat.com> <19f34abd0807170735p5d2cba31kec3fb65c5b8c7b3f@mail.gmail.com> <20080717141655.GD14133@unused.rdu.redhat.com> <19f34abd0807170744r79e46a78odfcfbd67687d2ceb@mail.gmail.com> <20080717150812.GU2167@mit.edu> <19f34abd0807170816p4788a352qc35b42fd7647d00f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <jbacik@redhat.com>,
	Josef Bacik <josef@toxicpanda.com>, linux-ext4@vger.kernel.org,
	sct@redhat.com, akpm@linux-foundation.org, adilger@sun.com,
	Johannes Weiner <hannes@saeurebad.de>,
	linux-kernel@vger.kernel.org
To: Vegard Nossum <vegard.nossum@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:34529 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754498AbYGQPlN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Jul 2008 11:41:13 -0400
Content-Disposition: inline
In-Reply-To: <19f34abd0807170816p4788a352qc35b42fd7647d00f@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 17, 2008 at 05:16:39PM +0200, Vegard Nossum wrote:
> Is there a way to override the
> 
>     "Errors behavior:          Continue"
> 
> information which is present in the filesystem?

Yep:

tune2fs -e remount-ro /dev/XXXX

I should probably make the default configurable, and not "continue"....

  	 	       	   	   		     - Ted
