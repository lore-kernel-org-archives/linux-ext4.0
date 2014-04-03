From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [Lsf] [PATCH] xfstests-bld: Simplify determination of number of
 CPUs in build-all
Date: Thu, 3 Apr 2014 12:21:25 -0700
Message-ID: <CALCETrVq1DfpyhThajc9FYA7NLWYt9oX4vadCDcqn+d26aALGA@mail.gmail.com>
References: <1395997399-3000-1-git-send-email-sedat.dilek@gmail.com>
 <20140328161806.GA31772@thunk.org> <20140331025148.GF16336@dastard>
 <20140401023711.GE4911@thunk.org> <20140401222823.GJ17603@dastard>
 <20140402142620.GA6901@thunk.org> <20140403011411.GL16336@dastard>
 <alpine.LFD.2.00.1404031102310.2124@localhost.localdomain>
 <CALCETrU=JWigDSv6ymepS2tjL+EkO98VDC03-RSPuhQVk3yvZA@mail.gmail.com>
 <20140403173504.GB23737@thunk.org> <533DB140.8010103@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	=?ISO-8859-2?Q?Luk=E1=B9_Czerner?= <lczerner@redhat.com>,
	Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com,
	lsf@lists.linux-foundation.org,
	Linux FS Devel <linux-fsdevel@vger.kernel.org>,
	Sedat Dilek <sedat.dilek@gmail.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <533DB140.8010103@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Apr 3, 2014 at 12:06 PM, Eric Sandeen <sandeen@redhat.com> wrote:
> On 4/3/14, 11:35 AM, Theodore Ts'o wrote:
>
>>>  - There's an undocumented way to write results outside the source
>>> tree called RESULT_BASE.  It would be great if it were documented and
>>> spelled consistently.
>
> I'm not actually certain that it was intended to be used this way.
> See 1686f9ab "xfstests: Introduce a results directory"
> which explains just where this variable came from and what it's
> for...

Yeah.  A real solution should just create and overmount results.

Unfortunately, AFAICT it's currently impossible to create a mountpoint
with no underlying dentry or to overmount a symlink, so this can be a
bit awkward.

>>>  - SCRATCH_MNT needs to be in /etc/fstab.  I think that this should be
>>> changed or documented.  If the latter, then SCRATCH_DEV seems
>>> redundant.
>
> Hm, I've never needed SCRATCH_MNT in /etc/fstab...
>
>> The various test scripts do need to be able to find the device where
>> the file system lives, and parsing /etc/fstab would be awkward.  So if
>> your comment is that either the /etc/fstab entry shouldn't be
>> required, or the xfstests runtime environment should be able to derive
>> $SCRATCH_DEV automatically from $SCRATCH_MNT, or vice versa, instead
>
> I guess I don't know why you'd expect to derive one from the other...

Sigh.

If $SCRATCH_MNT is specified, then the line in /etc/fstab is
unnecessary.  If $SCRATCH_MNT is not specified, then /etc/fstab will
do the trick.

What does not work is specifying $SCRATCH_DIR [sic] but not adding an
fstab entry.  Oops.


--Andy
