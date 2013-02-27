From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: EXT4 corruption on Linus latest tree.
Date: Wed, 27 Feb 2013 11:32:03 -0500
Message-ID: <20130227163203.GD5609@thunk.org>
References: <20130227154311.GA12450@redhat.com>
 <20130227155539.GA2638@pd.tnic>
 <20130227160446.GA4792@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Dave Jones <davej@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org,
	Markus Trippelsdorf <markus@trippelsdorf.de>,
	Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130227160446.GA4792@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Feb 27, 2013 at 11:04:46AM -0500, Dave Jones wrote:
>  > Hmm, more people triggering something like that:
>  > http://marc.info/?l=linux-kernel&m=136196926015305&w=2
> 
> Yeah, looks similar.  The missing files/dirs reappeared when I
> booted an older kernel, so it looks like the corruption doesn't
> hit the disk.  Fsck (1.42.5) didn't find anything either.

Thanks for the report.  I'm working to replicate and fix the problem...

       	       		    	       - Ted
