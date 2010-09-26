From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 01/10] Fs: ext4: acl.c: fixed indent issue
Date: Sat, 25 Sep 2010 21:53:28 -0400
Message-ID: <20100926015328.GI19690@thunk.org>
References: <1285439521-2557-1-git-send-email-tdent48227@gmail.com>
 <20100925233600.GA2854@lst.de>
 <AANLkTimf9Q=jfga=--H0VaZeWnbAVNhCPMn_G81sZ8vh@mail.gmail.com>
 <20100925235643.GA3224@lst.de>
 <20100926000154.GB5299@thunk.org>
 <1285459769.6115.74.camel@Joe-Laptop>
 <20100926003255.GA19690@thunk.org>
 <1285462243.6115.89.camel@Joe-Laptop>
 <20100926010410.GC19690@thunk.org>
 <1285464746.6115.108.camel@Joe-Laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andy Whitcroft <apw@canonical.com>, Christoph Hellwig <hch@lst.de>,
	T Dent <tdent48227@gmail.com>, adilger.kernel@dilger.ca,
	jack@suse.cz, dmonakhov@openvz.org, sandeen@redhat.com,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Joe Perches <joe@perches.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1285464746.6115.108.camel@Joe-Laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Sep 25, 2010 at 06:32:26PM -0700, Joe Perches wrote:
> On Sat, 2010-09-25 at 21:04 -0400, Ted Ts'o wrote:
> > But the stupid thing is
> > trying to do it on a file-by-file basis in the first place, when for
> > something like fs/ext4, it really should be done on a subdirectory
> > basis.
> 
> That's not true at all.

No, it *is* true.  Someone with brains, as supposed to a stupid
script, would know that fs/ext4 should be treated as a unit.  And
there *is* a F: fs/ext4 in the MAINTAINERS script.

Yet the "git-fallback" code still persisted in analyzing fs/ext4/acl.c
as a file by itself, and not as a subdirectory.  That's WRONG.  That's
not what Linus was telling you to do, if you're going to use that
e-mail of his as an excuse.

I'm glad you're now turning it off (at least by default) if there is a
MAINTAINER entry, but that code (disabled or not) is broken as it is.
You really need human intelligence to know whether to do things
file-by-file, or directory-by-directory.  And if you can't figure it
out on your own, then the script shouldn't even try, or give a huge
warning that it's madly guessing and may be totally incorrect about
who you're telling the newbie to spam with their bug report.

> > I at least never use it.
> 
> Nor are you required to.
> 
> Tool use is optional.  I don't care if you carve
> patches with a mallet onto stone tablets and send
> them by swarms of carrier pigeon to Linus so can
> reuse the stone to build an actual castle.

Yes, but the newbies don't know that they shouldn't use it, becuase it
can be wrong.  And training them not to use their God-given brains,
instead of using a stupid script, is what I'm objecting to.  That's
why I said, I'm not sure that get_maintainers.pl has an excuse for
existing.  At least checkpatch.pl has some valid uses, even if it is
occasionaly abused.  

I don't believe get_maintainers.pl does have legitmate use, since it's
really not that hard to look up something in MAINTAINERS, and if it's
not there, some real human judgement is needed, and not hueristic
guessing --- or at the very least, the script needs to warn that it's
guessing, and maybe explain to the user in detail why it's making the
guesses that it's making, so the user has a chance of understanding
why it might be completely wrong.

					- Ted
