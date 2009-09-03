From: jim owens <jowens@hp.com>
Subject: Re: [testcase] test your fs/storage stack (was Re: [patch] ext2/3:
 document conditions when reliable operation is possible)
Date: Thu, 03 Sep 2009 10:14:43 -0400
Message-ID: <4A9FCF53.10105@hp.com>
References: <20090826001645.GN4300@elf.ucw.cz> <200909021800.51096.rob@landley.net> <4A9F0F7A.1010805@hp.com> <200909022141.48827.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Ric Wheeler <rwheeler@redhat.com>, Pavel Machek <pavel@ucw.cz>,
	david@lang.hm, Theodore Tso <tytso@mit.edu>,
	Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net
To: Rob Landley <rob@landley.net>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <200909022141.48827.rob@landley.net>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Rob Landley wrote:
> I think he understands he was clueless too, that's why he investigated the 
> failure and wrote it up for posterity.
> 
>> And Ric said do not stigmatize whole classes of A) devices, B) raid,
>> and C) filesystems with "Pavel says...".
> 
> I don't care what "Pavel says", so you can leave the ad hominem at the door, 
> thanks.

See, this is exactly the problem we have with all the proposed
documentation.  The reader (you) did not get what the writer (me)
was trying to say.  That does not say either of us was wrong in
what we thought was meant, simply that we did not communicate.

What I meant was we did not want to accept Pavel's incorrect
documentation and post it in kernel docs.

> The kernel presents abstractions, such as block device nodes.  Sometimes 
> implementation details bubble through those abstractions.  Presumably, we 
> agree on that so far.

We don't have any problem with documenting abstractions.  But they
must be written as abstracts and accurate, not as IMO blogs.

It is not "he means well, so we will just accept it".  The rule
for kernel docs should be the same as for code.  If it is not
correct in all cases or causes problems, we don't accept it.

jim
