From: Dave Chinner <david@fromorbit.com>
Subject: Re: [v14 3/4] ext4: adds FS_IOC_FSSETXATTR/FS_IOC_FSGETXATTR
 interface support
Date: Thu, 30 Apr 2015 08:07:17 +1000
Message-ID: <20150429220717.GX15810@dastard>
References: <1429728997-21464-1-git-send-email-lixi@ddn.com>
 <1429728997-21464-4-git-send-email-lixi@ddn.com>
 <20150426232033.GQ15810@dastard>
 <CAPTn0cAHOHP060cW8k0-HnyfKdVaUwAVOyLZU43AXtECK6_EaA@mail.gmail.com>
 <20150428044331.GV21261@dastard>
 <CAPTn0cBymWmQ5JKAPpFzqzivbEpjzY=s+M5O5bCsne7LbEeiLA@mail.gmail.com>
 <20150429075924.GB31089@quack.suse.cz>
 <CAPTn0cDZ3rHBxo2rQCWM=cZsjrL3QJUAkbkaj1ax3b72OUn0Rg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger@dilger.ca>,
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
	"hch@infradead.org" <hch@infradead.org>,
	Dmitry Monakhov <dmonakhov@openvz.org>,
	John Stultz <john.stultz@linaro.org>,
	Thomas Gleixner <tglx@linutronix.de>
To: Li Xi <pkuelelixi@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAPTn0cDZ3rHBxo2rQCWM=cZsjrL3QJUAkbkaj1ax3b72OUn0Rg@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Apr 29, 2015 at 07:45:40PM +0800, Li Xi wrote:
> On Wed, Apr 29, 2015 at 3:59 PM, Jan Kara <jack@suse.cz> wrote:
> >   Hi,
> >
> > On Wed 29-04-15 13:49:08, Li Xi wrote:
> >> Thanks for the advices. I tried to run latest xfstests again. However,
> >   Dave actually asked you to update 'xfsprogs' not xfstests. Not that
> > updating xfstests would be a wrong thing to do but you still need to update
> > xfsprogs for xfstests to be able to run some tests. But that's unrelated to
> > the oops you reported below.
> Understood. I updated both xfstests and xfsprogs to the latest version from git
> repository. However, I didn't update xfsdump because of a build failure caused
> by missing definitons of 'min' and 'max'

The /usr/include/xfs header files are stale. Upgrade your
xfslibs-dev package, if there is one for your distro.

And, please, report package build failures to the appropriate list,
next time, rather than ignoring them?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
