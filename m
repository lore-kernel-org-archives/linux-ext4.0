From: Pavel Machek <pavel@ucw.cz>
Subject: Re: raid is dangerous but that's secret (was Re: [patch] ext2/3:
	document conditions when reliable operation is possible)
Date: Fri, 28 Aug 2009 08:44:49 +0200
Message-ID: <20090828064449.GA27528@elf.ucw.cz>
References: <20090824212518.GF29763@elf.ucw.cz> <20090825232601.GF4300@elf.ucw.cz> <4A947682.2010204@redhat.com> <200908262253.17886.rob@landley.net> <4A967175.5070700@redhat.com> <20090827221319.GA1601@ucw.cz> <4A9733C1.2070904@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Rob Landley <rob@landley.net>, Theodore Tso <tytso@mit.edu>,
	Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4A9733C1.2070904@redhat.com>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu 2009-08-27 21:32:49, Ric Wheeler wrote:
> On 08/27/2009 06:13 PM, Pavel Machek wrote:
>>
>>>>> Repeat experiment until you get up to something like google scale or the
>>>>> other papers on failures in national labs in the US and then we can have an
>>>>> informed discussion.
>>>>>
>>>> On google scale anvil lightning can fry your machine out of a clear sky.
>>>>
>>>> However, there are still a few non-enterprise users out there, and knowing
>>>> that specific usage patterns don't behave like they expect might be useful to
>>>> them.
>>>
>>> You are missing the broader point of both papers. They (and people like
>>> me when back at EMC) look at large numbers of machines and try to fix
>>> what actually breaks when run in the real world and causes data loss.
>>> The motherboards, S-ATA controllers, disk types are the same class of
>>> parts that I have in my desktop box today.
>> ...
>>> These errors happen extremely commonly and are what RAID deals with well.
>>>
>>> What does not happen commonly is that during the RAID rebuild (kicked
>>> off only after a drive is kicked out), you push the power button or have
>>> a second failure (power outage).
>>>
>>> We will have more users loose data if they decide to use ext2 instead of
>>> ext3 and use only single disk storage.
>>
>> So your argument basically is
>>
>> 'our abs brakes are broken, but lets not tell anyone; our car is still
>> safer than a horse'.
>>
>> and
>>
>> 'while we know our abs brakes are broken, they are not major factor in
>> accidents, so lets not tell anyone'.
>>
>> Sorry, but I'd expect slightly higher moral standards. If we can
>> document it in a way that's non-scary, and does not push people to
>> single disks (horses), please go ahead; but you have to mention that
>> md raid breaks journalling assumptions (our abs brakes really are
>> broken).
>
> You continue to ignore the technical facts that everyone (both MD and 
> ext3) people put in front of you.
>
> If you have a specific bug in MD code, please propose a patch.

Interesting. So, what's technically wrong with the patch below?

									Pavel
---

From: Theodore Tso <tytso@mit.edu>

Document that many devices are too broken for filesystems to protect
data in case of powerfail.

Signed-of-by: Pavel Machek <pavel@ucw.cz> 

diff --git a/Documentation/filesystems/dangers.txt b/Documentation/filesystems/dangers.txt
new file mode 100644
index 0000000..2f3eec1
--- /dev/null
+++ b/Documentation/filesystems/dangers.txt
@@ -0,0 +1,21 @@
+There are storage devices that high highly undesirable properties when
+they are disconnected or suffer power failures while writes are in
+progress; such devices include flash devices and DM/MD RAID 4/5/6 (*)
+arrays.  These devices have the property of potentially corrupting
+blocks being written at the time of the power failure, and worse yet,
+amplifying the region where blocks are corrupted such that additional
+sectors are also damaged during the power failure.
+        
+Users who use such storage devices are well advised take
+countermeasures, such as the use of Uninterruptible Power Supplies,
+and making sure the flash device is not hot-unplugged while the device
+is being used.  Regular backups when using these devices is also a
+Very Good Idea.
+        
+Otherwise, file systems placed on these devices can suffer silent data
+and file system corruption.  An forced use of fsck may detect metadata
+corruption resulting in file system corruption, but will not suffice
+to detect data corruption.
+
+(*) Degraded array or single disk failure "near" the powerfail is
+neccessary for this property of RAID arrays to bite.


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
