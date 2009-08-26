From: david@lang.hm
Subject: Re: [patch] ext2/3: document conditions when reliable operation is
 possible
Date: Wed, 26 Aug 2009 06:43:24 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.0908260642560.28411@asgard.lang.hm>
References: <20090824205209.GE29763@elf.ucw.cz> <4A930160.8060508@redhat.com> <20090824212518.GF29763@elf.ucw.cz> <20090824223915.GI17684@mit.edu> <20090824230036.GK29763@elf.ucw.cz> <4A932B18.1020209@redhat.com> <20090825093414.GB15563@elf.ucw.cz>
 <4A94ACDF.30405@redhat.com> <20090826111751.GC26595@elf.ucw.cz> <alpine.DEB.2.00.0908260428310.30426@asgard.lang.hm> <20090826131028.GB1370@ucw.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Rik van Riel <riel@redhat.com>, Ric Wheeler <rwheeler@redhat.com>,
	Theodore Tso <tytso@mit.edu>, Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	Rob Landley <rob@landley.net>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net, jack@suse.cz
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.lang.hm ([64.81.33.126]:42169 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757376AbZHZNob (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Aug 2009 09:44:31 -0400
In-Reply-To: <20090826131028.GB1370@ucw.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 26 Aug 2009, Pavel Machek wrote:

>>>> The metadata is just a way to get to my data, while the data
>>>> is actually important.
>>>
>>> Personally, I care about metadata consistency, and ext3 documentation
>>> suggests that journal protects its integrity. Except that it does not
>>> on broken storage devices, and you still need to run fsck there.
>>
>> as the ext3 authors have stated many times over the years, you still need
>> to run fsck periodicly anyway.
>
> Where is that documented?

linux-kernel mailing list archives.

David Lang

> I very much agree with that, but when suse10
> switched periodic fsck off, I could not find any docs to show that it
> is bad idea.
> 								Pavel
>
