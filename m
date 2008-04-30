From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext3: Fix typos in messages and comments (journalled
	-> journaled)
Date: Wed, 30 Apr 2008 17:02:53 -0500
Message-ID: <1209592973.6113.23.camel@norville.austin.ibm.com>
References: <12095679813226-git-send-email-jack@suse.cz>
	 <12095679812375-git-send-email-jack@suse.cz>
	 <12095679812452-git-send-email-jack@suse.cz>
	 <1209567981639-git-send-email-jack@suse.cz>
	 <20080430104330.66c44d4f.akpm@linux-foundation.org>
	 <20080430212711.168bdcc0@core>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:44194 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760459AbYD3WDD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Apr 2008 18:03:03 -0400
In-Reply-To: <20080430212711.168bdcc0@core>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Wed, 2008-04-30 at 21:27 +0100, Alan Cox wrote:
> On Wed, 30 Apr 2008 10:43:30 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Wed, 30 Apr 2008 17:06:15 +0200
> > Jan Kara <jack@suse.cz> wrote:
> > 
> > > -					"EXT3-fs: Cannot change journalled "
> > > +					"EXT3-fs: Cannot change journaled "
> > 
> > hrm, who said?
> 
> This has come up several times before so I thought it might be time to
> finally dig to the bottom of the pile and end it forever.
> 
> I put on my library hat and went for a dig: the verb is in fact "to
> journalize", which according to the OED means
> 
> "enter (notes or information) in a journal"
> 
> Journal itself is strictly a noun. Thus in English it would be correct
> for a file system to have a journal (from the latin diurnalis if anyone
> cares) but it would appear that it is a journalizing file system.
> 
> The American dictionaries appear to agree with this viewpoint.
> 
> If we regard "journalizing" as incorrect then the natural way to end the
> word would be -lled for British English and -led would certainly sound
> and feel wrong. Indeed the search for the OED turns journalled into
> journal when guessing near words but refuses to consider journaled. Our
> existing policy is not to mess with US v UK v AU v CA v .. spelling
> and that is probably wise. 
> 
> A search of the ACM literature finds "journalized", "journalled" and
> "journaled" are all in use for this operation.

I hate to get into these discussions, but I've used "journaled" a lot,
so I feel I should chime in.

Maybe it's different in the UK, but I've always understood that if the
accent is not on the last syllable, then you do not double the final
vowel: offer, offered.  So if we accept the use of "journal" as a verb,
"journaled" would be correct.  

Since it's not a real word, I'd be happy not to make a big deal out of
it and accept either, so I think we're in agreement.

> I would submit the correct patch is to change the words to journalizing
> and journalized. That would put Linux in agreement with the dictionary,
> avoid US v UK meaning differences and not pose a problem linguistically
> as all forms are currently in use.

That would probably be more correct, but the use of "journal" as a verb
has really gotten ingrained in file system developers brains.  I
personally haven't heard or used "journalized" and it would take some
getting used to.

Shaggy

P.S. Evolution's spell-checker doesn't like "journalize" either, but I
trust that it's correct.
-- 
David Kleikamp
IBM Linux Technology Center

