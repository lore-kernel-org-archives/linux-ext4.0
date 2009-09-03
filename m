From: Rob Landley <rob@landley.net>
Subject: Re: [testcase] test your fs/storage stack (was Re: [patch] ext2/3: document conditions when reliable operation is possible)
Date: Wed, 2 Sep 2009 21:41:46 -0500
Message-ID: <200909022141.48827.rob@landley.net>
References: <20090826001645.GN4300@elf.ucw.cz> <200909021800.51096.rob@landley.net> <4A9F0F7A.1010805@hp.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Ric Wheeler <rwheeler@redhat.com>, Pavel Machek <pavel@ucw.cz>,
	david@lang.hm, Theodore Tso <tytso@mit.edu>,
	Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net
To: jim owens <jowens@hp.com>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <4A9F0F7A.1010805@hp.com>
Content-Disposition: inline
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wednesday 02 September 2009 19:36:10 jim owens wrote:
> Rob Landley wrote:
> > On Wednesday 02 September 2009 15:42:19 Ric Wheeler wrote:
> >> Totally pointless to reply to you further.
> >
> > For the record, I've been able to follow Pavel's arguments, and I've been
> > able to follow Ted's arguments.  But as far as I can tell, you're arguing
> > about a different topic than the rest of us.
>
> I had no trouble following what Ric was arguing about.
>
> Ric never said "use only the best devices and you won't have problems".
>
> Ric was arguing the exact opposite - ALL devices are crap if you define
> crap as "can loose data". 

And if you include meteor strike and flooding in your operating criteria you 
can come up with quite a straw man argument.  It still doesn't mean "X is 
highly likely to cause data loss" can never come as news to people.

> What he is saying is you need to UNDERSTAND
> your devices and their behavior and you must act accordingly.
>
> PAVEL DID NOT ACT ACCORDING TO HIS DEVICE LIMITATIONS.

Where was this limitation documented?  (Before he documented it, I mean?)

> We understand he was clueless, but user error is still user error!

I think he understands he was clueless too, that's why he investigated the 
failure and wrote it up for posterity.

> And Ric said do not stigmatize whole classes of A) devices, B) raid,
> and C) filesystems with "Pavel says...".

I don't care what "Pavel says", so you can leave the ad hominem at the door, 
thanks.

The kernel presents abstractions, such as block device nodes.  Sometimes 
implementation details bubble through those abstractions.  Presumably, we 
agree on that so far.

I was once asked to write what became Documentation/rbtree.txt, which got 
merged.  I've also read maybe half of Documentation/RCU.  Neither technique is 
specific to Linux, but this doesn't seem to have been an objection at the time.

The technique, "journaling", is widely perceived as eliminating the need for 
fsck (and thus the potential for filesystem corruption) in the case of unclean 
shutdowns.  But there are easily reproducible cases where the technique, 
"journaling", does not do this.  Thus journaling, as a concept, has 
limitations which are _not_ widely understood by the majority of people who 
purchase and use USB flash keys.

The kernel doesn't currently have any documentation on journaling theory where 
mention of journaling's limitations could go.  It does have a section on its 
internal Journaling API in Documentation/DocBook/filesystems.tmpl which links 
to two papers (both about ext3, even though reiserfs was merged first and IBM's 
JFS was implemented before either) from 1998 and 2000 respectively.  The 2000 
paper brushes against disk granularity answering a question starting at 72m, 
21s, and brushes against software raid and write ordering starting at the 72m 
32s mark.  But it never directly addresses either issue...

Sigh, I'm well into tl;dr territory here, aren't I?

Rob
-- 
Latency is more important than throughput. It's that simple. - Linus Torvalds
