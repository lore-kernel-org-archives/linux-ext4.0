From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: RT/ext4/jbd2 circular dependency
Date: Thu, 30 Oct 2014 08:24:17 -0400
Message-ID: <20141030122417.GB5032@thunk.org>
References: <544940EF.7090907@windriver.com>
 <alpine.DEB.2.11.1410261516020.5308@nanos>
 <544E7144.4080809@windriver.com>
 <alpine.DEB.2.11.1410291854090.5308@nanos>
 <54513BDA.1050804@windriver.com>
 <alpine.DEB.2.11.1410292013510.5308@nanos>
 <20141029231916.GD5000@thunk.org>
 <54517A1F.1060102@windriver.com>
 <20141030014405.GE5000@thunk.org>
 <CAF_MivGWF6BVZbztKSHQ+EKNkfm-9UhZ61fKXZzpfXdL=2RhvA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Friesen <chris.friesen@windriver.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Austin Schuh <austin@peloton-tech.com>, pavel@pavlinux.ru,
	"J. Bruce Fields" <bfields@fieldses.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	adilger.kernel@dilger.ca, rt-users <linux-rt-users@vger.kernel.org>
To: Kevin Liao <kevinlia@gmail.com>
Return-path: <linux-rt-users-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAF_MivGWF6BVZbztKSHQ+EKNkfm-9UhZ61fKXZzpfXdL=2RhvA@mail.gmail.com>
Sender: linux-rt-users-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Oct 30, 2014 at 04:15:45PM +0800, Kevin Liao wrote:
> 
> I also have similar jbd2 hang problem for kernel 3.4. Could you kindly
> specify what are the three commits to fix the issue? Cause I can not
> find them using the keyword "commit b34090e e5a120a f5113ef".

Those *are* the three commits:

% git log -3 --oneline  b34090e 
b34090e jbd2: refine waiting for shadow buffers
e5a120a jbd2: remove journal_head from descriptor buffers
f5113ef jbd2: don't create journal_head for temporary journal buffers

Or if you need the full git commit ID's

% git log --pretty=oneline -3  b34090e 
b34090e5e22a02fba0e4473056cce9420ad9dd0b jbd2: refine waiting for shadow buffers
e5a120aeb57f40ae568a5ca1dd6ace53d0213582 jbd2: remove journal_head from descriptor buffers
f5113effc2a2ee6b86a4b345ce557353dcbcfffe jbd2: don't create journal_head for temporary journal buffers

Or the URL's:

https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=b34090e5e22a02fba0e4473056cce9420ad9dd0b
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=e5a120aeb57f40ae568a5ca1dd6ace53d0213582
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=f5113effc2a2ee6b86a4b345ce557353dcbcfffe

Cheers,

						- Ted
