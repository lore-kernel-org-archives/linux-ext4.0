Return-Path: <SRS0=dqau=MX=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44044 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729991AbeJLAQ6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 11 Oct 2018 20:16:58 -0400
Date: Thu, 11 Oct 2018 18:48:54 +0200
From: Jan Kara <jack@suse.cz>
To: "Paul E. McKenney" <paulmck@linux.ibm.com>
Cc: Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        joel@joelfernandes.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH -v3] ext4: fix use-after-free race in ext4_remount()'s
 error path
Message-ID: <20181011164854.GA29637@quack2.suse.cz>
References: <20181007030706.9094-1-tytso@mit.edu>
 <20181011102800.GB9467@quack2.suse.cz>
 <20181011152953.GL2674@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181011152953.GL2674@linux.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 11-10-18 08:29:53, Paul E. McKenney wrote:
> On Thu, Oct 11, 2018 at 12:28:00PM +0200, Jan Kara wrote:
> > On Sat 06-10-18 23:07:06, Theodore Ts'o wrote:
> > > It's possible for ext4_show_quota_options() to try reading
> > > s_qf_names[i] while it is being modified by ext4_remount() --- most
> > > notably, in ext4_remount's error path when the original values of the
> > > quota file name gets restored.
> > > 
> > > Reported-by: syzbot+a2872d6feea6918008a9@syzkaller.appspotmail.com
> > > Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> > > Cc: stable@kernel.org
> > 
> > Well, honestly the fact that ->show_options can be called while remount is
> > changing stuff under you looks problematic to me and I bet ext4 is not the
> > only one that would have issues with that. So I believe we might be better
> > off with just synchronizing ->show_options with umount / remount properly.
> > What were the lock dependency problems that made you switch to use RCU?
> 
> OK, I will bite...
> 
> Ted's patch does in fact just properly synchronize ->show_options with
> umount / remount.  Using RCU.  ;-)

Well, it does but only for quota mount options. There may be other mount
options which would need similar treatment and possibly other mount options
in other filesystems. So I think a saner VFS API would be to synchronize
->show_options with umount / remount so that each filesystem does not have
to do it on its own.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
