From: Matt Sealey <matt@genesi-usa.com>
Subject: Re: Tracking down suspend/resume ext3/mmc issues on imx233
Date: Mon, 10 Sep 2012 10:11:48 -0500
Message-ID: <CAKGA1bnug8nqcideOBZyLQZmiVo=G5L3aRHq4k4SNZyH132Y=g@mail.gmail.com>
References: <CAEOSq-O3SfuAEhMsjX1y1ZgQuWBKef+XZzMR1b4yJhKhaRdymA@mail.gmail.com>
 <20120907060552.GL26709@S2101-09.ap.freescale.net> <CAEOSq-PV+7c2nvu3uauOLJcV7WKa1jmd-df0a1H0qY5K4CM5MA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Shawn Guo <shawn.guo@linaro.org>,
	Linux-Arm-Kernel <linux-arm-kernel@lists.infradead.org>,
	linux-ext4@vger.kernel.org, linux-mmc@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Mike Thompson <mpthompson@gmail.com>
Return-path: <linux-mmc-owner@vger.kernel.org>
In-Reply-To: <CAEOSq-PV+7c2nvu3uauOLJcV7WKa1jmd-df0a1H0qY5K4CM5MA@mail.gmail.com>
Sender: linux-mmc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Wouldn't it be better if the root filesystem was marked as
non-removable in the device tree - or in the case of a truly removable
card, just marked in the MMC subsystem - and the MMC subsystem skipped
the "it could be removed" for suspend/resume operations?

Whether you can or you cannot remove an SD memory device or eMMC
controller, having an option that marked "DANGEROUS" that says "MMC
layer will assume that all cards stayed in their respective slots
during the suspend" implies that on a system such as the
numbering-more-than-I-can-count embedded devices here with eMMC and
any number greater than zero SD card slots (most of them having at
least two), ALL of them are treated as unsafe resume, when in fact
only one of them might be.

My use cases here are usually boot from eMMC or boot from external SD
card (Snowball, Efika MX but one SD card slot is usually not needed to
go through the unsafe-resume process, all FSL i.MX boards since MX51
Babbage through the new MX6 boards, Pandaboard, Beagleboard). Just
because it's possible to boot from external, removable SD card
shouldn't mean we all have to configure our kernels explicitly to go
through a strange and unusual path for suspend and resume which leaves
ALL cards 'mounted' unecessarily over suspend/resume, especially in
the common case where eMMC is also not the ONLY boot medium (PATA,
SATA, non-eMMC flash) and eMMC or SD *MAY* only be the root filesystem
(as opposed to *WILL*)

??

-- 
Matt Sealey <matt@genesi-usa.com>
Product Development Analyst, Genesi USA, Inc.


On Sat, Sep 8, 2012 at 11:17 AM, Mike Thompson <mpthompson@gmail.com> wrote:
> I figured the source of my problem.  Normally, the Linux kernel will
> treat mmc cards as removed during suspend.  This is in case the card
> is swapped by the user during the suspend.  However, on the OLinuXino
> the mmc device is the root file system  If the Linux kernel treats the
> mmc card as removed the frozen tasks with open file handles to the
> root filesystem device (such as the journal tasks) will fail when they
> are thawed during resume.  This is the problem I was seeing.
>
> Fortunately, there is already a specific kernel config setting
> CONFIG_MMC_UNSAFE_RESUME that needs to be set for systems such as the
> OLinuXino that uses the mmc device for the root filesystem.  I
> overlooked this config setting and spent half a day trying to figure
> out the source of the file system errors on resume.  Next time I'll do
> a better job of looking through related config settings before trying
> to debug an issue that is probably already dealt with.
>
> Mike
>
> On Thu, Sep 6, 2012 at 11:05 PM, Shawn Guo <shawn.guo@linaro.org> wrote:
>> Copy a few more lists to get wider audience ...
>>
>> Regards,
>> Shawn
>>
>> On Thu, Sep 06, 2012 at 10:03:35PM -0700, Mike Thompson wrote:
>>> I'm working on adding power management support for the imx233 on
>>> 3.6-rc2.  In general I'm working on porting the pm.c file from the
>>> Freescale 2.6.35 kernel for both "standby" and "mem" suspend/resume.
>>> I'm making pretty good progress on porting the code, but I'm running
>>> into an issue outside the immediate code I'm working on.
>>>
>>> ...
>>>
>>> The first reported error is in the ext3 filesystem buffer code where
>>> the file system buffers aren't being filled by the underlying block
>>> device.  At least that's how I'm interpreting the portion of the ext3
>>> file system code that is failing.  However, the mmc device is
>>> correctly reporting finding p1 and p2 partitions on the device which
>>> it would indicate the partition data is being read from the SD card.
>>>
>>> I'm hoping others might have suggestions on how I should go about
>>> tracking down why the ext3 file system can no longer read from the mmc
>>> device upon resume.  For instance, useful places to put some tracing
>>> code to understand what might be failing, or how to determine what
>>> differences there might be before suspend and after resume that might
>>> point to the failure.
>>>
>>> Thanks,
>>>
>>> Mike Thompson
>>>
>>> _______________________________________________
>>> linux-arm-kernel mailing list
>>> linux-arm-kernel@lists.infradead.org
>>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
