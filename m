From: "NeilBrown" <neilb@suse.de>
Subject: Re: raid is dangerous but that's secret (was Re: [patch] ext2/3:
     document conditions when reliable operation is possible)
Date: Fri, 28 Aug 2009 17:31:36 +1000 (EST)
Message-ID: <ff262c08b0c3a7a9c32dabd53a4a9a27.squirrel@neil.brown.name>
References: <20090824212518.GF29763@elf.ucw.cz>
    <20090825232601.GF4300@elf.ucw.cz> <4A947682.2010204@redhat.com>
    <200908262253.17886.rob@landley.net> <4A967175.5070700@redhat.com>
    <20090827221319.GA1601@ucw.cz> <4A9733C1.2070904@redhat.com>
    <20090828064449.GA27528@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: "Ric Wheeler" <rwheeler@redhat.com>,
	"Rob Landley" <rob@landley.net>, "Theodore Tso" <tytso@mit.edu>,
	"Florian Weimer" <fweimer@bfk.de>,
	"Goswin von Brederlow" <goswin-v-b@web.de>,
	"kernel list" <linux-kernel@vger.kernel.org>,
	"Andrew Morton" <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net
To: "Pavel Machek" <pavel@ucw.cz>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20090828064449.GA27528@elf.ucw.cz>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, August 28, 2009 4:44 pm, Pavel Machek wrote:
> On Thu 2009-08-27 21:32:49, Ric Wheeler wrote:
>>>
>> If you have a specific bug in MD code, please propose a patch.
>
> Interesting. So, what's technically wrong with the patch below?
>

You mean apart from ".... that high highly undesirable ...." ??
                               ^^^^^^^^^^^

And the phrase "Regular backups when using these devices ...." should
be "Regular backups when using any devices .....".
                               ^^^
If you have a device failure near a power fail on a raid5 you might
lose some blocks of data.  If you have a device failure near (or not
near) a power failure on raid0 or jbod etc you will certainly lose lots
of blocks of data.

I think it would be better to say:

   ".... and degraded DM/MD RAID 4/5/6(*) arrays..."
             ^^^^^^^^
with
(*) If device failure causes the array to become degraded during or
immediately after the power failure, the same problem can result.

And "necessary" only have the one 'c' :-)

NeilBrown

> 									Pavel
> ---
>
> From: Theodore Tso <tytso@mit.edu>
>
> Document that many devices are too broken for filesystems to protect
> data in case of powerfail.
>
> Signed-of-by: Pavel Machek <pavel@ucw.cz>
>
> diff --git a/Documentation/filesystems/dangers.txt
> b/Documentation/filesystems/dangers.txt
> new file mode 100644
> index 0000000..2f3eec1
> --- /dev/null
> +++ b/Documentation/filesystems/dangers.txt
> @@ -0,0 +1,21 @@
> +There are storage devices that high highly undesirable properties when
> +they are disconnected or suffer power failures while writes are in
> +progress; such devices include flash devices and DM/MD RAID 4/5/6 (*)
> +arrays.  These devices have the property of potentially corrupting
> +blocks being written at the time of the power failure, and worse yet,
> +amplifying the region where blocks are corrupted such that additional
> +sectors are also damaged during the power failure.
> +
> +Users who use such storage devices are well advised take
> +countermeasures, such as the use of Uninterruptible Power Supplies,
> +and making sure the flash device is not hot-unplugged while the device
> +is being used.  Regular backups when using these devices is also a
> +Very Good Idea.
> +
> +Otherwise, file systems placed on these devices can suffer silent data
> +and file system corruption.  An forced use of fsck may detect metadata
> +corruption resulting in file system corruption, but will not suffice
> +to detect data corruption.
> +
> +(*) Degraded array or single disk failure "near" the powerfail is
> +neccessary for this property of RAID arrays to bite.
>
>
