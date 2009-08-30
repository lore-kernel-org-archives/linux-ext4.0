From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [testcase] test your fs/storage stack (was Re: [patch] ext2/3:
	document conditions when reliable operation is possible)
Date: Sun, 30 Aug 2009 09:07:49 +0200
Message-ID: <20090830070749.GA1576@ucw.cz>
References: <20090826001645.GN4300@elf.ucw.cz> <4A948259.40007@redhat.com> <20090826010018.GA17684@mit.edu> <4A948C94.7040103@redhat.com> <20090826025849.GF32712@mit.edu> <4A9510D2.1090704@redhat.com> <20090826111208.GA26595@elf.ucw.cz> <alpine.DEB.2.00.0908260416270.30426@asgard.lang.hm> <20090829094919.GF1634@ucw.cz> <alpine.DEB.2.00.0908290931260.6822@asgard.lang.hm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ric Wheeler <rwheeler@redhat.com>, Theodore Tso <tytso@mit.edu>,
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
In-Reply-To: <alpine.DEB.2.00.0908290931260.6822@asgard.lang.hm>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi!

>>> for flash drives the danger is very straightforward (although even then
>>> you have to note that it depends heavily on the firmware of the device,
>>> some will loose lots of data, some won't loose any)
>>
>> I have not seen one that works :-(.
>
> so let's get broader testing (including testing the SSDs as well as the  
> thumb drives)

If someone can do ssd test -- yes that would be interesting.

>> Anyway, you wanted a test, and one is attached. It normally takes like
>> 4 unplugs to uncover problems.
>
> Ok, help me understand this.
>
> I copy these two files to a system, change them to point at the correct  
> device, run them and unplug the drive while it's running.

Yep.

> when I plug the device back in, how do I tell if it lost something  
> unexpected? since you are writing from urandom I have no idea what data  
> _should_ be on the drive, so how can I detect that a data block has been  
> corrupted?

I have mirror on disk you are not unplugging. See cmp || exit lines.

The test continues until it detects corruption.
								Pavel


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
