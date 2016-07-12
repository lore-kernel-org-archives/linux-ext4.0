From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2] xfstests, generic: add project quota attribute tests
Date: Tue, 12 Jul 2016 12:15:47 -0400
Message-ID: <20160712161547.GB11020@thunk.org>
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
Cc: Eric Sandeen <sandeen@sandeen.net>,
	Dave Chinner <david@fromorbit.com>,
	Wang Shilong <wangshilong1991@gmail.com>,
	fstests@vger.kernel.org, linux-ext4@vger.kernel.org,
	sihara@ddn.com, lixi@ddn.com, Wang Shilong <wshilong@ddn.com>
To: Jan Kara <jack@suse.cz>
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160712105908.GE16460@quack2.suse.cz>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jul 12, 2016 at 12:59:08PM +0200, Jan Kara wrote:
> OK. But with XFS you'd notice that quotaon -p also returns 'on' whenever
> the accounting is turned on. So ext4 and xfs behave in the same way.
> Arguably it would be more useful if quotaon -p reported 'off', 'accounting',
> 'enforcement'. Maybe I'll do that.

That would be good, since at the moment to determine whether or not
quota enforcement is enabled or not.

> Speaking of automatic enabling of quota enforcement: I wanted to keep the
> old behavior where no enforcement happens until you run quotaon(8) which is
> how things traditionally worked for ext2/3/4. That's why things default to
> having enforcement off. If we want to make things more consistent with XFS,
> one option I can see is that when e.g. 'usrquota' mount option is set, then
> user quota enforcement will be turned on. That is essentially how XFS
> works (including the mount option name). What do you think?

That seems reasonable.  The only concern is that it might be confusing
for people who are using older, legacy quota setups, but given that
usrquota would cause enforcing plus accounting to be enabled, it
shouldn't cause a problem.

I think aligning with XFS so that the user experience for quota should
be as identical as possible regardless of which file system is being
used makes a lot of sense, especially since you've been adding a bunch
of the plumbing for quotactl to make this possible.

On the kernel side this means that teaching ext4 so that if the
usrquota monut option is specified, quota enforcing will be enabled.
We should make the necessary changes in kernel and possily quota-tools
so that quotaoff can also disable quota enforcing (just like with
XFS).

Does that sound like a plan?

          				- Ted
