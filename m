From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [GIT PULL] ext4 updates for 3.9
Date: Wed, 27 Feb 2013 14:29:07 -0500
Message-ID: <20130227192907.GB14253@thunk.org>
References: <20130227154450.GA23402@x4>
 <20130227170157.GA222@x4>
 <98C6DE45-F050-4AAD-82E2-7352F5BB0A5D@gmail.com>
 <20130227172256.GA236@x4>
 <7BFB2135-A1F0-4B6D-9962-16E75E5560F8@gmail.com>
 <20130227174553.GA224@x4>
 <CA+55aFwWA1jPEEQNx_5oJ6Ze=3yFb6=E9nraBfX-Ve=WjRkQMw@mail.gmail.com>
 <20130227184912.GA19624@thunk.org>
 <20130227185625.GA224@x4>
 <20130227191923.GA1121@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Dave Jones <davej@redhat.com>,
	Markus Trippelsdorf <markus@trippelsdorf.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"gnehzuil.liu" <gnehzuil.liu@gmail.com>,
	Zheng Liu <wenqing.lz@taobao.com>,
	Borislav Petkov <bp@alien8.de>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130227191923.GA1121@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Feb 27, 2013 at 02:19:23PM -0500, Dave Jones wrote:
> 
> Looks like it's fixed here too.
> 
> How did this make it through -next without anyone hitting it ?
> 
> I can't remember how many years ago I last bought a disk < 1TB,
> and I can't be alone.  Or is everyone all about SSDs these days?

I use LVM, so I have a number of volues which are smaler than 512GB,
but very few which are actually larger than 1TB.  And none on my test
boxes.  I was running the bleeding edge ext4 code on my laptop as for
dogfooding purposes, but I have an 80GB mSATA SSD and a 500GB HDD on
my X230 laptop (it requires a thin laptop drive, and 7mm drives don't
come any bigger, alas).

> Is anyone running xfstests or similar on linux-next regularly ?

I run xfstests on the ext4 tree, and I ran it on ext4 plus Linus's tip
before I submitted a pull request.  The problem is that XFSTESTS is
S-L-O-W if you use large partitions, so typically I use a 5GB
partition sizes for my test runs.  Normally we're worried about race
condition bugs, not something as bone-headed as a bitmasking problem,
so it makes sense to use a smaller disk for most of your testing.
(Some folks do their xfstests run on SSD's or tmpfs image files, again
for speed reasons, and it's unlikely they would be big enough.)

So what we probably need to do is to have a separate set of tests
using a loopback mount, and perhaps an artificially created file
system which has a large percentage of the blocks in the middle of the
file system busied out, to make efficient testing of these sorts of
bugs more efficient.  As I said, I'm thinking about how's the best way
to improve our testing regime to catch such problems the next time around.

Cheers,

   	       	       	      	       	    - Ted
