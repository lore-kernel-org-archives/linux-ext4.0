From: Jan Kara <jack@suse.cz>
Subject: Re: crash in __jbd2_journal_file_buffer
Date: Fri, 23 Aug 2013 21:52:54 +0200
Message-ID: <20130823195254.GA12980@quack.suse.cz>
References: <20130731190245.GC28018@quack.suse.cz>
 <alpine.DEB.2.00.1308091031450.17790@cobra.newdream.net>
 <20130809212425.GB1050@quack.suse.cz>
 <alpine.DEB.2.00.1308091504320.14125@cobra.newdream.net>
 <20130812125256.GB4596@quack.suse.cz>
 <alpine.DEB.2.00.1308121106320.29150@cobra.newdream.net>
 <20130813103416.GA12197@quack.suse.cz>
 <alpine.DEB.2.00.1308221633080.475@cobra.newdream.net>
 <20130823095405.GA3568@quack.suse.cz>
 <alpine.DEB.2.00.1308230759110.2967@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Sage Weil <sage@inktank.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58266 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754760Ab3HWTwz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 23 Aug 2013 15:52:55 -0400
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1308230759110.2967@cobra.newdream.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 23-08-13 08:02:45, Sage Weil wrote:
> On Fri, 23 Aug 2013, Jan Kara wrote:
> > On Thu 22-08-13 16:35:15, Sage Weil wrote:
> > > On Tue, 13 Aug 2013, Jan Kara wrote:
> > > > On Mon 12-08-13 11:13:06, Sage Weil wrote:
> > > > > Full dmesg is attached.
> > > >   Hum, nothing interesting in there...
> > > > 
> > > > > Our QA seems to hit this with some regularity.  Let me know if there's 
> > > > > some combination of patches that would help shed more light!
> > > >   If they can run with attached debug patch it could maybe sched some more
> > > > light. Please send also your System.map file together with the dmesg of the
> > > > kernel when the crash happens so that I can map addresses to function
> > > > names... Thanks!
> > > 
> > > Okay, finally hit it again:
> > > 
> > > <6>[75193.192249] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro,user_xattr,user_xattr
> > > <3>[77877.426658] Dirtying buffer without jh at 4302720297: state 218c029,jh added from 0xffffffff8127ab1d at 4302720297, removed from 0xffffffff8127b5b0 at 4302720296
> >   Great! Can you please send me /proc/kallsyms from the machine?
> 
> Attached!
  Sadly not. I think your MUA got confused by the fact that files in /proc
have 0 length and attached empty file.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
