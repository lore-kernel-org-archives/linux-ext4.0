From: Andy Whitcroft <apw@canonical.com>
Subject: Re: Bug with "fix partial page writes" [3.2-rc regression]
Date: Fri, 9 Dec 2011 13:33:44 +0000
Message-ID: <20111209133343.GA434@shadowen.org>
References: <alpine.LSU.2.00.1111211331120.1879@sister.anvils>
 <alpine.LSU.2.00.1112051456580.3938@sister.anvils>
 <4EDD729E.2060402@linux.vnet.ibm.com>
 <alpine.LSU.2.00.1112060030220.1615@sister.anvils>
 <4EDE85F4.4020503@linux.vnet.ibm.com>
 <CAGBYx2YmYRw_p5KHJCYaQNsCpe5OVV7X2TpaK=OE7znCiE7oZA@mail.gmail.com>
 <4EDF9CAB.3050502@linux.vnet.ibm.com>
 <4EE046C7.9030902@linux.vnet.ibm.com>
 <alpine.LSU.2.00.1112080909300.22300@sister.anvils>
 <20111208181235.GE2686@shadowen.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Allison Henderson <achender@linux.vnet.ibm.com>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Ted Ts'o <tytso@mit.edu>, Curt Wohlgemuth <curtw@google.com>,
	Surbhi Palande <csurbhi@gmail.com>,
	Rafael Wysocki <rjw@sisk.pl>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Hugh Dickins <hughd@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:56337 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263Ab1LINds (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Dec 2011 08:33:48 -0500
Content-Disposition: inline
In-Reply-To: <20111208181235.GE2686@shadowen.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 08, 2011 at 06:12:35PM +0000, Andy Whitcroft wrote:
> On Thu, Dec 08, 2011 at 09:39:55AM -0800, Hugh Dickins wrote:
> 
> [...]
> > > [PATCH 1/2] ext4: let mpage_submit_io works well when blocksize < pagesize
> > > [PATCH 2/2] ext4: let ext4_discard_partial_buffers handle pages without
> > > 
> > > [PATCH 1/2] ext4: remove a wrong BUG_ON in ext4_ext_convert_to_initialized
> > > [PATCH 2/2] ext4: let ext4_bio_write_page handle EOF correctly
> [...]
> > Only once, before the fixes, did I ever see an unexplained EINVAL
> > (from cp), like Andy reports: I'm very hopeful his case is fixed too.
> 
> Yes I have reverted my fix and applied all four of these patches (above).
> I have just completed a 100 iteration run of my test case without failure.
> This would typically fail in the first iteration 90% of the time and
> never survived more than two iterations.
> 
> I am comfortable saying they resolve my issue.

Are we likely to see these fixes in a 3.2-rcN or will they be going to
stable?

-apw
