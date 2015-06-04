From: Li Xi <pkuelelixi@gmail.com>
Subject: Re: [v14 3/4] ext4: adds FS_IOC_FSSETXATTR/FS_IOC_FSGETXATTR
 interface support
Date: Thu, 4 Jun 2015 23:29:50 +0800
Message-ID: <CAPTn0cBM5_8TaPzZRqcr_Rk7aHYiErmUdKR69XG55z179p1fZg@mail.gmail.com>
References: <1429728997-21464-1-git-send-email-lixi@ddn.com>
	<1429728997-21464-4-git-send-email-lixi@ddn.com>
	<20150426232033.GQ15810@dastard>
	<CAPTn0cAHOHP060cW8k0-HnyfKdVaUwAVOyLZU43AXtECK6_EaA@mail.gmail.com>
	<20150428044331.GV21261@dastard>
	<CAPTn0cBymWmQ5JKAPpFzqzivbEpjzY=s+M5O5bCsne7LbEeiLA@mail.gmail.com>
	<20150429075924.GB31089@quack.suse.cz>
	<CAPTn0cDZ3rHBxo2rQCWM=cZsjrL3QJUAkbkaj1ax3b72OUn0Rg@mail.gmail.com>
	<20150429220717.GX15810@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Jan Kara <jack@suse.cz>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger@dilger.ca>,
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
	"hch@infradead.org" <hch@infradead.org>,
	Dmitry Monakhov <dmonakhov@openvz.org>,
	John Stultz <john.stultz@linaro.org>,
	Thomas Gleixner <tglx@linutronix.de>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20150429220717.GX15810@dastard>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

I tried hard to run xfstests on original linux-4.0. In order to do so,
I skipped some of the tests which cause kernel crash. However, about
ten tests were skipped. But the crash seems endless. I was using the
latest xfstests from git repository. I guess there is some mismatch
between the versions of XFS and xfstests that I used? Should I use
some special version of xfstests or XFS? Please advise.

Regards,
Li Xi

On Thu, Apr 30, 2015 at 6:07 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Wed, Apr 29, 2015 at 07:45:40PM +0800, Li Xi wrote:
>> On Wed, Apr 29, 2015 at 3:59 PM, Jan Kara <jack@suse.cz> wrote:
>> >   Hi,
>> >
>> > On Wed 29-04-15 13:49:08, Li Xi wrote:
>> >> Thanks for the advices. I tried to run latest xfstests again. However,
>> >   Dave actually asked you to update 'xfsprogs' not xfstests. Not that
>> > updating xfstests would be a wrong thing to do but you still need to update
>> > xfsprogs for xfstests to be able to run some tests. But that's unrelated to
>> > the oops you reported below.
>> Understood. I updated both xfstests and xfsprogs to the latest version from git
>> repository. However, I didn't update xfsdump because of a build failure caused
>> by missing definitons of 'min' and 'max'
>
> The /usr/include/xfs header files are stale. Upgrade your
> xfslibs-dev package, if there is one for your distro.
>
> And, please, report package build failures to the appropriate list,
> next time, rather than ignoring them?
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
