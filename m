From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4 blocks up
Date: Mon, 2 Jul 2012 14:14:42 -0400
Message-ID: <20120702181442.GC5795@thunk.org>
References: <1341231316.2979.11.camel@sauron.fi.intel.com>
 <20120702144444.GA18074@thunk.org>
 <1341240862.2979.23.camel@sauron.fi.intel.com>
 <20120702151442.GB18074@thunk.org>
 <20120702164548.GD18074@thunk.org>
 <4FF1D22D.2070804@redhat.com>
 <20120702173104.GK6679@quack.suse.cz>
 <20120702174342.GA5795@thunk.org>
 <20120702175341.GN6679@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	Artem Bityutskiy <dedekind1@gmail.com>,
	Ext4 Mailing List <linux-ext4@vger.kernel.org>,
	Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
	Linux Kernel Maling List <linux-kernel@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120702175341.GN6679@quack.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Jul 02, 2012 at 07:53:41PM +0200, Jan Kara wrote:
> 
> > Can you send me a pointer to your patches?  Is this something that Al
>   http://www.spinics.net/lists/kernel/msg1355763.html

Ah, right.  OK, I didn't realize until I took a closer look that
xfstests #68 was testing file system freezes while running fsstress.

So Artem, what I'd suggest doing for now is to simply comment out test
#68 from your xfstests's group file and just avoid running that test
until this gets sorted. I simply hadn't noticed since for most of my
quick checks I tend to use -g quick, and -g auto more rarely (i.e.,
before I push changes to Linus, and every so often during the dev
cycle), and test #68 isn't run for -g quick, and it's only failing
about 5-10% of the time in my test configuration.

	      	       	   	      	   - Ted
