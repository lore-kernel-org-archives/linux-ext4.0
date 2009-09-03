From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [PATCH] Update Documentation/md.txt to mention journaling won't
 help dirty+degraded case.
Date: Thu, 03 Sep 2009 08:05:31 -0400
Message-ID: <4A9FB10B.60209@redhat.com>
References: <20090826001645.GN4300@elf.ucw.cz> <4A9910D5.4060208@redhat.com> <20090902201210.GC1840@ucw.cz> <200909021749.47695.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pavel Machek <pavel@ucw.cz>, david@lang.hm,
	Theodore Tso <tytso@mit.edu>, Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net
To: Rob Landley <rob@landley.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63925 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754996AbZICMFx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 3 Sep 2009 08:05:53 -0400
In-Reply-To: <200909021749.47695.rob@landley.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 09/02/2009 06:49 PM, Rob Landley wrote:
> From: Rob Landley<rob@landley.net>
>
> Add more warnings to the "Boot time assembly of degraded/dirty arrays" section,
> explaining that using a journaling filesystem can't overcome this problem.
>
> Signed-off-by: Rob Landley<rob@landley.net>
> ---
>
>   Documentation/md.txt |   17 +++++++++++++++++
>   1 file changed, 17 insertions(+)
>
> diff --git a/Documentation/md.txt b/Documentation/md.txt
> index 4edd39e..52b8450 100644
> --- a/Documentation/md.txt
> +++ b/Documentation/md.txt
> @@ -75,6 +75,23 @@ So, to boot with a root filesystem of a dirty degraded raid[56], use
>
>      md-mod.start_dirty_degraded=1
>
> +Note that Journaling filesystems do not effectively protect data in this
> +case, because the update granularity of the RAID is larger than the journal
> +was designed to expect.  Reconstructing data via partity information involes
> +matching together corresponding stripes, and updating only some of these
> +stripes renders the corresponding data in all the unmatched stripes
> +meaningless.  Thus seemingly unrelated data in other parts of the filesystem
> +(stored in the unmatched stripes) can become unreadable after a partial
> +update, but the journal is only aware of the parts it modified, not the
> +"collateral damage" elsewhere in the filesystem which was affected by those
> +changes.
> +
> +Thus successful journal replay proves nothing in this context, and even a
> +full fsck only shows whether or not the filesystem's metadata was affected.
> +(A proper solution to this problem would involve adding journaling to the RAID
> +itself, at least during degraded writes.  In the meantime, try not to allow
> +a system to shut down uncleanly with its RAID both dirty and degraded, it
> +can handle one but not both.)
>
>   Superblock formats
>   ------------------
>
>

NACK.

Now you have moved the inaccurate documentation about journalling file systems 
into the MD documentation.

Repeat after me:

(1) partial writes to a RAID stripe (with or without file systems, with or 
without journals) create an invalid stripe

(2) partial writes can be prevented in most cases by running with write cache 
disabled or working barriers

(3) fsck can (for journalling fs or non journalling fs) detect and fix your file 
system. It won't give you back the data in that stripe, but you will get the 
rest of your metadata and data back and usable.

You don't need MD in the picture to test this - take fsfuzzer or just dd and 
zero out a RAID stripe width of data from a file system. If you hit data blocks, 
your fsck (for ext2) or mount (for any journalling fs) will not see an error. If 
metadata, fsck in both cases when run will try to fix it as best as it can.

Also note that partial writes (similar to torn writes) can happen for multiple 
reasons on non-RAID systems and leave the same kind of damage.

Side note, proposing a half sketched out "fix" for partial stripe writes in 
documentation is not productive. Much better to submit a fully thought out 
proposal or actual patches to demonstrate the issue.

Rob, you should really try to take a few disks, build a working MD RAID5 group 
and test your ideas. Try it with and without the write cache enabled.

Measure and report, say after 20 power losses, how  files integrity and fsck 
repairs were impacted.

Try the same with ext2 and ext3.

Regards,

Ric

