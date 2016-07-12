From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2] xfstests, generic: add project quota attribute tests
Date: Tue, 12 Jul 2016 16:32:02 +0200
Message-ID: <20160712143202.GA2629@quack2.suse.cz>
References: <1467786171-21127-1-git-send-email-wangshilong1991@gmail.com>
 <20160706233533.GK27480@dastard>
 <d0018d66-cb32-16df-b46e-5c418cc4bfae@sandeen.net>
 <20160708005127.GK12670@dastard>
 <20160708024654.GE19871@thunk.org>
 <77863b4a-95e6-4100-79c2-5cbcaf0872e7@sandeen.net>
 <20160708050228.GH19871@thunk.org>
 <20160711161556.GB9334@quack2.suse.cz>
 <20160711171242.GA21285@thunk.org>
 <20160712105908.GE16460@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Eric Sandeen <sandeen@sandeen.net>,
	Dave Chinner <david@fromorbit.com>,
	Wang Shilong <wangshilong1991@gmail.com>,
	fstests@vger.kernel.org, linux-ext4@vger.kernel.org,
	sihara@ddn.com, lixi@ddn.com, Wang Shilong <wshilong@ddn.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160712105908.GE16460@quack2.suse.cz>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue 12-07-16 12:59:08, Jan Kara wrote:
> On Mon 11-07-16 13:12:42, Ted Tso wrote:
> > On Mon, Jul 11, 2016 at 06:15:56PM +0200, Jan Kara wrote:
> > > 
> > > What would you like to achieve with this? There is 'QF_META' format which
> > > is different from 'QF_XFS' format basically only in the set of quotactls
> > > used. As I said above it might be nice to separate kernel-api from the
> > > underlying-quota-format but in reality these two were bound together in
> > > older kernels so they are not really independent.
> > 
> > The main reason why I noticed is with the new (err, "latest") ext4
> > quota (enabled via mke2fs -t ext4 -O quota) implementation, we enable
> > quota tracking at mount time.  (This may be true with journalled quota
> > as well, actually).  But we don't actually enable quota *enforcement*
> > until quotaon is given.
> 
> Yes.
> 
> > The problem is that quotaon -p prints the status of whether or not
> > quota *tracking* is enabled, and with the new ext4 quota, quota
> > tracking is *always* enabled.  So quota -p doesn't report anything
> > useful for new ext4 quota systems, and when I started to look at how
> > to change things, that's when I noticed that we weren't using the new
> > quotactl commands with ext4 even though they worked, and that the new
> > quotactl implementation had more functionality than the older ones.
> 
> OK. But with XFS you'd notice that quotaon -p also returns 'on' whenever
> the accounting is turned on. So ext4 and xfs behave in the same way.
> Arguably it would be more useful if quotaon -p reported 'off', 'accounting',
> 'enforcement'. Maybe I'll do that.

This is now done and push out to quota-tools repository. When XGETSTAT
quotactl is available, 'quotaon -pva' will report whether the quota is
enabled only for accounting or also enforced.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
