From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH v2 0/5] ext4: try to fix up es regressions
Date: Fri, 8 Mar 2013 21:18:41 +0800
Message-ID: <20130308131841.GD18986@gmail.com>
References: <1362579435-6333-1-git-send-email-wenqing.lz@taobao.com>
 <87ppzbgpkg.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>,
	Theodore Ts'o <tytso@mit.edu>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f51.google.com ([209.85.160.51]:55467 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757186Ab3CHNDb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 8 Mar 2013 08:03:31 -0500
Received: by mail-pb0-f51.google.com with SMTP id un15so1176012pbc.10
        for <linux-ext4@vger.kernel.org>; Fri, 08 Mar 2013 05:03:31 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <87ppzbgpkg.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 07, 2013 at 08:08:47PM +0400, Dmitry Monakhov wrote:
> On Wed,  6 Mar 2013 22:17:10 +0800, Zheng Liu <gnehzuil.liu@gmail.com> wrote:
> > Hi all,
> > 
> > The patch series tries to fixup some regressions after applied the extent
> > status tree.  These patches have rebased against the latest dev branch of
> > ext4 and have been tested by xfstests.
> > 
> > After rebased the latest dev branch, two patches have been dropped because
> > they have been applied into the branch.  A new patch is added, which tries
> > to fix up a wrong return value in ext4_split_extent().  Otherwise, there
> > are two major changes in this version.  The first one is to improve the
> > self-testing-infrastructure according to Dmitry's comment.  The second one
> > is to improve the zero out code.
> > 
> > After applied this patch series, I havn't seen the warning messages from
> > self-testing infrastructure except the following cases.
> > 
> >  - xfstests #13 with bigalloc or with no journal
> >  - xfstests #223 with dioread_nolock
> > The reason is that when we lookup a block mapping from status tree
> > i_data_sem locking won't be taken.  So there is a race window that an 
> > unwritten extent could be converted by end_io when we compare the result
> > between extent tree and status tree.
> > 
> > Dmitry, Ted, could you please confirm that this patch series can fix the
> > defrag regression?  Thank you so much.  Until now I run #300 and #301 a
> > lot times but I failed to hit this regression. :-(
> Good work. All my tests now succeed (no error, no warning, no bugons), 

Great!  Thanks for your confirmation.

> BUT 301'th (in terms of git://oss.sgi.com/xfs/cmds/xfstests.git)
> result in massive memory leakage
> about 8gb in an hour
> #while true; do ./check 301  ;done
> I suspect that 'struct ext4_ext_path' is leaked somewhere, I'm not
> even sure that it is new one. 

Thanks for the reminder.  Maybe there still has some bugs in extent
tree.  I will look at it.

Regards,
                                                - Zheng
