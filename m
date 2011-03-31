From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC][PATCH] Re: [BUG] ext4: cannot unfreeze a filesystem due
 to a deadlock
Date: Thu, 31 Mar 2011 18:28:35 +0200
Message-ID: <20110331162835.GE21524@quack.suse.cz>
References: <20110215172954.GK17313@quack.suse.cz>
 <20110216081746.54d146d1.toshi.okajima@jp.fujitsu.com>
 <20110216145627.GB5592@quack.suse.cz>
 <4D5C9B1B.2050304@jp.fujitsu.com>
 <20110217104552.GD4947@quack.suse.cz>
 <20110328170628.ffe314fb.toshi.okajima@jp.fujitsu.com>
 <20110330141205.GC22349@quack.suse.cz>
 <AANLkTi=jTSEXsRJE+zzNvvTfFmqdAY42na8vm22NJefz@mail.gmail.com>
 <4D9489DD.6080602@redhat.com>
 <AANLkTi=3HT-n4-4Q0RhWLGq0PSAgY68MPUa2zxU_uDY4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, Jan Kara <jack@suse.cz>,
	Amir Goldstein <amir73il@gmail.com>,
	Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>,
	Ted Ts'o <tytso@mit.edu>,
	Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44402 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758655Ab1CaQ2n (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 31 Mar 2011 12:28:43 -0400
Content-Disposition: inline
In-Reply-To: <AANLkTi=3HT-n4-4Q0RhWLGq0PSAgY68MPUa2zxU_uDY4@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 31-03-11 22:36:46, Yongqiang Yang wrote:
> On Thu, Mar 31, 2011 at 10:04 PM, Eric Sandeen <sandeen@redhat.com> wrote:
> > On 3/31/11 3:37 AM, Yongqiang Yang wrote:
> >
> >> in ext3, ext3_freeze() prevents journal from being updated by
> >> lock_journal_updates(), ext3_unfreeze() allow journal to be updated by
> >> unlock_journal_updates().
> >>
> >> in ext4, however, before ext4_freeze() returns, it unlock journal, and
> >> ext4 prevents journal from being updated by s_frozen. s_frozen is in
> >> an upper layer, so it is out control of ext4 and deadlock is easy to
> >> happen.
> >>
> >> Could someone explain why ext4 does like above but not follow ext3?
> >>
> >> Yongqiang.
> >
> > That was me, I think ...
> 
> Thank you, Eric.
> 
> I think ext4_journal_start() should check if current thread has an
> active handle before  vfs_check_frozen(), if so, current handle will
> be returned. Thus, we can avoid deadlocks.
> 
> Do you agree with me?  If I am right, I will send a patch.
  Yes, definitely. This was exactly what I wanted to propose as well.
Thanks for looking into this.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
