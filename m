From: Jan Kara <jack@suse.cz>
Subject: Re: Reporting project quota usage?
Date: Tue, 22 Mar 2016 15:58:46 +0100
Message-ID: <20160322145846.GA25765@quack.suse.cz>
References: <20160316052906.GA23610@thunk.org>
 <CAPTn0cBgrUGG+8iAb=wfUke4g8AWBB3tHV25YFuA5FF05we8Aw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	Andreas Dilger <adilger@dilger.ca>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Li Xi <pkuelelixi@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53627 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758806AbcCVO6V (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 22 Mar 2016 10:58:21 -0400
Content-Disposition: inline
In-Reply-To: <CAPTn0cBgrUGG+8iAb=wfUke4g8AWBB3tHV25YFuA5FF05we8Aw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

On Thu 17-03-16 09:47:44, Li Xi wrote:
> I sent a patch of quota tool to Jan Kara ccing you. With that patch,
> project quota
> of ext4 can be reported. However, that patch needs a lot of improvement.
> 
> That patch can be found here too:
> 
> https://github.com/ddn-lixi/project_quota_ext4_utils/blob/master/quota-tools.git/patches/project_quota_support_for_quota-tools.patch

Li Xi, if I find time to massage the patch into usable form, can I add your
Signed-off-by so that I can commit it in quota-tools repository?

								Honza

> On Wed, Mar 16, 2016 at 1:29 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> > Am I missing something, or do we currently don't have a way to report
> > project quota usage with ext4?  The support doesn't appear to be in
> > quota tools, and xfs_quota doesn't work without changes because it
> > only tries to operate on XFS file systems.
> >
> > Thanks,
> >
> >                                                 - Ted
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
