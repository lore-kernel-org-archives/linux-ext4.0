From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 01/10] Fs: ext4: acl.c: fixed indent issue
Date: Sat, 25 Sep 2010 19:03:11 -0700
Message-ID: <1285466591.6115.117.camel@Joe-Laptop>
References: <1285439521-2557-1-git-send-email-tdent48227@gmail.com>
	 <20100925233600.GA2854@lst.de>
	 <AANLkTimf9Q=jfga=--H0VaZeWnbAVNhCPMn_G81sZ8vh@mail.gmail.com>
	 <20100925235643.GA3224@lst.de> <20100926000154.GB5299@thunk.org>
	 <1285459769.6115.74.camel@Joe-Laptop> <20100926003255.GA19690@thunk.org>
	 <1285462243.6115.89.camel@Joe-Laptop> <20100926010410.GC19690@thunk.org>
	 <1285464746.6115.108.camel@Joe-Laptop>  <20100926015328.GI19690@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Andy Whitcroft <apw@canonical.com>, Christoph Hellwig <hch@lst.de>,
	T Dent <tdent48227@gmail.com>, adilger.kernel@dilger.ca,
	jack@suse.cz, dmonakhov@openvz.org, sandeen@redhat.com,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100926015328.GI19690@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, 2010-09-25 at 21:53 -0400, Ted Ts'o wrote:
> On Sat, Sep 25, 2010 at 06:32:26PM -0700, Joe Perches wrote:
> > On Sat, 2010-09-25 at 21:04 -0400, Ted Ts'o wrote:
> > > But the stupid thing is
> > > trying to do it on a file-by-file basis in the first place, when for
> > > something like fs/ext4, it really should be done on a subdirectory
> > > basis.
> > That's not true at all.
> No, it *is* true.  Someone with brains, as supposed to a stupid
> script, would know that fs/ext4 should be treated as a unit.  And
> there *is* a F: fs/ext4 in the MAINTAINERS script.

When you define "it" that way, not as any simple
file pattern match, but as a control for what
	"git log -- path"
to inspect,  it's quite feasible to use the pattern
match rather than the file name.

So, thanks, that's a good suggestion.

> I don't believe get_maintainers.pl does have legitmate use, since it's
> really not that hard to look up something in MAINTAINERS, and if it's
> not there, some real human judgement is needed, and not hueristic
> guessing --- or at the very least, the script needs to warn that it's
> guessing, and maybe explain to the user in detail why it's making the
> guesses that it's making, so the user has a chance of understanding
> why it might be completely wrong.

Multiple warning labels on tools tend to get ignored.
People that use tools without training tend to get injured.

cheers, Joe
