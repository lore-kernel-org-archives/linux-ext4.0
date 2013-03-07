From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: Dev branch regressions
Date: Thu, 7 Mar 2013 10:40:50 +0800
Message-ID: <20130307024050.GA4095@gmail.com>
References: <1362579435-6333-1-git-send-email-wenqing.lz@taobao.com>
 <20130306225818.GA13277@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f43.google.com ([209.85.160.43]:40555 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350Ab3CGCZk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 6 Mar 2013 21:25:40 -0500
Received: by mail-pb0-f43.google.com with SMTP id md12so6928408pbc.30
        for <linux-ext4@vger.kernel.org>; Wed, 06 Mar 2013 18:25:40 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20130306225818.GA13277@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 06, 2013 at 05:58:18PM -0500, Theodore Ts'o wrote:
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

Yes, I run these tests in my SSD setup.

> 
> kvm-xfstests -c data_journal 74,74,74,74,74,247,247,247,247,247
> 
> using my standard hdd setup, and didn't see any failures or warnings.

I use the following commands to hit thses warnings.

  for i in {0..9}
  do
    ./chech 74
  done

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
> 
> > I don't paste full details here to make description clearly.  I will go on
> > tracing these problems.  I am happy to provide full details if some one
> > want to take a close look at these problems.
> 
> If you have a chance, please do send e-mails with each failure
> separated out in a separate e-mail with different subject line so it's
> easier for others to follow along.

I will run the test case in 3.8 kernel to understand which one is a
regression, and which one is a bug that has been there for a long time.
Later I will send the report to the mailing list.  Thanks for sharing
the result with me.

Regards,
                                                - Zheng
