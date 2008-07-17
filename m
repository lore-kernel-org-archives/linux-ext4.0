From: Josef Bacik <jbacik@redhat.com>
Subject: Re: ext3 on latest -git: BUG: unable to handle kernel NULL pointer
	dereference at 0000000c
Date: Thu, 17 Jul 2008 10:16:55 -0400
Message-ID: <20080717141655.GD14133@unused.rdu.redhat.com>
References: <19f34abd0807170551q4fbb862bu270297cfd76a69be@mail.gmail.com> <1b7401870807170613y747baa7by158177047cc7e28@mail.gmail.com> <19f34abd0807170620g39ab942bl592ea3fa3fa0dab@mail.gmail.com> <1b7401870807170634u14492a53k3931ddcddbd1e098@mail.gmail.com> <19f34abd0807170639p838d14blc9a13d2104313f38@mail.gmail.com> <20080717135746.GB14133@unused.rdu.redhat.com> <19f34abd0807170725p13e81e3dq4daad32ad2a83931@mail.gmail.com> <20080717141333.GC14133@unused.rdu.redhat.com> <19f34abd0807170735p5d2cba31kec3fb65c5b8c7b3f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <jbacik@redhat.com>,
	Josef Bacik <josef@toxicpanda.com>, linux-ext4@vger.kernel.org,
	sct@redhat.com, akpm@linux-foundation.org, adilger@sun.com,
	Johannes Weiner <hannes@saeurebad.de>,
	linux-kernel@vger.kernel.org
To: Vegard Nossum <vegard.nossum@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:39283 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758843AbYGQOgr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 17 Jul 2008 10:36:47 -0400
Content-Disposition: inline
In-Reply-To: <19f34abd0807170735p5d2cba31kec3fb65c5b8c7b3f@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 17, 2008 at 04:35:16PM +0200, Vegard Nossum wrote:
> On Thu, Jul 17, 2008 at 4:13 PM, Josef Bacik <jbacik@redhat.com> wrote:
> > On Thu, Jul 17, 2008 at 04:25:49PM +0200, Vegard Nossum wrote:
> >> On Thu, Jul 17, 2008 at 3:57 PM, Josef Bacik <jbacik@redhat.com> wrote:
> >> > Can you try this patch out and see if it fixes the problem?  I didn't compile
> >> > test it, so you may need to tweak somethings, but it should work.  Thanks,
> >> >
> >> > Signed-off-by: Josef Bacik <jbacik@redhat.com>
> >>
> >> Nope, seems to be the same problem:
> >>
> >> kjournald starting.  Commit interval 5 seconds
> >> EXT3-fs warning: mounting fs with errors, running e2fsck is recommended
> >> EXT3 FS on loop0, internal journal
> >> EXT3-fs: mounted filesystem with ordered data mode.
> >> EXT3-fs error (device loop0): ext3_free_blocks: Freeing blocks in
> >> system zones - Block = 16, count = 1
> >> EXT3-fs error (device loop0): ext3_free_blocks: Freeing blocks in
> >> system zones - Block = 32, count = 1
> >> EXT3-fs error (device loop0): ext3_free_blocks: Freeing blocks not in
> >> datazone - block = 262144, count = 1
> >> BUG: unable to handle kernel NULL pointer dereference at 0000000c
> >> IP: [<c01fd210>] journal_dirty_metadata+0xa0/0x160
> >>
> >> Full log at http://folk.uio.no/vegardno/linux/log-1216304953.txt
> >>
> >>
> >
> > Ok, this should do it then.  Thanks,
> 
> Hm, it doesn't apply. Should I revert the previous patch?
>

Yeah sorry about that.

Josef 
