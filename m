From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: Dev branch regressions
Date: Thu, 7 Mar 2013 07:47:31 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1303070746040.24359@localhost>
References: <1362579435-6333-1-git-send-email-wenqing.lz@taobao.com> <20130306225818.GA13277@thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Zheng Liu <gnehzuil.liu@gmail.com>, linux-ext4@vger.kernel.org,
	Zheng Liu <wenqing.lz@taobao.com>,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1040 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752732Ab3CGGrq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 7 Mar 2013 01:47:46 -0500
In-Reply-To: <20130306225818.GA13277@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 6 Mar 2013, Theodore Ts'o wrote:

> Date: Wed, 6 Mar 2013 17:58:18 -0500
> From: Theodore Ts'o <tytso@mit.edu>
> To: Zheng Liu <gnehzuil.liu@gmail.com>
> Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>,
>     Dmitry Monakhov <dmonakhov@openvz.org>
> Subject: Dev branch regressions
> 
> On Wed, Mar 06, 2013 at 10:17:10PM +0800, Zheng Liu wrote:
> > 
> > *Big Note*
> > When I am testing this patch series, I found some regressions in dev branch.
> > Here is a note.  These regressions could be hitted by running test case
> > serveral times.  So If we just run xfstests one time, they could be missed.
> > 
> >  - xfstests #74 with data=journal
> > 
> >  - xfstests #247 with data=journal
> > Some warning messages are printed by ext4_releasepage.  We hit
> > WARN_ON(PageChecked(page)) in this function.  But the test case itself can
> > pass.
> > 
> >  - xfstests #269 with dioread_nolock
> > The system will hang
> 
> I'm going to guess that you were running this using your SSD test
> setup?  I just ran:
> 
> kvm-xfstests -c data_journal 74,74,74,74,74,247,247,247,247,247
> 
> using my standard hdd setup, and didn't see any failures or warnings.
> 
> How frequently are you seeing these failures?  When I have a chance
> I'll try running these tests with a tmpfs image and see if I have any
> better luck reproducing the problem there.
> 
> I did manage to get a hang (preceded with a soft lockup for the
> dioread_nolock with test 269).
> 
> >  - xfstests #83 with bigalloc
> > Some threads could be blocked for 120s.
> 
> I've seen this test blocked for hours (but without managing to trigger
> the 120s soft lockup warning), but I'm not entirely sure this was a
> regression.  I believe I've seen a similar hang with 3.8.0-rc3 if I
> recall correctly.  I had been hoping the changes with the extent
> status tree would fix it, but apparently no such luck.  :-(

You're right this is not a regression the problem has always been
there, however now with some bigalloc fixes it becomes more obvious.
I have some patches to address this issue, though it's not ready
yet.

-Lukas

> 
> > I don't paste full details here to make description clearly.  I will go on
> > tracing these problems.  I am happy to provide full details if some one
> > want to take a close look at these problems.
> 
> If you have a chance, please do send e-mails with each failure
> separated out in a separate e-mail with different subject line so it's
> easier for others to follow along.
> 
> Thanks!!
> 
> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
