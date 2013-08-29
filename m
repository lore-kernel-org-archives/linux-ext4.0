From: =?ISO-8859-1?Q?Kevyn=2DAlexandre_Par=E9?=
	<kevyn.alexandre.pare@gmail.com>
Subject: Re: Unable to randomly boot rootfs (EXT3 or EXT4) from SD: MMC error
 -110 (TIMEDOUT)
Date: Thu, 29 Aug 2013 15:49:31 -0400
Message-ID: <CAL1yNc+EHiZRD=G3-7OuMouh1uht6x3mvPXbQh7YWerFpnRqoA@mail.gmail.com>
References: <CAL1yNcJZBSSNu4aDmL6n9uu3LkNPCOM-LbUXD2990jkPJYpLoA@mail.gmail.com>
	<CAL1yNc+9pOWLCLfk7WpWvvsLfb01cFCJSi+4mTvnks9VrwoF1Q@mail.gmail.com>
	<20130827220143.GC9182@thunk.org>
	<CAL1yNcLzXir7KFavxaQK3OWWU5hHc06tvOSLrdvWB-VoEJdXQA@mail.gmail.com>
	<20130828175622.GA27079@thunk.org>
	<CAL1yNc+fzbeVR7TCuG9zjMG8D3zSu_ZnrrqnhtHv0oTRVteXTg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-omap@vger.kernel.org, linux-mmc@vger.kernel.org,
	linux-ext4@vger.kernel.org, arnd@linaro.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-mmc-owner@vger.kernel.org>
In-Reply-To: <CAL1yNc+fzbeVR7TCuG9zjMG8D3zSu_ZnrrqnhtHv0oTRVteXTg@mail.gmail.com>
Sender: linux-mmc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

I forgot to mention that I was not able to reproduce it yet with the
CONFIG_MMC_DEBUG=3Dy

Since this is simply slowing down the boot could this be a timeout
problem that is to limit and fail to soon?

-KA

On Thu, Aug 29, 2013 at 3:39 PM, Kevyn-Alexandre Par=E9
<kevyn.alexandre.pare@gmail.com> wrote:
> On Wed, Aug 28, 2013 at 1:56 PM, Theodore Ts'o <tytso@mit.edu> wrote:
>> On Wed, Aug 28, 2013 at 11:22:58AM -0400, Kevyn-Alexandre Par=E9 wro=
te:
>>> We try multiple of our system ( Different micro SD from SanDisk +
>>> Overo with OMAP3) and they are all doing this with the SanDisk 64GB=
,
>>> 32GB :
>>> http://www.sandisk.com/products/memory-cards/microsd/ultra-class10-=
for-android/?capacity=3D64GB
>>>
>>> The problem seem to be easier to reproduce when we just flash the
>>> micro SD (partition, format & copy rootfs) at it first boot.
>>> Also, when we let the system down for a couple of days and then
>>> sometimes we need to reboot the system multiple times before it fal=
l
>>> back alright.
>>>
>>> We found a old patch that was simply increasing the timeout of the =
host:
>>> http://cgit.openembedded.org/cgit.cgi/openembedded/tree/recipes/lin=
ux/linux-omap-2.6.39/sakoman/0024-omap-mmc-Adjust-dto-to-eliminate-time=
out-errors.patch?h=3Dorg.openembedded.dev
>>>
>>> By settings the timeout to zero I reproduce kind of the same timeou=
t
>>> error at every boot. That was expected since I don't let enough tim=
e
>>> to the controller to respond...
>>>
>>> Could the mix of that MMC controller and these card is not optimal?=
 Is
>>> the driver fully supporting the UHS-I speed grade?
>>
>> I've cc'ed Arnd Bergman who works at Linaro; I suspect that if he
>> doesn't know the answer off the top of his head, he can probably
>> direct you to someone who will.
>>
>
> Thx Ted,
>
> Here's more details that I manage to gathered. I add logs in
> drivers/mmc/card/block.c in function mmc_blk_err_check() to grab the
> command opcode:
> pr_err("### KA: mmc_blk_err_check CMD %u\n", areq->mrq->cmd->opcode);
>
> Steps that I most often reproduce it.
> Flashing microSD from Ubuntu 12.10 creating 2 partitions (FAT,EXT4)
> with USB dongle if this may help (we try with different one and the
> same result happen)?
>
> Aug 29 15:26:38 kap kernel: [371788.469842] usb 1-1: new high-speed
> USB device number 19 using ehci_hcd
> Aug 29 15:26:38 kap kernel: [371788.655389] usb 1-1: New USB device
> found, idVendor=3D0bda, idProduct=3D0119
> Aug 29 15:26:38 kap kernel: [371788.656090] usb 1-1: New USB device
> strings: Mfr=3D1, Product=3D2, SerialNumber=3D3
> Aug 29 15:26:38 kap kernel: [371788.656150] usb 1-1: Product: USB2.0-=
CRW
> Aug 29 15:26:38 kap kernel: [371788.656173] usb 1-1: Manufacturer: Ge=
neric
> Aug 29 15:26:38 kap kernel: [371788.656187] usb 1-1: SerialNumber:
> 20090815198100000
> Aug 29 15:26:39 kap kernel: [371789.101509] scsi16 : usb-storage 1-1:=
1.0
> Aug 29 15:26:40 kap kernel: [371790.114299] scsi 16:0:0:0:
> Direct-Access     Generic- SD/MMC           1.00 PQ: 0 ANSI: 0 CCS
> Aug 29 15:26:40 kap kernel: [371790.126066] sd 16:0:0:0: Attached scs=
i
> generic sg2 type 0
> Aug 29 15:26:40 kap kernel: [371790.962739] sd 16:0:0:0: [sdb]
> 124735488 512-byte logical blocks: (63.8 GB/59.4 GiB)
> Aug 29 15:26:40 kap kernel: [371790.967661] sd 16:0:0:0: [sdb] Write
> Protect is off
> Aug 29 15:26:40 kap kernel: [371790.967713] sd 16:0:0:0: [sdb] Mode
> Sense: 03 00 00 00
> Aug 29 15:26:40 kap kernel: [371790.971559] sd 16:0:0:0: [sdb] No
> Caching mode page present
> Aug 29 15:26:40 kap kernel: [371790.971742] sd 16:0:0:0: [sdb]
> Assuming drive cache: write through
> Aug 29 15:26:40 kap kernel: [371790.991103] sd 16:0:0:0: [sdb] No
> Caching mode page present
> Aug 29 15:26:40 kap kernel: [371790.991113] sd 16:0:0:0: [sdb]
> Assuming drive cache: write through
> Aug 29 15:26:40 kap kernel: [371790.995660]  sdb: sdb1 sdb2
> Aug 29 15:26:40 kap kernel: [371791.014090] sd 16:0:0:0: [sdb] No
> Caching mode page present
> Aug 29 15:26:40 kap kernel: [371791.014101] sd 16:0:0:0: [sdb]
> Assuming drive cache: write through
> Aug 29 15:26:40 kap kernel: [371791.014169] sd 16:0:0:0: [sdb]
> Attached SCSI removable disk
>
> Then take the SD but it in the embedded device and boot it. Note that
> most of the time the next boot pass, with mmc_blk_err_check for CMD 1=
8
> & 25.
>
> The output of the kernel panic (3.4.59) gives:
> [...]
> Waiting for root device /dev/mmcblk0p2...
> mmc0: host does not support reading read-only switch. assuming write-=
enable.
> mmc0: new high speed SDXC card at address aaaa
> mmcblk0: mmc0:aaaa SU64G 59.4 GiB
> ### KA: mmc_blk_err_check CMD 18
>  mmcblk0: p1 p2
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> mmc1: new SDIO card at address 0001
> ### KA: mmc_blk_err_check CMD 25
> EXT4-fs (mmcblk0p2): mounted filesystem with ordered data mode. Opts:=
 (null)
> VFS: Mounted root (ext4 filesystem) on device 179:2.
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> devtmpfs: mounted
> Freeing init memory: 220K
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> INIT: version 2.86 booting
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> Please wait: boo### KA: mmc_blk_err_check CMD 18
> ting...
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> Starting udev
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 25
> ### KA: mmc_blk_err_check CMD 25
> hub 1-0:1.0: hub_suspend
> usb usb1: bus auto-suspend, wakeup 1
> ehci-omap ehci-omap.0: suspend root hub
> ### KA: mmc_blk_err_check CMD 25
> ### KA: mmc_blk_err_check CMD 25
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> udevd (90): /proc/90/oom_adj is deprecated, please use
> /proc/90/oom_score_adj instead.
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ads7846 spi1.0: touchscreen, irq 210
> ### KA: mmc_blk_err_check CMD 18
> input: ADS7846 Touchscreen as
> /devices/platform/omap2_mcspi.1/spi_master/spi1/spi1.0/input/input0
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> input: twl4030_pwrbutton as
> /devices/platform/omap_i2c.1/i2c-1/1-0049/twl4030_pwrbutton/input/inp=
ut1
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> ### KA: mmc_blk_err_check CMD 18
> mmcblk0: error -110 sending status command, retrying
> mmcblk0: error -110 sending status command, retrying
> mmcblk0: error -110 sending status command, aborting
> ### KA: mmc_start_req catch error.
> end_request: I/O error, dev mmcblk0, sector 416
> Buffer I/O error on device mmcblk0, logical block 52
> ### KA: mmc_blk_err_check CMD 18
> mmcblk0: error -110 sending status command, retrying
> mmcblk0: error -110 sending status command, retrying
> mmcblk0: error -110 sending status command, aborting
> ### KA: mmc_start_req catch error.
> end_request: I/O error, dev mmcblk0, sector 67681792
> end_request: I/O error, dev mmcblk0, sector 67681800
> end_request: I/O error, dev mmcblk0, sector 67681808
> end_request: I/O error, dev mmcblk0, sector 67681816
> end_request: I/O error, dev mmcblk0, sector 67681824
> end_request: I/O error, dev mmcblk0, sector 67681832
> end_request: I/O error, dev mmcblk0, sector 67681840
> end_request: I/O error, dev mmcblk0, sector 67681848
> end_request: I/O error, dev mmcblk0, sector 67681856
> end_request: I/O error, dev mmcblk0, sector 67681864
> end_request: I/O error, dev mmcblk0, sector 67681872
> end_request: I/O error, dev mmcblk0, sector 67681880
> end_request: I/O error, dev mmcblk0, sector 67681888
> end_request: I/O error, dev mmcblk0, sector 67681896
> end_request: I/O error, dev mmcblk0, sector 67681904
> end_request: I/O error, dev mmcblk0, sector 67681912
> end_request: I/O error, dev mmcblk0, sector 67681920
> end_request: I/O error, dev mmcblk0, sector 67681928
> end_request: I/O error, dev mmcblk0, sector 67681936
> end_request: I/O error, dev mmcblk0, sector 67681944
> end_request: I/O error, dev mmcblk0, sector 67681952
> end_request: I/O error, dev mmcblk0, sector 67681960
> end_request: I/O error, dev mmcblk0, sector 67681968
> end_request: I/O error, dev mmcblk0, sector 67681976
> end_request: I/O error, dev mmcblk0, sector 67681984
> end_request: I/O error, dev mmcblk0, sector 67681992
> end_request: I/O error, dev mmcblk0, sector 67682000
> end_request: I/O error, dev mmcblk0, sector 67682008
> end_request: I/O error, dev mmcblk0, sector 67682016
> end_request: I/O error, dev mmcblk0, sector 67682024
> end_request: I/O error, dev mmcblk0, sector 67682032
> end_request: I/O error, dev mmcblk0, sector 67682040
> ### KA: mmc_blk_err_check CMD 18
> mmcblk0: error -110 sending status command, retrying
> mmcblk0: error -110 sending status command, retrying
> mmcblk0: error -110 sending status command, aborting
> ### KA: mmc_start_req catch error.
> end_request: I/O error, dev mmcblk0, sector 67502720
> end_request: I/O error, dev mmcblk0, sector 67502728
> end_request: I/O error, dev mmcblk0, sector 67502736
> end_request: I/O error, dev mmcblk0, sector 67502744
> ### KA: mmc_blk_err_check CMD 18
> mmcblk0: error -110 sending status command, retrying
> mmcblk0: error -110 sending status command, retrying
> mmcblk0: error -110 sending status command, aborting
> ### KA: mmc_start_req catch error.
> end_request: I/O error, dev mmcblk0, sector 416
> Buffer I/O error on device mmcblk0, logical block 52
> ### KA: mmc_blk_err_check CMD 18
> mmcblk0: error -110 sending status command, retrying
> mmcblk0: error -110 sending status command, retrying
> mmcblk0: error -110 sending status command, aborting
> ### KA: mmc_start_req catch error.
> end_request: I/O error, dev mmcblk0, sector 50528680
> ### KA: mmc_blk_err_check CMD 18
> mmcblk0: error -110 sending status command, retrying
> mmcblk0: error -110 sending status command, retrying
> mmcblk0: error -110 sending status command, aborting
> ### KA: mmc_start_req catch error.
> end_request: I/O error, dev mmcblk0, sector 67502720
> ### KA: mmc_blk_err_check CMD 18
> mmcblk0: error -110 sending status command, retrying
> mmcblk0: error -110 sending status command, retrying
> mmcblk0: error -110 sending status command, aborting
> ### KA: mmc_start_req catch error.
> end_request: I/O error, dev mmcblk0, sector 67502960
> end_request: I/O error, dev mmcblk0, sector 67502968
> ### KA: mmc_blk_err_check CMD 18
> mmcblk0: error -110 sending status command, retrying
> mmcblk0: error -110 sending status command, retrying
> mmcblk0: error -110 sending status command, aborting
> ### KA: mmc_start_req catch error.
> end_request: I/O error, dev mmcblk0, sector 67681792
> ### KA: mmc_blk_err_check CMD 18
> mmcblk0: error -110 sending status command, retrying
> mmcblk0: error -110 sending status command, retrying
> mmcblk0: error -110 sending status command, aborting
> ### KA: mmc_start_req catch error.
> end_request: I/O error, dev mmcblk0, sector 512
> Buffer I/O error on device mmcblk0, logical block 64
> ### KA: mmc_blk_err_check CMD 18
> mmcblk0: error -110 sending status command, retrying
> mmcblk0: error -110 sending status command, retrying
> mmcblk0: error -110 sending status command, aborting
> ### KA: mmc_start_req catch error.
> end_request: I/O error, dev mmcblk0, sector 50766416
> ### KA: mmc_blk_err_check CMD 18
> mmcblk0: error -110 sending status command, retrying
> mmcblk0: error -110 sending status command, retrying
> mmcblk0: error -110 sending status command, aborting
> ### KA: mmc_start_req catch error.
> end_request: I/O error, dev mmcblk0, sector 67502960
> ### KA: mmc_blk_err_check CMD 18
> mmcblk0: error -110 sending status command, retrying
> mmcblk0: error -110 sending status command, retrying
> mmcblk0: error -110 sending status command, aborting
> ### KA: mmc_start_req catch error.
> end_request: I/O error, dev mmcblk0, sector 67681792
> ### KA: mmc_blk_err_check CMD 18
> mmcblk0: error -110 sending status command, retrying
> mmcblk0: error -110 sending status command, retrying
> mmcblk0: error -110 sending status command, aborting
> ### KA: mmc_start_req catch error.
> end_request: I/O error, dev mmcblk0, sector 512
> Buffer I/O error on device mmcblk0, logical block 64
> ### KA: mmc_blk_err_check CMD 18
> mmcblk0: error -110 sending status command, retrying
> mmcblk0: error -110 sending status command, retrying
> mmcblk0: error -110 sending status command, aborting
> ### KA: mmc_start_req catch error.
> end_request: I/O error, dev mmcblk0, sector 50766416
> udevd-work[220]: exec of program '/lib/udev/usb_id' failed
>
> ### KA: mmc_blk_err_check CMD 25
> mmcblk0: error -110 sending status command, retrying
> mmcblk0: error -110 sending status command, retrying
> mmcblk0: error -110 sending status command, aborting
> ### KA: mmc_start_req catch error.
> end_request: I/O error, dev mmcblk0, sector 131072
> Buffer I/O error on device mmcblk0p2, logical block 0
> lost page write due to I/O error on mmcblk0p2
> EXT4-fs error (device mmcblk0p2): ext4_find_entry:932: inode #1572945=
:
> comm udevd: reading directory lblock 0
> ### KA: mmc_blk_err_check CMD 25
> mmcblk0: error -110 sending status command, retrying
> mmcblk0: error -110 sending status command, retrying
> mmcblk0: error -110 sending status command, aborting
> ### KA: mmc_start_req catch error.
> end_request: I/O error, dev mmcblk0, sector 25559216
> Buffer I/O error on device mmcblk0p2, logical block 3178518
> EXT4-fs warning (device mmcblk0p2): ext4_end_bio:250: I/O error
> writing to inode 786588 (offset 0 size 4096 starting block 3194903)
> end_request: I/O error, dev mmcblk0, sector 25559224
> Buffer I/O error on device mmcblk0p2, logical block 3178519
> EXT4-fs warning (device mmcblk0p2): ext4_end_bio:250: I/O error
> writing to inode 786590 (offset 0 size 4096 starting block 3194904)
> Aborting journal on device mmcblk0p2-8.
> EXT4-fs (mmcblk0p2): previous I/O error to superblock detected
> EXT4-fs (mmcblk0p2): previous I/O error to superblock detected
> EXT4-fs (mmcblk0p2): previous I/O error to superblock detected
> ### KA: mmc_blk_err_check CMD 25
> mmcblk0: error -110 sending status command, retrying
> mmcblk0: error -110 sending status command, retrying
> mmcblk0: error -110 sending status command, aborting
> ### KA: mmc_start_req catch error.
> end_request: I/O error, dev mmcblk0, sector 25578592
> Buffer I/O error on device mmcblk0p2, logical block 3180940
> EXT4-fs warning (device mmcblk0p2): ext4_end_bio:250: I/O error
> writing to inode 786591 (offset 0 size 4096 starting block 3197325)
> end_request: I/O error, dev mmcblk0, sector 25578600
> Buffer I/O error on device mmcblk0p2, logical block 3180941
> EXT4-fs warning (device mmcblk0p2): ext4_end_bio:250: I/O error
> writing to inode 786592 (offset 0 size 4096 starting block 3197326)
> end_request: I/O error, dev mmcblk0, sector 25578608
> Buffer I/O error on device mmcblk0p2, logical block 3180942
> EXT4-fs warning (device mmcblk0p2): ext4_end_bio:250: I/O error
> writing to inode 786593 (offset 0 size 4096 starting block 3197327)
> ### KA: mmc_blk_err_check CMD 25
> mmcblk0: error -110 sending status command, retrying
> mmcblk0: error -110 sending status command, retrying
> mmcblk0: error -110 sending status command, aborting
> ### KA: mmc_start_req catch error.
> end_request: I/O error, dev mmcblk0, sector 59113472
> Buffer I/O error on device mmcblk0p2, logical block 7372800
> lost page write due to I/O error on mmcblk0p2
> JBD2: Error -5 detected when updating journal superblock for mmcblk0p=
2-8.
> ### KA: mmc_blk_err_check CMD 18
> JBD2: Detected IO errors while flushing file data on mmcblk0p2-8
> mmcblk0: error -110 sending status command, retrying
> mmcblk0: error -110 sending status command, retrying
> mmcblk0: error -110 sending status command, aborting
> ### KA: mmc_start_req catch error.
> end_request: I/O error, dev mmcblk0, sector 32
> Buffer I/O error on device mmcblk0, logical block 4
> ### KA: mmc_blk_err_check CMD 18
> mmcblk0: error -110 sending status command, retrying
> mmcblk0: error -110 sending status command, retrying
> mmcblk0: error -110 sending status command, aborting
> ### KA: mmc_start_req catch error.
> end_request: I/O error, dev mmcblk0, sector 50766416
> ### KA: mmc_blk_err_check CMD 18
> mmcblk0: error -110 sending status command, retrying
> mmcblk0: error -110 sending status command, retrying
> mmcblk0: error -110 sending status command, aborting
> ### KA: mmc_start_req catch error.
> end_request: I/O error, dev mmcblk0, sector 67502720
> ### KA: mmc_blk_err_check CMD 18
> mmcblk0: error -110 sending status command, retrying
> mmcblk0: error -110 sending status command, retrying
> mmcblk0: error -110 sending status command, aborting
> ### KA: mmc_start_req catch error.
> end_request: I/O error, dev mmcblk0, sector 32
> Buffer I/O error on device mmcblk0, logical block 4
> ### KA: mmc_blk_err_check CMD 18
> mmcblk0: error -110 sending status command, retrying
> mmcblk0: error -110 sending status command, retrying
> mmcblk0: error -110 sending status command, aborting
> ### KA: mmc_start_req catch error.
> end_request: I/O error, dev mmcblk0, sector 50766416
> ### KA: mmc_blk_err_check CMD 25
> mmcblk0: error -110 sending status command, retrying
> mmcblk0: error -110 sending status command, retrying
> mmcblk0: error -110 sending status command, aborting
> ### KA: mmc_start_req catch error.
> end_request: I/O error, dev mmcblk0, sector 131072
> Buffer I/O error on device mmcblk0p2, logical block 0
> lost page write due to I/O error on mmcblk0p2
> ### KA: mmc_blk_err_check CMD 25
> mmcblk0: error -110 sending status command, retrying
> mmcblk0: error -110 sending status command, retrying
> mmcblk0: error -110 sending status command, aborting
> ### KA: mmc_start_req catch error.
> end_request: I/O error, dev mmcblk0, sector 59113472
> Buffer I/O error on device mmcblk0p2, logical block 7372800
> lost page write due to I/O error on mmcblk0p2
> JBD2: Error -5 detected when updating journal superblock for mmcblk0p=
2-8.
> ### KA: mmc_blk_err_check CMD 18
> Kernel panic - not syncing: EXT4-fs (device mmcblk0p2): panic forced =
after error
>
> thx,
>
> -KA
