Return-Path: <SRS0=dqau=MX=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:39166 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727384AbeJLAs1 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 11 Oct 2018 20:48:27 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w9BHJ8nR131421
        for <linux-ext4@vger.kernel.org>; Thu, 11 Oct 2018 13:20:16 -0400
Received: from e12.ny.us.ibm.com (e12.ny.us.ibm.com [129.33.205.202])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2n2a1htufq-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-ext4@vger.kernel.org>; Thu, 11 Oct 2018 13:20:15 -0400
Received: from localhost
        by e12.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-ext4@vger.kernel.org> from <paulmck@linux.vnet.ibm.com>;
        Thu, 11 Oct 2018 13:20:14 -0400
Date: Thu, 11 Oct 2018 10:20:10 -0700
From: "Paul E. McKenney" <paulmck@linux.ibm.com>
To: Jan Kara <jack@suse.cz>
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        joel@joelfernandes.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH -v3] ext4: fix use-after-free race in ext4_remount()'s
 error path
Reply-To: paulmck@linux.ibm.com
References: <20181007030706.9094-1-tytso@mit.edu>
 <20181011102800.GB9467@quack2.suse.cz>
 <20181011152953.GL2674@linux.ibm.com>
 <20181011164854.GA29637@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181011164854.GA29637@quack2.suse.cz>
Message-Id: <20181011172010.GM2674@linux.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 11, 2018 at 06:48:54PM +0200, Jan Kara wrote:
> On Thu 11-10-18 08:29:53, Paul E. McKenney wrote:
> > On Thu, Oct 11, 2018 at 12:28:00PM +0200, Jan Kara wrote:
> > > On Sat 06-10-18 23:07:06, Theodore Ts'o wrote:
> > > > It's possible for ext4_show_quota_options() to try reading
> > > > s_qf_names[i] while it is being modified by ext4_remount() --- most
> > > > notably, in ext4_remount's error path when the original values of the
> > > > quota file name gets restored.
> > > > 
> > > > Reported-by: syzbot+a2872d6feea6918008a9@syzkaller.appspotmail.com
> > > > Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> > > > Cc: stable@kernel.org
> > > 
> > > Well, honestly the fact that ->show_options can be called while remount is
> > > changing stuff under you looks problematic to me and I bet ext4 is not the
> > > only one that would have issues with that. So I believe we might be better
> > > off with just synchronizing ->show_options with umount / remount properly.
> > > What were the lock dependency problems that made you switch to use RCU?
> > 
> > OK, I will bite...
> > 
> > Ted's patch does in fact just properly synchronize ->show_options with
> > umount / remount.  Using RCU.  ;-)
> 
> Well, it does but only for quota mount options. There may be other mount
> options which would need similar treatment and possibly other mount options
> in other filesystems. So I think a saner VFS API would be to synchronize
> ->show_options with umount / remount so that each filesystem does not have
> to do it on its own.

On that choice, I must of course defer to the various filesystem and
VFS people, yourself included.

							Thanx, Paul
