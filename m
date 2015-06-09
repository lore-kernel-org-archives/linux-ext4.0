From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2 0/8] Introduce strreplace
Date: Mon, 8 Jun 2015 20:55:54 -0400
Message-ID: <20150609005554.GP19168@thunk.org>
References: <1433806017-10823-1-git-send-email-linux@rasmusvillemoes.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Neil Brown <neilb@suse.de>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ingo Molnar <mingo@redhat.com>, Joe Perches <joe@perches.com>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1433806017-10823-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jun 09, 2015 at 01:26:48AM +0200, Rasmus Villemoes wrote:
> Doing single-character substitution on an entire string is open-coded
> in a few places, sometimes in a rather suboptimal way. This introduces
> a trivial helper, strreplace, for this task along with a few example
> conversions.
> 
> Andrew, can I get you to take 1/8 through the mm tree? I'm not sure
> what the easiest path is for the remaining patches.

This is not super urgent, right?  So we could let 1/8 go into
mainline, and then the rest of the patches could go in the next
release.  That would be the simplest, although it would drag out how
long it would take for strreplace to be used everywhere.

     	      	       		     	     - Ted
