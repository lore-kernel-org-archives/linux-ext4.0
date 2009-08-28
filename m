From: david@lang.hm
Subject: Re: [patch] ext2/3: document conditions when reliable operation is
 possible
Date: Fri, 28 Aug 2009 07:49:38 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.0908280748080.6822@asgard.lang.hm>
References: <20090824212518.GF29763@elf.ucw.cz> <200908262253.17886.rob@landley.net> <4A967175.5070700@redhat.com> <200908271551.43840.rob@landley.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Ric Wheeler <rwheeler@redhat.com>, Pavel Machek <pavel@ucw.cz>,
	Theodore Tso <tytso@mit.edu>, Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net
To: Rob Landley <rob@landley.net>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <200908271551.43840.rob@landley.net>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 27 Aug 2009, Rob Landley wrote:

> Pavel's response was to attempt to document this.  Not that journaling is
> _bad_, but that it doesn't protect against this class of problem.

I don't think anyone is disagreeing with the statement that journaling 
doesn't protect against this class of problems, but Pavel's statements 
didn't say that. he stated that ext3 is more dangerous than ext2.

David Lang
