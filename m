From: =?ISO-8859-1?Q?Kevyn=2DAlexandre_Par=E9?=
	<kevyn.alexandre.pare@gmail.com>
Subject: Re: Unable to randomly boot rootfs (EXT3 or EXT4) from SD: MMC error
 -110 (TIMEDOUT)
Date: Tue, 27 Aug 2013 17:47:22 -0400
Message-ID: <CAL1yNc+9pOWLCLfk7WpWvvsLfb01cFCJSi+4mTvnks9VrwoF1Q@mail.gmail.com>
References: <CAL1yNcJZBSSNu4aDmL6n9uu3LkNPCOM-LbUXD2990jkPJYpLoA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: linux-omap@vger.kernel.org, linux-mmc@vger.kernel.org
Return-path: <linux-omap-owner@vger.kernel.org>
In-Reply-To: <CAL1yNcJZBSSNu4aDmL6n9uu3LkNPCOM-LbUXD2990jkPJYpLoA@mail.gmail.com>
Sender: linux-omap-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,
Another test with 3.4.59 with EXT4 and:
tune2fs -o journal_data_ordered -e panic (partition)
results in kernel panic:

[...]
Waiting for root device /dev/mmcblk0p2...
mmc0: host does not support reading read-only switch. assuming write-en=
able.
mmc0: new high speed SDXC card at address aaaa
mmcblk0: mmc0:aaaa SU64G 59.4 GiB
 mmcblk0: p1 p2
mmc1: mmc_rescan_try_freq: trying to init card at 400000 Hz
mmc1: new SDIO card at address 0001
EXT4-fs (mmcblk0p2): mounted filesystem with ordered data mode. Opts: (=
null)
VFS: Mounted root (ext4 filesystem) on device 179:2.
devtmpfs: mounted
=46reeing init memory: 220K
INIT: version 2.86 booting
mmcblk0: error -110 sending status command, retrying
mmcblk0: error -110 sending status command, retrying
mmcblk0: error -110 sending status command, aborting
end_request: I/O error, dev mmcblk0, sector 4391640
mmcblk0: error -110 sending status command, retrying
mmcblk0: error -110 sending status command, retrying
mmcblk0: error -110 sending status command, aborting
end_request: I/O error, dev mmcblk0, sector 4391640
mmcblk0: error -110 sending status command, retrying
mmcblk0: error -110 sending status command, retrying
mmcblk0: error -110 sending status command, aborting
end_request: I/O error, dev mmcblk0, sector 4391640
mmcblk0: error -110 sending status command, retrying
mmcblk0: error -110 sending status command, retrying
mmcblk0: error -110 sending status command, aborting
end_request: I/O error, dev mmcblk0, sector 4391640
mmcblk0: error -110 sending status command, retrying
mmcblk0: error -110 sending status command, retrying
mmcblk0: error -110 sending status command, aborting
end_request: I/O error, dev mmcblk0, sector 131072
Buffer I/O error on device mmcblk0p2, logical block 0
lost page write due to I/O error on mmcblk0p2
EXT4-fs error (device mmcblk0p2): ext4_find_entry:932: inode #131526:
comm rc: reading directory lblock 0
Aborting journal on device mmcblk0p2-8.
mmcblk0: error -110 sending status command, retrying
mmcblk0: error -110 sending status command, retrying
mmcblk0: error -110 sending status command, aborting
end_request: I/O error, dev mmcblk0, sector 59113472
Buffer I/O error on device mmcblk0p2, logical block 7372800
lost page write due to I/O error on mmcblk0p2
JBD2: Error -5 detected when updating journal superblock for mmcblk0p2-=
8.
mmcblk0: error -110 sending status command, retrying
mmcblk0: error -110 sending status command, retrying
mmcblk0: error -110 sending status command, aborting
end_request: I/O error, dev mmcblk0, sector 59113472
Buffer I/O error on device mmcblk0p2, logical block 7372800
lost page write due to I/O error on mmcblk0p2
JBD2: Error -5 detected when updating journal superblock for mmcblk0p2-=
8.
Kernel panic - not syncing: EXT4-fs (device mmcblk0p2): panic forced af=
ter error


If you need specific details let me know.

thx

-KA

On Sun, Jul 21, 2013 at 1:07 PM, Kevyn-Alexandre Par=E9
<kevyn.alexandre.pare@gmail.com> wrote:
> Hi,
>
> I'm trying to figure out why when randomly booting our system after i=
t =3D
> have been hard shutdown for some time (couple of minutes to couple of=
 =3D
> days) doesn't boot with MMC error?=3D20
>
> WORKAROUND:
> Rebooting the system most of the time remove the issue.
>
> I try couple of version of Kernel from stable 3.2.47 & 3.4.53 without=
 =3D
> success.
> I try to change FS from EXT3 to EXT4 without success.
> I try multiple SD..
>
> Any proposition of test that you think that is worth trying, I'm will=
ing =3D
> to try.
>
> Your opinions will really be appreciated,
>
> See below for some output of my environment,
> http://pastebin.com/qchsr1FQ
>
> Thx,
>
> -Kevyn-Alexandre Par=3DE9
> ps: My intention are to enable CONFIG_MMC_DEBUG? Try kernel 3.10.1?
--
To unsubscribe from this list: send the line "unsubscribe linux-omap" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
