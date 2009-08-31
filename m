From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: raid is dangerous but that's secret (was Re: [patch] ext2/3:
 	document conditions when reliable operation is possible)
Date: Mon, 31 Aug 2009 14:01:06 -0400
Message-ID: <4A9C0FE2.8020607@redhat.com>
References: <20090824212518.GF29763@elf.ucw.cz> <4A947682.2010204@redhat.com>	 <200908262253.17886.rob@landley.net> <4A967175.5070700@redhat.com>	 <20090827221319.GA1601@ucw.cz> <4A9733C1.2070904@redhat.com>	 <20090828064449.GA27528@elf.ucw.cz> <20090828120854.GA8153@mit.edu>	 <20090830075135.GA1874@ucw.cz> <20090830152023.GB23828@mit.edu> <4807377b0908311049id9a2167r937bc8447c2b3546@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, Pavel Machek <pavel@ucw.cz>,
	NeilBrown <neilb@suse.de>, Rob Landley <rob@landley.net>,
	Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net
To: Jesse Brandeburg <jesse.brandeburg@gmail.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753778AbZHaSAW@vger.kernel.org>
In-Reply-To: <4807377b0908311049id9a2167r937bc8447c2b3546@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 08/31/2009 01:49 PM, Jesse Brandeburg wrote:
> On Sun, Aug 30, 2009 at 8:20 AM, Theodore Tso<tytso@mit.edu>  wrote:
>> So we *do* have the warning light; the problem is that just as some
>> people may not realize that "check brakes" means, "YOU COULD DIE",
>> some people may not realize that "hard drive failure; RAID array
>> degraded" could mean, "YOU COULD LOSE DATA".
>>
>> Fortunately, for software RAID, this is easily solved; if you are so
>> concerned, why don't you submit a patch to mdadm adjusting the e-mail
>> sent to the system administrator when the array is in a degraded
>> state, such that it states, "YOU COULD LOSE DATA".  I would gently
>> suggest to you this would be ***far*** more effective that a patch to
>> kernel documentation.
>
> In the case of a degraded array, could the kernel be more proactive
> (or maybe even mdadm) and have the filesystem remount itself withOUT
> journalling enabled?  This seems on the surface to be possible, but I
> don't know the internal particulars that might prevent/allow it.

This a misconception - with or without journalling, you are open to a second 
failure during a RAID rebuild.

Also note that by default, ext3 does not mount with barriers turned on.

Even if you mount with barriers, MD5 does not handle barriers, so you stand to 
lose a lot of data if you have a power outage.

Ric
