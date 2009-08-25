From: david@lang.hm
Subject: Re: [patch] document flash/RAID dangers
Date: Tue, 25 Aug 2009 15:33:08 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.0908251526290.28411@asgard.lang.hm>
References: <20090824195159.GD29763@elf.ucw.cz> <4A92F6FC.4060907@redhat.com> <20090824205209.GE29763@elf.ucw.cz> <4A930160.8060508@redhat.com> <20090824212518.GF29763@elf.ucw.cz> <20090824223915.GI17684@mit.edu> <20090824230036.GK29763@elf.ucw.cz>
 <20090825000842.GM17684@mit.edu> <20090825094244.GC15563@elf.ucw.cz> <20090825161110.GP17684@mit.edu> <20090825222112.GB4300@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Theodore Tso <tytso@mit.edu>, Ric Wheeler <rwheeler@redhat.com>,
	Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	Rob Landley <rob@landley.net>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20090825222112.GB4300@elf.ucw.cz>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 26 Aug 2009, Pavel Machek wrote:

>> It seems that you are really hung up on whether or not the filesystem
>> metadata is consistent after a power failure, when I'd argue that the
>> problem with using storage devices that don't have good powerfail
>> properties have much bigger problems (such as the potential for silent
>> data corruption, or even if fsck will fix a trashed inode table with
>> ext2, massive data loss).  So instead of your suggested patch, it
>> might be better simply to have a file in Documentation/filesystems
>> that states something along the lines of:
>>
>> "There are storage devices that high highly undesirable properties
>> when they are disconnected or suffer power failures while writes are
>> in progress; such devices include flash devices and software RAID 5/6
>> arrays without journals,

is it under all conditions, or only when you have already lost redundancy?

prior discussions make me think this was only if the redundancy is already 
lost.

also, the talk about software RAID 5/6 arrays without journals will be 
confusing (after all, if you are using ext3/XFS/etc you are using a 
journal, aren't you?)

you then go on to talk about hardware raid 5/6 without battery backup. I'm 
think that you are being too specific here. any array without battery 
backup can lead to 'interesting' situations when you loose power.

in addition, even with a single drive you will loose some data on power 
loss (unless you do sync mounts with disabled write caches), full data 
journaling can help protect you from this, but the default journaling just 
protects the metadata.

David Lang
