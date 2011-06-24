From: Jan Kara <jack@suse.cz>
Subject: Re: Bug#615998: linux-image-2.6.32-5-xen-amd64: Repeatable "kernel
 BUG at fs/jbd2/commit.c:534" from Postfix on ext4
Date: Fri, 24 Jun 2011 22:02:31 +0200
Message-ID: <20110624200231.GA32176@quack.suse.cz>
References: <15E8241A-37A0-4438-849E-A157A376C7F1@boeing.com>
 <8658F8EE-A52D-4405-A1F3-C0247AB3EA6D@boeing.com>
 <26AE8923-4DEA-43FF-8F79-1D5AA665A344@boeing.com>
 <20110405230538.GH2832@thunk.org>
 <FD93E462-D97B-411B-BF09-9A64670AC5C2@boeing.com>
 <AF621113-8320-4973-A88A-1FC048EA4293@boeing.com>
 <BANLkTi=5BLA07tvbv3PFcZ0cc8FmBtg+UA@mail.gmail.com>
 <404FD5CC-8F27-4336-B7D4-10675C53A588@boeing.com>
 <20110624134659.GB26380@quack.suse.cz>
 <2F80BF45-28FA-46D3-9A28-CA9416DC5813@boeing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Sean Ryle <seanbo@gmail.com>,
	Ted Ts'o <tytso@mit.edu>,
	"615998@bugs.debian.org" <615998@bugs.debian.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Sachin Sant <sachinp@in.ibm.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: "Moffett, Kyle D" <Kyle.D.Moffett@boeing.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56328 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753300Ab1FXUCh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 24 Jun 2011 16:02:37 -0400
Content-Disposition: inline
In-Reply-To: <2F80BF45-28FA-46D3-9A28-CA9416DC5813@boeing.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 24-06-11 11:03:52, Moffett, Kyle D wrote:
> On Jun 24, 2011, at 09:46, Jan Kara wrote:
> > On Thu 23-06-11 16:19:08, Moffett, Kyle D wrote:
> >> Besides which, line 534 in the Debian 2.6.32 kernel I am using is this
> >> one:
> >> 
> >>  J_ASSERT(commit_transaction->t_nr_buffers <=
> >>           commit_transaction->t_outstanding_credits);
> > 
> >  Hmm, OK, so we've used more metadata buffers than we told JBD2 to
> > reserve. I suppose you are not using data=journal mode and the filesystem
> > was created as ext4 (i.e. not converted from ext3), right? Are you using
> > quotas?
> 
> The filesystem *is* using data=journal mode.  If I switch to data=ordered
> or data=writeback, the problem goes away.
  Ah, OK. Then bug https://bugzilla.kernel.org/show_bug.cgi?id=34642 is
probably ext3 incarnation of the same problem and it seems it's still
present even in the current kernel - that ext3 assertion triggered even
with 2.6.39 kernel. Frankly data=journal mode is far less tested than the
other two modes especially with ext4, so I'm not sure how good idea is to
use it in production.

> The filesystems were created as ext4 using the e2fstools in Debian squeeze:
> 1.41.12, and the kernel package is 2.6.32-5-xen-amd64 (2.6.32-34squeeze1).
> 
> The exact commands I used to create the Postfix filesystems were:
>   lvcreate -L  5G -n postfix dbnew
>   lvcreate -L 32M -n smtp    dbnew
>   mke2fs -t ext4 -L db:postfix /dev/dbnew/postfix
>   mke2fs -t ext4 -L db:smtp    /dev/dbnew/smtp
>   tune2fs -i 0 -c 1 -e remount-ro -o acl,user_xattr,journal_data /dev/dbnew/postfix
>   tune2fs -i 0 -c 1 -e remount-ro -o acl,user_xattr,journal_data /dev/dbnew/smtp
> 
> Then my fstab has:
>   /dev/mapper/dbnew-postfix /var/spool/postfix ext4 noauto,noatime,nosuid,nodev 0 2
>   /dev/mapper/dbnew-smtp    /var/lib/postfix   ext4 noauto,noatime,nosuid,nodev 0 2
> 
> I don't even think I have the quota tools installed on this system; there
> are certainly none configured.
  OK, thanks.

> >> If somebody can tell me what information would help to debug this I'd be
> >> more than happy to throw a whole bunch of debug printks under that error
> >> condition and try to trigger the crash with that.
> >> 
> >> Alternatively I could remove that J_ASSERT() and instead add some debug
> >> further down around the "commit_transaction->t_outstanding_credits--;"
> >> to try to see exactly what IO it's handling when it runs out of credits.
> > 
> >  The trouble is that the problem is likely in some journal list shuffling
> > code because if just some operation wrongly estimated the number of needed
> > buffers, we'd fail the assertion in jbd2_journal_dirty_metadata():
> > J_ASSERT_JH(jh, handle->h_buffer_credits > 0);
> 
> Hmm, ok...  I'm also going to turn that failing J_ASSERT() into a WARN_ON()
> just to see how much further it gets.  I have an easy script to recreate this
> data volume even if it gets totally hosed anyways, so...
  OK, we'll see what happens.

> > The patch below might catch the problem closer to the place where it
> > happens...
> > 
> > Also possibly you can try current kernel whether the bug happens with it or
> > not.
> 
> I'm definitely going to try this patch, but I'll also see what I can do about
> trying a more recent kernel.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
