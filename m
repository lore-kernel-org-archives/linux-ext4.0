From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [RFC PATCH 1/2] bdi: Create a flag to indicate that a backing
 device needs stable page writes
Date: Tue, 30 Oct 2012 16:58:41 -0700
Message-ID: <509069B1.2040200@panasas.com>
References: <20121026101909.GB19617@blackbox.djwong.org> <20121027013524.GA19591@blackbox.djwong.org> <yq1ehkg8us1.fsf@sermon.lab.mkp.net> <20121030154844.1898f068@notabene.brown> <yq1a9v4884i.fsf@sermon.lab.mkp.net> <20121030201424.GD19559@blackbox.djwong.org> <20121031091441.5fc6b412@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	"Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: NeilBrown <neilb@suse.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20121031091441.5fc6b412@notabene.brown>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 10/30/2012 03:14 PM, NeilBrown wrote:
> On Tue, 30 Oct 2012 13:14:24 -0700 "Darrick J. Wong"
> <darrick.wong@oracle.com> wrote:
> 
>> On Tue, Oct 30, 2012 at 08:19:41AM -0400, Martin K. Petersen wrote:
>>>>>>>> "Neil" == NeilBrown  <neilb@suse.de> writes:
>>>
<>
>  So I see a need for 2 flags here.

Yes that was my thought too. We need two flags. The FS should communicate
it's capabilities as well.

>  The first one is set by the device or transport to say "I would prefer
>  stable writes if possible".
>  The second is set by the filesystem, either because it has its own needs, or
>  because it sees the first flag set on the device and chooses to honour it.
>  The VFS/VM would act based on this second flag, and devices like md/RAID5
>  would set the first flag, and assume writes are stable if the second flag is
>  also set.
> 
>  This implies that setting that second flag must be handled synchronously by
>  the filesystem, so that the device doesn't see the flag set until the
>  filesystem has committed to honouring it.  That seems to make a mount (or
>  remount) option the safest way to set it.
> 

I think I do not like any mount option or any other tuneable. With the
block device stating it's needs and the FS confirming on it's capability
then I do not see how reverting that decision by admin can be any good.
Any overrides by an admin would then just be a bug.

>  Comments?
> 
> NeilBrown
> 

Thanks
Boaz
