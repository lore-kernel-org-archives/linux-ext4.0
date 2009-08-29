From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [patch] ext2/3: document conditions when reliable operation is
	possible
Date: Sat, 29 Aug 2009 12:05:58 +0200
Message-ID: <20090829100558.GH1634@ucw.cz>
References: <20090824212518.GF29763@elf.ucw.cz> <200908262253.17886.rob@landley.net> <4A967175.5070700@redhat.com> <200908271551.43840.rob@landley.net> <alpine.DEB.2.00.0908280748080.6822@asgard.lang.hm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Rob Landley <rob@landley.net>, Ric Wheeler <rwheeler@redhat.com>,
	Theodore Tso <tytso@mit.edu>, Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net
To: david@lang.hm
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0908280748080.6822@asgard.lang.hm>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri 2009-08-28 07:49:38, david@lang.hm wrote:
> On Thu, 27 Aug 2009, Rob Landley wrote:
>
>> Pavel's response was to attempt to document this.  Not that journaling is
>> _bad_, but that it doesn't protect against this class of problem.
>
> I don't think anyone is disagreeing with the statement that journaling  
> doesn't protect against this class of problems, but Pavel's statements  
> didn't say that. he stated that ext3 is more dangerous than ext2.

Well, if you use 'common' fsck policy, ext3 _is_ more dangerous.

But I'm not pushing that to documentation, I'm trying to push info
everyone agrees with. (check the patches).
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
