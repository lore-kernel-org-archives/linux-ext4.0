From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: raid is dangerous but that's secret (was Re: [patch] ext2/3:
 document conditions when reliable operation is possible)
Date: Fri, 28 Aug 2009 07:16:46 -0400
Message-ID: <4A97BC9E.5070801@redhat.com>
References: <20090824212518.GF29763@elf.ucw.cz> <20090825232601.GF4300@elf.ucw.cz> <4A947682.2010204@redhat.com> <200908262253.17886.rob@landley.net> <4A967175.5070700@redhat.com> <20090827221319.GA1601@ucw.cz> <4A9733C1.2070904@redhat.com> <20090828064449.GA27528@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Rob Landley <rob@landley.net>, Theodore Tso <tytso@mit.edu>,
	Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752195AbZH1LRL@vger.kernel.org>
In-Reply-To: <20090828064449.GA27528@elf.ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 08/28/2009 02:44 AM, Pavel Machek wrote:
> On Thu 2009-08-27 21:32:49, Ric Wheeler wrote:
>> On 08/27/2009 06:13 PM, Pavel Machek wrote:
>>>
>>>>>> Repeat experiment until you get up to something like google scale or the
>>>>>> other papers on failures in national labs in the US and then we can have an
>>>>>> informed discussion.
>>>>>>
>>>>> On google scale anvil lightning can fry your machine out of a clear sky.
>>>>>
>>>>> However, there are still a few non-enterprise users out there, and knowing
>>>>> that specific usage patterns don't behave like they expect might be useful to
>>>>> them.
>>>>
>>>> You are missing the broader point of both papers. They (and people like
>>>> me when back at EMC) look at large numbers of machines and try to fix
>>>> what actually breaks when run in the real world and causes data loss.
>>>> The motherboards, S-ATA controllers, disk types are the same class of
>>>> parts that I have in my desktop box today.
>>> ...
>>>> These errors happen extremely commonly and are what RAID deals with well.
>>>>
>>>> What does not happen commonly is that during the RAID rebuild (kicked
>>>> off only after a drive is kicked out), you push the power button or have
>>>> a second failure (power outage).
>>>>
>>>> We will have more users loose data if they decide to use ext2 instead of
>>>> ext3 and use only single disk storage.
>>>
>>> So your argument basically is
>>>
>>> 'our abs brakes are broken, but lets not tell anyone; our car is still
>>> safer than a horse'.
>>>
>>> and
>>>
>>> 'while we know our abs brakes are broken, they are not major factor in
>>> accidents, so lets not tell anyone'.
>>>
>>> Sorry, but I'd expect slightly higher moral standards. If we can
>>> document it in a way that's non-scary, and does not push people to
>>> single disks (horses), please go ahead; but you have to mention that
>>> md raid breaks journalling assumptions (our abs brakes really are
>>> broken).
>>
>> You continue to ignore the technical facts that everyone (both MD and
>> ext3) people put in front of you.
>>
>> If you have a specific bug in MD code, please propose a patch.
>
> Interesting. So, what's technically wrong with the patch below?
>
> 									Pavel


My suggestion was that you stop trying to document your assertion of an issue 
and actually suggest fixes in code or implementation. I really don't think that 
you have properly diagnosed your specific failure or done sufficient. However, 
if you put a full analysis and suggested code out to the MD devel lists, we can 
debate technical implementation as we normally do.

As Ted quite clearly stated, documentation on how RAID works, how to configure 
it, etc, is best put in RAID documentation.  What you claim as a key issue is an 
issue for all file systems (including ext2).

The only note that I would put in ext3/4 etc documentation would be:

"Reliable storage is important for any file system. Single disks (or FLASH or 
SSD) do fail on a regular basis.

To reduce your risk of data loss, it is advisable to use RAID which can overcome 
these common issues. If using MD software RAID, see the RAID documentation on 
how best to configure your storage.

With or without RAID, it is always important to back up your data to an external 
device and keep copies of that backup off site."

ric



> ---
>
> From: Theodore Tso<tytso@mit.edu>
>
> Document that many devices are too broken for filesystems to protect
> data in case of powerfail.
>
> Signed-of-by: Pavel Machek<pavel@ucw.cz>
>
> diff --git a/Documentation/filesystems/dangers.txt b/Documentation/filesystems/dangers.txt
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
