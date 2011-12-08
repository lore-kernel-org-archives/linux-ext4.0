From: Hugh Dickins <hughd@google.com>
Subject: Re: Bug with "fix partial page writes" [3.2-rc regression]
Date: Thu, 8 Dec 2011 09:39:55 -0800 (PST)
Message-ID: <alpine.LSU.2.00.1112080909300.22300@sister.anvils>
References: <CAO81RMa4uRsOsaK4G78EDvOenJpEdTp4y+rtkiDxaK9cASbMtA@mail.gmail.com> <alpine.LSU.2.00.1111201121120.1264@sister.anvils> <20111121165626.GD14568@thunk.org> <alpine.LSU.2.00.1111211331120.1879@sister.anvils> <alpine.LSU.2.00.1112051456580.3938@sister.anvils>
 <4EDD729E.2060402@linux.vnet.ibm.com> <alpine.LSU.2.00.1112060030220.1615@sister.anvils> <4EDE85F4.4020503@linux.vnet.ibm.com> <CAGBYx2YmYRw_p5KHJCYaQNsCpe5OVV7X2TpaK=OE7znCiE7oZA@mail.gmail.com> <4EDF9CAB.3050502@linux.vnet.ibm.com>
 <4EE046C7.9030902@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Yongqiang Yang <xiaoqiangnk@gmail.com>, Ted Ts'o <tytso@mit.edu>,
	Curt Wohlgemuth <curtw@google.com>,
	Surbhi Palande <csurbhi@gmail.com>,
	Rafael Wysocki <rjw@sisk.pl>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:55788 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567Ab1LHRk2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 8 Dec 2011 12:40:28 -0500
Received: by qcqz2 with SMTP id z2so1506585qcq.19
        for <linux-ext4@vger.kernel.org>; Thu, 08 Dec 2011 09:40:28 -0800 (PST)
In-Reply-To: <4EE046C7.9030902@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 7 Dec 2011, Allison Henderson wrote:
> On 12/07/2011 10:04 AM, Allison Henderson wrote:
> > On 12/07/2011 01:28 AM, Yongqiang Yang wrote:
> > > Hi Allison and Hugh,
> > > 
> > > I think I found the problem and it has nothing to do with punching
> > > hole. The patch [ext4: let ext4_bio_write_page handle EOF correctly]
> > > would fix up the problem.
> > > 
> > > I post the patch so that it can be tested as early as possible. The
> > > problem has not appeared on my machine since the patch is applied.
> > > 
> > > Yongqiang.
> > 
> > Great! I will try it out with your other set in my sandbox and let you
> > know what happens. Thx!
> > 
> > Allison Henderson
> 
> Well, it's been running several hours now with out problems, so I think it
> will be ok, but I will let it run the full day.
> 
> Andy, I know you were also seeing issues in this area.  Could you try
> Yongqiang patches?  The code you were modifying needed to be removed, so I
> think they will resolve the issues you were seeing too.  Please try the
> following patch sets:
> 
> [PATCH 1/2] ext4: let mpage_submit_io works well when blocksize < pagesize
> [PATCH 2/2] ext4: let ext4_discard_partial_buffers handle pages without
> buffers correctly
> 
> and
> 
> [PATCH 1/2] ext4: remove a wrong BUG_ON in ext4_ext_convert_to_initialized
> [PATCH 2/2] ext4: let ext4_bio_write_page handle EOF correctly

Those patches are working well for me, many thanks to Yongqiang.

The last (or more of them?) fix behaviour going back several
releases, and ought to be sent to -stable after verification.

I ran fsx (args as before on 1024k block ext2fs under memory pressure)
for 8 hours on three machines, and no problem showed up on any.
I didn't have time to try ext4, but I expect that you did.

And I've run kernel builds under memory pressure for 7.5 hours,
no problem has showed up there either - although that's not long
enough yet to validate the oops fix by itself, we've earlier run
long enough with the first 2/2 to be sure that it fixes the oops,
and the "corruption" that I saw.

Quotes around corruption now because, from Yongqiang's description,
I'm guessing that ld was mmap'ing objfiles and acting on "data"
from beyond eof.  Which ld does have the right to do, it should
indeed be zeroed.

Only once, before the fixes, did I ever see an unexplained EINVAL
(from cp), like Andy reports: I'm very hopeful his case is fixed too.

Thanks!
Hugh
