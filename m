From: Mike Fedyk <mfedyk@mikefedyk.com>
Subject: Re: [Regression] Filesystem I/O is CPU-bound in rc7 and rc8
Date: Fri, 19 Feb 2010 13:22:45 -0800
Message-ID: <93cdabd21002191322g7ea13d8bk52f1545df913f07@mail.gmail.com>
References: <m3pr48bjfg.fsf@lugabout.jhcloos.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
	jfs-discussion@lists.sourceforge.net
To: James Cloos <cloos@jhcloos.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <m3pr48bjfg.fsf@lugabout.jhcloos.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Feb 13, 2010 at 7:11 PM, James Cloos <cloos@jhcloos.com> wrote:
> Sometime between rc6 and rc7 all filesystem I/O started using 100% CP=
U,
> usually on the order of 60% sys, 40% user.
>
> I've tried this with each of ext4, jfs and btrfs filesystems. =C2=A0A=
ll show
> the same issue.
>

Are you sure you're not running with any of the debugging options
enabled?  I see the same, but I have debugging enabled (rawhide
kernel).

> Using dd(1) to read from the block specials directly works as well an=
d
> as fast as it always has; only reading or writing to mounted filesyst=
ems
> is affected.
>
> Box is 32-bit x86, PentiumIII-M; drives are ide using libata.
>
> If the btrfs fs is mounted, the slowdown is enought to trigger the
> hung_task call trace (120s) on the btrfs-transac process.
>
> But the regression is just as apparent when only jfs and ext4 are mou=
nted.
>
> The only filesystems I've found which avoid the regression are tmpfs =
and
> devtmpfs.
>
> I didn't have time to write up a report when I noticed this in rc7 bu=
t
> had to boot back into rc6 for work.
>
> Some of the commits since rc7 looked like they might have addressed t=
his
> regression, but it persists in rc8.
>
> -JimC
> --
> James Cloos <cloos@jhcloos.com> =C2=A0 =C2=A0 =C2=A0 =C2=A0 OpenPGP: =
1024D/ED7DAEA6
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
