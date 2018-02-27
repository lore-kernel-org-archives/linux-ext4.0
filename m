From: Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH V15 06/22] mmc: block: Add blk-mq support
Date: Tue, 27 Feb 2018 11:28:54 +0200
Message-ID: <8876217f-ede6-fc81-2e05-b4fc976b3235@intel.com>
References: <1511962879-24262-1-git-send-email-adrian.hunter@intel.com>
 <1511962879-24262-7-git-send-email-adrian.hunter@intel.com>
 <bc65b542-9703-aa04-f1c7-b10584e44391@gmail.com>
 <829308a3-3bf6-c173-65fa-e2a0f45f7f61@intel.com>
 <68886f99-97f5-897a-f754-6f414741bd5a@gmail.com>
 <22580b82-0257-b156-9f0c-79afa34067e5@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: linux-mmc <linux-mmc@vger.kernel.org>,
        linux-block <linux-block@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bough Chen <haibo.chen@nxp.com>,
        Alex Lemberg <alex.lemberg@sandisk.com>,
        Mateusz Nowak <mateusz.nowak@intel.com>,
        Yuliy Izrailov <Yuliy.Izrailov@sandisk.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Dong Aisheng <dongas86@gmail.com>,
        Das Asutosh <asutoshd@codeaurora.org>,
        Zhangfei Gao <zhangfei.gao@gmail.com>,
        Sahitya Tummala <stummala@codeaurora.org>,
        Harjani Ritesh <riteshh@codeaurora.org>,
        Venu Byravarasu <vbyravarasu@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Shawn Lin <shawn.lin@rock-chips.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Christoph Hellwig <hch@lst.de>,
        Thierry Reding <tred
To: Dmitry Osipenko <digetx@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <22580b82-0257-b156-9f0c-79afa34067e5@gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 26/02/18 23:48, Dmitry Osipenko wrote:
> On 22.02.2018 20:54, Dmitry Osipenko wrote:
>> On 22.02.2018 10:42, Adrian Hunter wrote:
>>> On 21/02/18 22:50, Dmitry Osipenko wrote:
>>>> On 29.11.2017 16:41, Adrian Hunter wrote:
>>>>> Define and use a blk-mq queue. Discards and flushes are processed
>>>>> synchronously, but reads and writes asynchronously. In order to support
>>>>> slow DMA unmapping, DMA unmapping is not done until after the next request
>>>>> is started. That means the request is not completed until then. If there is
>>>>> no next request then the completion is done by queued work.
>>>>
>>>> Hello,
>>>>
>>>> I'm using (running linux-next and doing some upstream development for) some old
>>>> NVIDIA Tegra tablet that has built-in (internal) and external MMC's and with the
>>>> blk-mq being enabled I'm observing a soft lockup. The lockup seems is
>>>> reproducible quite reliably by running fsck on any MMC partition, sometimes
>>>> kernels lockups on boot during probing partitions table (weirdly only when both
>>>> SDHCI's are present, i.e. internal storage enabled in DT and external SD is
>>>> inserted/enabled) and it also lockups pretty quickly in a case of just a general
>>>> use. Reverting mmc/ commits up to 1bec43a3b18 ("Remove option not to use
>>>> blk-mq") and disabling CONFIG_MMC_MQ_DEFAULT makes everything working fine
>>>> again. There is also a third SDHCI populated with built-in WiFi/Bluetooth SDIO
>>>> and I'm observing odd MMC timeouts with the blk-mq enabled, disabling
>>>> CONFIG_MMC_MQ_DEFAULT fixes these timeouts as well.
>>>>
>>>> Any thoughts?
>>>
>>> SDIO (unless it is a combo card) should be unaffected by changes to the
>>> block driver.
> 
> I don't know whether it's a combo card or not. Where I can find info about that?
> Is it mentioned in sysfs somewhere? Alternatively you may take a brief look at
> what brcmfmac driver does, maybe it will tell you immediately whether blk-mq
> affects it or not. And if it's not affected, then it could be that there is some
> other issue that is masked by a properly working block driver.

As linus wrote, if you had a combo card it would also show up as a block
device i.e. for mmc2 it would probably be /dev/mmcblk2 if it existed.

> 
>>> I don't have any ideas.  Adding more NVIDIA people.
>>>>
>>>> WiFi issue
>>>> ========================
>>>>
>>>> [   38.247006] mmc2: Timeout waiting for hardware interrupt.
>>>> [   38.247027] brcmfmac: brcmf_escan_timeout: timer expired
>>>> [   38.247036] mmc2: sdhci: ============ SDHCI REGISTER DUMP ===========
>>>> [   38.247047] mmc2: sdhci: Sys addr:  0x00000000 | Version:  0x00000001
>>>> [   38.247055] mmc2: sdhci: Blk size:  0x00007008 | Blk cnt:  0x00000000
>>>> [   38.247062] mmc2: sdhci: Argument:  0x21000008 | Trn mode: 0x00000013
>>>> [   38.247070] mmc2: sdhci: Present:   0x01d70000 | Host ctl: 0x00000013
>>>> [   38.247077] mmc2: sdhci: Power:     0x00000001 | Blk gap:  0x00000000
>>>> [   38.247084] mmc2: sdhci: Wake-up:   0x00000000 | Clock:    0x00000007
>>>> [   38.247091] mmc2: sdhci: Timeout:   0x0000000e | Int stat: 0x00000000
>>>> [   38.247098] mmc2: sdhci: Int enab:  0x02ff000b | Sig enab: 0x02fc000b
>>>> [   38.247105] mmc2: sdhci: AC12 err:  0x00000000 | Slot int: 0x00000000
>>>> [   38.247112] mmc2: sdhci: Caps:      0x61ff30b0 | Caps_1:   0x00000000
>>>> [   38.247119] mmc2: sdhci: Cmd:       0x0000353a | Max curr: 0x00000001
>>>> [   38.247126] mmc2: sdhci: Resp[0]:   0x00001800 | Resp[1]:  0x08002db5
>>>> [   38.247133] mmc2: sdhci: Resp[2]:   0x16da8000 | Resp[3]:  0x00000400
>>>> [   38.247139] mmc2: sdhci: Host ctl2: 0x00000000
>>>> [   38.247146] mmc2: sdhci: ADMA Err:  0x00000000 | ADMA Ptr: 0x17c47200
>>>> [   38.247152] mmc2: sdhci: ============================================
>>>> [   38.247250] brcmfmac: brcmf_sdio_readframes: read 520 bytes from channel 1
>>>> failed: -84
>>>> [   38.247274] brcmfmac: brcmf_sdio_rxfail: abort command, terminate frame, send NAK
>>>> [   40.807019] brcmfmac: brcmf_sdio_bus_rxctl: resumed on timeout
>>>> [   40.807042] brcmfmac: brcmf_notify_escan_complete: Scan abort failed
>>>> [   48.487007] mmc2: Timeout waiting for hardware interrupt.
>>>> [   48.487057] mmc2: sdhci: ============ SDHCI REGISTER DUMP ===========
>>>> [   48.487096] mmc2: sdhci: Sys addr:  0x00000000 | Version:  0x00000001
>>>> [   48.487128] mmc2: sdhci: Blk size:  0x00007040 | Blk cnt:  0x00000001
>>>> [   48.487160] mmc2: sdhci: Argument:  0x21000040 | Trn mode: 0x00000013
>>>> [   48.487191] mmc2: sdhci: Present:   0x01d70000 | Host ctl: 0x00000013
>>>> [   48.487221] mmc2: sdhci: Power:     0x00000001 | Blk gap:  0x00000000
>>>> [   48.487251] mmc2: sdhci: Wake-up:   0x00000000 | Clock:    0x00000007
>>>> [   48.487281] mmc2: sdhci: Timeout:   0x0000000e | Int stat: 0x00000000
>>>> [   48.487313] mmc2: sdhci: Int enab:  0x02ff000b | Sig enab: 0x02fc000b
>>>> [   48.487343] mmc2: sdhci: AC12 err:  0x00000000 | Slot int: 0x00000000
>>>> [   48.487374] mmc2: sdhci: Caps:      0x61ff30b0 | Caps_1:   0x00000000
>>>> [   48.487404] mmc2: sdhci: Cmd:       0x0000353a | Max curr: 0x00000001
>>>> [   48.487435] mmc2: sdhci: Resp[0]:   0x00001000 | Resp[1]:  0x08002db5
>>>> [   48.487466] mmc2: sdhci: Resp[2]:   0x16da8000 | Resp[3]:  0x00000400
>>>> [   48.487493] mmc2: sdhci: Host ctl2: 0x00000000
>>>> [   48.487525] mmc2: sdhci: ADMA Err:  0x00000000 | ADMA Ptr: 0x17c47200
>>>> [   48.487552] mmc2: sdhci: ============================================
>>>> [   48.487749] brcmfmac: brcmf_sdio_readframes: read 480 bytes from channel 1
>>>> failed: -84
>>>> [   48.487822] brcmfmac: brcmf_sdio_rxfail: abort command, terminate frame, send NAK
>>>>
>>>>
>>>> Soft lockup issue
>>>> ========================
>>>>
>>>> # fsck -f /dev/disk/by-uuid/6768309f-3545-49d5-9ac7-d5be24d35ef2
>>>> fsck из util-linux 2.30.2
>>>> e2fsck 1.43.9 (8-Feb-2018)
>>>> Проход 1: Проверка inodes, блокs, а также размеров
>>>> Pass 2: Checking каталог structure
>>>> Pass 3: Checking каталог connectivity
>>>> Pass 4: Checking reference counts
>>>> Pass 5: Checking группа summary information
>>>> ....
>>>>
>>>> [  125.925436] INFO: task kworker/0:3H:263 blocked for more than 60 seconds.
>>>> [  125.925496]       Not tainted
>>>> 4.16.0-rc2-next-20180220-00101-gaefde91c3955-dirty #2041
>>>> [  125.925530] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
>>>> message.
>>>> [  125.925562] kworker/0:3H    D    0   263      2 0x00000000
>>>> [  125.925653] Workqueue: kblockd mmc_blk_mq_complete_work
>>>> [  125.925747] [<c0b991cc>] (__schedule) from [<c0b998f0>] (schedule+0x60/0xcc)
>>>> [  125.925805] [<c0b998f0>] (schedule) from [<c086c870>]
>>>> (__mmc_claim_host+0xdc/0x24c)
>>>> [  125.925849] [<c086c870>] (__mmc_claim_host) from [<c08750bc>]
>>>
>>> That claim host should not be there.  Here is a fix for that:
>>>
>>> diff --git a/drivers/mmc/core/mmc_ops.c b/drivers/mmc/core/mmc_ops.c
>>> index 908e4db03535..62049f95116b 100644
>>> --- a/drivers/mmc/core/mmc_ops.c
>>> +++ b/drivers/mmc/core/mmc_ops.c
>>> @@ -932,9 +932,7 @@ static int mmc_read_bkops_status(struct mmc_card *card)
>>>  	int err;
>>>  	u8 *ext_csd;
>>>
>>> -	mmc_claim_host(card->host);
>>>  	err = mmc_get_ext_csd(card, &ext_csd);
>>> -	mmc_release_host(card->host);
>>>  	if (err)
>>>  		return err;
>>
>> Looks like this patch fixes all the problems. I'll keep testing it for a couple
>> of days and then report back the final result. Thank you very much.
> 
> This patch fixes the lockup (and WiFi MMC timeouts), for that:
> 
> Tested-by: Dmitry Osipenko <digetx@gmail.com>
> 
> 
> But still something is wrong... I've been getting occasional EXT4 Ooops's, like
> the one below, and __wait_on_bit() is always figuring in the stacktrace. It
> never happened with blk-mq disabled, though it could be a coincidence and
> actually unrelated to blk-mq patches.

I can't think how an IO driver could cause that.

cc'ing ext4 mailing list for more advice.

> 
> 
> [ 6625.992337] Unable to handle kernel NULL pointer dereference at virtual
> address 0000001c
> [ 6625.993004] pgd = 00b30c03
> [ 6625.993257] [0000001c] *pgd=00000000
> [ 6625.993594] Internal error: Oops: 5 [#1] PREEMPT SMP ARM
> [ 6625.994022] Modules linked in:
> [ 6625.994326] CPU: 1 PID: 19355 Comm: dpkg Not tainted
> 4.16.0-rc2-next-20180220-00095-ge9c9f5689a84-dirty #2090
> [ 6625.995078] Hardware name: NVIDIA Tegra SoC (Flattened Device Tree)
> [ 6625.995595] PC is at dx_probe+0x68/0x684
> [ 6625.995947] LR is at __wait_on_bit+0xac/0xc8
> [ 6625.996307] pc : [<c033b960>]    lr : [<c0bfbfd4>]    psr: 800f0013
> [ 6625.996806] sp : d55e3df0  ip : c0170e88  fp : d55e3e44
> [ 6625.997227] r10: d55e3f4c  r9 : d55e3e70  r8 : 00000000
> [ 6625.997650] r7 : c4e13240  r6 : 00000000  r5 : d657db18  r4 : d55e3e8c
> [ 6625.998165] r3 : 0000007b  r2 : d5830800  r1 : d5831000  r0 : c4e13240
> [ 6625.998686] Flags: Nzcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
> [ 6625.999246] Control: 10c5387d  Table: 0a63004a  DAC: 00000051
> [ 6625.999710] Process dpkg (pid: 19355, stack limit = 0x139a48b6)
> [ 6626.000184] Stack: (0xd55e3df0 to 0xd55e4000)
> [ 6626.000560] 3de0:                                     000002e9 d55e3e00
> c0c01964 c0278c70
> [ 6626.001209] 3e00: d55e3e24 014000c0 c04f3580 c0c01958 d55e3e90 801a001a
> d55e3e3c 00000012
> [ 6626.001854] 3e20: d5830800 00000000 d657db18 c24b0000 d55e3e70 d55e3f4c
> d55e3edc d55e3e48
> [ 6626.002502] 3e40: c033d568 c033b904 00000000 600f0013 c029e640 d6cf3540
> ffffe000 00000000
> [ 6626.003150] 3e60: 00076e99 d55e3ef4 d55e3e8c d5830800 d409c440 d409c454
> 00000012 c029e640
> [ 6626.003795] 3e80: d55e3ec4 d55e3e90 c02797b4 c4e13240 00000000 00000000
> 00000000 00000000
> [ 6626.004442] 3ea0: 00000000 00000000 00000000 00000000 d409c428 d409c428
> d657db18 d409c428
> [ 6626.005088] 3ec0: 00000000 c24b0000 ffffff9c d55e3f4c d55e3f14 d55e3ee0
> c033d7b0 c033d1b8
> [ 6626.005732] 3ee0: c0c01964 c0180050 d55e3f14 d55e3ef8 c029e870 00000000
> d409c428 d6546558
> [ 6626.006382] 3f00: d55e3f58 00000000 d55e3f34 d55e3f18 c0291f04 c033d764
> 00000000 00000001
> [ 6626.007032] 3f20: 00000000 d55e3f58 d55e3f94 d55e3f38 c0293d70 c0291ea0
> d55e3f58 d55e3f4c
> [ 6626.007679] 3f40: 00000000 0090abb0 d5467800 00000000 d6dd0110 d6546558
> f3bc423c 00000012
> [ 6626.008326] 3f60: c24b0019 80808080 00000000 015ce1b0 0090abb0 00d8d670
> 00000028 c01011e4
> [ 6626.008971] 3f80: d55e2000 00000000 d55e3fa4 d55e3f98 c0294544 c0293c44
> 00000000 d55e3fa8
> [ 6626.009620] 3fa0: c0101000 c0294530 015ce1b0 0090abb0 0090abb0 000002a8
> 7d5a8800 7d5a8800
> [ 6626.010264] 3fc0: 015ce1b0 0090abb0 00d8d670 00000028 0048eb80 00487344
> 015eb160 004a6c10
> [ 6626.010912] 3fe0: 004a6c8c bede3c0c 0048149d b6ecc6b8 600f0030 0090abb0
> 00000000 00000000
> [ 6626.011577] [<c033b960>] (dx_probe) from [<c033d568>]
> (ext4_find_entry+0x3bc/0x5ac)
> [ 6626.012198] [<c033d568>] (ext4_find_entry) from [<c033d7b0>]
> (ext4_lookup+0x58/0x1f4)
> [ 6626.012844] [<c033d7b0>] (ext4_lookup) from [<c0291f04>]
> (__lookup_hash+0x70/0x9c)
> [ 6626.013468] [<c0291f04>] (__lookup_hash) from [<c0293d70>] (do_rmdir+0x138/0x1b8)
> [ 6626.014071] [<c0293d70>] (do_rmdir) from [<c0294544>] (SyS_rmdir+0x20/0x24)
> [ 6626.014642] [<c0294544>] (SyS_rmdir) from [<c0101000>]
> (ret_fast_syscall+0x0/0x54)
> [ 6626.015231] Exception stack(0xd55e3fa8 to 0xd55e3ff0)
> [ 6626.015656] 3fa0:                   015ce1b0 0090abb0 0090abb0 000002a8
> 7d5a8800 7d5a8800
> [ 6626.016302] 3fc0: 015ce1b0 0090abb0 00d8d670 00000028 0048eb80 00487344
> 015eb160 004a6c10
> [ 6626.035930] 3fe0: 004a6c8c bede3c0c 0048149d b6ecc6b8
> [ 6626.055341] Code: e1a07000 e5840000 8a000078 e590601c (e5d6301c)
> [ 6626.075632] ---[ end trace 034f3552437a92bc ]---
> 
