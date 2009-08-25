From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [patch] ext2/3: document conditions when reliable operation is
	possible
Date: Tue, 25 Aug 2009 11:32:25 +0200
Message-ID: <20090825093225.GA15563@elf.ucw.cz>
References: <82k50tjw7u.fsf@mid.bfk.de> <20090824130125.GG23677@mit.edu> <20090824195159.GD29763@elf.ucw.cz> <4A92F6FC.4060907@redhat.com> <20090824205209.GE29763@elf.ucw.cz> <4A930160.8060508@redhat.com> <20090824212518.GF29763@elf.ucw.cz> <20090824223915.GI17684@mit.edu> <20090824230036.GK29763@elf.ucw.cz> <alpine.DEB.2.00.0908241655250.28411@asgard.lang.hm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>, Ric Wheeler <rwheeler@redhat.com>,
	Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	Rob Landley <rob@landley.net>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net
To: david@lang.hm
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0908241655250.28411@asgard.lang.hm>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi!

>>> Sure --- but name **any** filesystem that can deal with the fact that
>>> 128k or 256k worth of data might disappear when you pull out the flash
>>> card while it is writing a single sector?
>>
>> First... I consider myself quite competent in the os level, yet I did
>> not realize what flash does and what that means for data
>> integrity. That means we need some documentation, or maybe we should
>> refuse to mount those devices r/w or something.
>>
>> Then to answer your question... ext2. You expect to run fsck after
>> unclean shutdown, and you expect to have to solve some problems with
>> it. So the way ext2 deals with the flash media actually matches what
>> the user expects. (*)
>
> you loose data in ext2

Yes.

>> OTOH in ext3 case you expect consistent filesystem after unplug; and
>> you don't get that.
>
> the problem is that people have been preaching that journaling 
> filesystems eliminate all data loss for no cost (or at worst for minimal 
> cost).
>
> they don't, they never did.
>
> they address one specific problem (metadata inconsistancy), but they do  
> not address data loss, and never did (and for the most part the 
> filesystem developers never claimed to)

Well, in case of flashcard and degraded MD Raid5, ext3 does _not_
address metadata inconsistency problem. And that's why I'm trying to
fix the documentation. Current ext3 documentation says:

#Journaling Block Device layer
#-----------------------------
#The Journaling Block Device layer (JBD) isn't ext3 specific.  It was
#designed
#to add journaling capabilities to a block device.  The ext3 filesystem
#code
#will inform the JBD of modifications it is performing (called a
#transaction).
#The journal supports the transactions start and stop, and in case of a
#crash,
#the journal can replay the transactions to quickly put the partition
#back into
#a consistent state.

There's no mention that this does not work on flash cards and degraded
MD Raid5 arrays.
 
> people somehow have the expectation that ext3 does the data equivalent of 
> solving world hunger, it doesn't, it never did, and it never claimed
> to.

It claims so, above.

> personally I don't consider the two filesystems to be significantly  
> different in terms of the data loss potential. I think people are more  
> aware of the potentials with XFS than with ext3, but I believe that the  
> risk of loss is really about the same (and pretty much for the same  
> reasons)

Ack here.

>> Again, ext2 handles that in a way user expects it.
>>
>> At least I was teached "ext2 needs fsck after powerfail; ext3 can
>> handle powerfails just ok".
>
> you were teached wrong. the people making these claims for ext3 didn't  
> understand what ext3 does and doesn't do.

Cool. So... can we fix the documentation?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
