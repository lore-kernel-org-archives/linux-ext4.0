From: Adrian Hunter <adrian.hunter@intel.com>
Subject: EXT4 Oops (Re: [PATCH V15 06/22] mmc: block: Add blk-mq support)
Date: Thu, 1 Mar 2018 10:55:37 +0200
Message-ID: <6a1267b0-6242-fc9f-60ed-02bf34677b62@intel.com>
References: <1511962879-24262-1-git-send-email-adrian.hunter@intel.com>
 <1511962879-24262-7-git-send-email-adrian.hunter@intel.com>
 <bc65b542-9703-aa04-f1c7-b10584e44391@gmail.com>
 <829308a3-3bf6-c173-65fa-e2a0f45f7f61@intel.com>
 <68886f99-97f5-897a-f754-6f414741bd5a@gmail.com>
 <22580b82-0257-b156-9f0c-79afa34067e5@gmail.com>
 <8876217f-ede6-fc81-2e05-b4fc976b3235@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Dmitry Osipenko <digetx@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
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
        Bartlomiej Zolnierkiewicz <b.zol
To: Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <8876217f-ede6-fc81-2e05-b4fc976b3235@intel.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 27/02/18 11:28, Adrian Hunter wrote:
> On 26/02/18 23:48, Dmitry Osipenko wrote:
>> But still something is wrong... I've been getting occasional EXT4 Ooops's, like
>> the one below, and __wait_on_bit() is always figuring in the stacktrace. It
>> never happened with blk-mq disabled, though it could be a coincidence and
>> actually unrelated to blk-mq patches.
> 
> I can't think how an IO driver could cause that.
> 
> cc'ing ext4 mailing list for more advice.

+ Ted and Andreas

> 
>>
>>
>> [ 6625.992337] Unable to handle kernel NULL pointer dereference at virtual
>> address 0000001c
>> [ 6625.993004] pgd = 00b30c03
>> [ 6625.993257] [0000001c] *pgd=00000000
>> [ 6625.993594] Internal error: Oops: 5 [#1] PREEMPT SMP ARM
>> [ 6625.994022] Modules linked in:
>> [ 6625.994326] CPU: 1 PID: 19355 Comm: dpkg Not tainted
>> 4.16.0-rc2-next-20180220-00095-ge9c9f5689a84-dirty #2090
>> [ 6625.995078] Hardware name: NVIDIA Tegra SoC (Flattened Device Tree)
>> [ 6625.995595] PC is at dx_probe+0x68/0x684
>> [ 6625.995947] LR is at __wait_on_bit+0xac/0xc8
>> [ 6625.996307] pc : [<c033b960>]    lr : [<c0bfbfd4>]    psr: 800f0013
>> [ 6625.996806] sp : d55e3df0  ip : c0170e88  fp : d55e3e44
>> [ 6625.997227] r10: d55e3f4c  r9 : d55e3e70  r8 : 00000000
>> [ 6625.997650] r7 : c4e13240  r6 : 00000000  r5 : d657db18  r4 : d55e3e8c
>> [ 6625.998165] r3 : 0000007b  r2 : d5830800  r1 : d5831000  r0 : c4e13240
>> [ 6625.998686] Flags: Nzcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
>> [ 6625.999246] Control: 10c5387d  Table: 0a63004a  DAC: 00000051
>> [ 6625.999710] Process dpkg (pid: 19355, stack limit = 0x139a48b6)
>> [ 6626.000184] Stack: (0xd55e3df0 to 0xd55e4000)
>> [ 6626.000560] 3de0:                                     000002e9 d55e3e00
>> c0c01964 c0278c70
>> [ 6626.001209] 3e00: d55e3e24 014000c0 c04f3580 c0c01958 d55e3e90 801a001a
>> d55e3e3c 00000012
>> [ 6626.001854] 3e20: d5830800 00000000 d657db18 c24b0000 d55e3e70 d55e3f4c
>> d55e3edc d55e3e48
>> [ 6626.002502] 3e40: c033d568 c033b904 00000000 600f0013 c029e640 d6cf3540
>> ffffe000 00000000
>> [ 6626.003150] 3e60: 00076e99 d55e3ef4 d55e3e8c d5830800 d409c440 d409c454
>> 00000012 c029e640
>> [ 6626.003795] 3e80: d55e3ec4 d55e3e90 c02797b4 c4e13240 00000000 00000000
>> 00000000 00000000
>> [ 6626.004442] 3ea0: 00000000 00000000 00000000 00000000 d409c428 d409c428
>> d657db18 d409c428
>> [ 6626.005088] 3ec0: 00000000 c24b0000 ffffff9c d55e3f4c d55e3f14 d55e3ee0
>> c033d7b0 c033d1b8
>> [ 6626.005732] 3ee0: c0c01964 c0180050 d55e3f14 d55e3ef8 c029e870 00000000
>> d409c428 d6546558
>> [ 6626.006382] 3f00: d55e3f58 00000000 d55e3f34 d55e3f18 c0291f04 c033d764
>> 00000000 00000001
>> [ 6626.007032] 3f20: 00000000 d55e3f58 d55e3f94 d55e3f38 c0293d70 c0291ea0
>> d55e3f58 d55e3f4c
>> [ 6626.007679] 3f40: 00000000 0090abb0 d5467800 00000000 d6dd0110 d6546558
>> f3bc423c 00000012
>> [ 6626.008326] 3f60: c24b0019 80808080 00000000 015ce1b0 0090abb0 00d8d670
>> 00000028 c01011e4
>> [ 6626.008971] 3f80: d55e2000 00000000 d55e3fa4 d55e3f98 c0294544 c0293c44
>> 00000000 d55e3fa8
>> [ 6626.009620] 3fa0: c0101000 c0294530 015ce1b0 0090abb0 0090abb0 000002a8
>> 7d5a8800 7d5a8800
>> [ 6626.010264] 3fc0: 015ce1b0 0090abb0 00d8d670 00000028 0048eb80 00487344
>> 015eb160 004a6c10
>> [ 6626.010912] 3fe0: 004a6c8c bede3c0c 0048149d b6ecc6b8 600f0030 0090abb0
>> 00000000 00000000
>> [ 6626.011577] [<c033b960>] (dx_probe) from [<c033d568>]
>> (ext4_find_entry+0x3bc/0x5ac)
>> [ 6626.012198] [<c033d568>] (ext4_find_entry) from [<c033d7b0>]
>> (ext4_lookup+0x58/0x1f4)
>> [ 6626.012844] [<c033d7b0>] (ext4_lookup) from [<c0291f04>]
>> (__lookup_hash+0x70/0x9c)
>> [ 6626.013468] [<c0291f04>] (__lookup_hash) from [<c0293d70>] (do_rmdir+0x138/0x1b8)
>> [ 6626.014071] [<c0293d70>] (do_rmdir) from [<c0294544>] (SyS_rmdir+0x20/0x24)
>> [ 6626.014642] [<c0294544>] (SyS_rmdir) from [<c0101000>]
>> (ret_fast_syscall+0x0/0x54)
>> [ 6626.015231] Exception stack(0xd55e3fa8 to 0xd55e3ff0)
>> [ 6626.015656] 3fa0:                   015ce1b0 0090abb0 0090abb0 000002a8
>> 7d5a8800 7d5a8800
>> [ 6626.016302] 3fc0: 015ce1b0 0090abb0 00d8d670 00000028 0048eb80 00487344
>> 015eb160 004a6c10
>> [ 6626.035930] 3fe0: 004a6c8c bede3c0c 0048149d b6ecc6b8
>> [ 6626.055341] Code: e1a07000 e5840000 8a000078 e590601c (e5d6301c)
>> [ 6626.075632] ---[ end trace 034f3552437a92bc ]---
>>
> 
> 
