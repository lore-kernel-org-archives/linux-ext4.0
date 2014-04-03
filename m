From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [Lsf] [PATCH] xfstests-bld: Simplify determination of number
	of CPUs in build-all
Date: Thu, 03 Apr 2014 15:46:24 -0600
Message-ID: <533DD6B0.6010102@sandeen.net>
References: <1395997399-3000-1-git-send-email-sedat.dilek@gmail.com>	<20140328161806.GA31772@thunk.org>
	<20140331025148.GF16336@dastard>	<20140401023711.GE4911@thunk.org>
	<20140401222823.GJ17603@dastard>	<20140402142620.GA6901@thunk.org>
	<20140403011411.GL16336@dastard>	<alpine.LFD.2.00.1404031102310.2124@localhost.localdomain>	<CALCETrU=JWigDSv6ymepS2tjL+EkO98VDC03-RSPuhQVk3yvZA@mail.gmail.com>	<20140403173504.GB23737@thunk.org>
	<533DB140.8010103@redhat.com>
	<CALCETrVq1DfpyhThajc9FYA7NLWYt9oX4vadCDcqn+d26aALGA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso@mit.edu>, xfs@oss.sgi.com,
	lsf@lists.linux-foundation.org,
	Linux FS Devel <linux-fsdevel@vger.kernel.org>,
	Sedat Dilek <sedat.dilek@gmail.com>,
	=?windows-1252?Q?Luk=E1=9A_Czerner?= <lczerner@redhat.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andy Lutomirski <luto@amacapital.net>, Eric Sandeen <sandeen@redhat.com>
Return-path: <xfs-bounces@oss.sgi.com>
In-Reply-To: <CALCETrVq1DfpyhThajc9FYA7NLWYt9oX4vadCDcqn+d26aALGA@mail.gmail.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
List-Id: linux-ext4.vger.kernel.org

On 4/3/14, 1:21 PM, Andy Lutomirski wrote:
> On Thu, Apr 3, 2014 at 12:06 PM, Eric Sandeen <sandeen@redhat.com> wrote:

...

>>> The various test scripts do need to be able to find the device where
>>> the file system lives, and parsing /etc/fstab would be awkward.  So if
>>> your comment is that either the /etc/fstab entry shouldn't be
>>> required, or the xfstests runtime environment should be able to derive
>>> $SCRATCH_DEV automatically from $SCRATCH_MNT, or vice versa, instead
>>
>> I guess I don't know why you'd expect to derive one from the other...
> 
> Sigh.
> 
> If $SCRATCH_MNT is specified, then the line in /etc/fstab is
> unnecessary.  If $SCRATCH_MNT is not specified, then /etc/fstab will
> do the trick.
> 
> What does not work is specifying $SCRATCH_DIR [sic] but not adding an
> fstab entry.  Oops.

Oh, I see.

I'd never really thought about xfstests devices as "part of the system" -
since they're constantly scribbled on, re-made, etc, and managed wholly
by xfstests (at least the scratch device) - so the notion of using fstab
was just outside my realm of expected behaviors.  :)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
