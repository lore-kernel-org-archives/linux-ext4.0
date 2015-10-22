From: Jan Kara <jack@suse.cz>
Subject: Re: Test ext4/001
Date: Thu, 22 Oct 2015 22:23:09 +0200
Message-ID: <20151022202309.GA8670@quack.suse.cz>
References: <20151022091017.GC14445@quack.suse.cz>
 <20151022192213.GP2972@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	fstests@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151022192213.GP2972@thunk.org>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu 22-10-15 15:22:13, Ted Tso wrote:
> On Thu, Oct 22, 2015 at 11:10:17AM +0200, Jan Kara wrote:
> > 
> > I've checked why test ext4/001 fails for me with DAX and after some
> > investigation I've realized that the test assumes that
> > extent_max_zeroout_kb is 32 KB and thus unwritten extent will get converted
> > to written as a whole and not split. With DAX that doesn't happen (because
> > of difference between EXT4_GET_BLOCKS_ flags passed in writeback path and
> > DAX write path) and so the result differs.
> 
> Out of curiosity, how much memory are you using to test ext4 with DAX?
> I assume you're doing something like what Matthew Wilcox documented
> at: http://patchwork.ozlabs.org/patch/491107/
> 
> I should really figure out a way to automate doing DAX regression
> testing using my scripts.

Well, I took a machine with 128GB of RAM and use 2x16GB for test disks. I
have used the trick Matthew described but setting up plain ramdisk works as
well AFAICT.

> > So I was wondering how to best fix this. Either we could switch
> > extent_max_zeroout_kb to 0 to make the result same (but that has a slight
> > disadvantage that we would lose testing of the zeroout logic) or we could
> > increase file size so that zeroout doesn't trigger or something else?
> > Anyone has some idea?
> 
> The approach I would suggest is to fork 001.out to 001.out.zeroout and
> 001.out.nozerrout, and then test to see if our output file matches
> either file.  That means we'll redirect the output to our own 001.tmp2
> file and do the check against the two possible 001.out files in the
> ext4/001 script, but the advantage of doing things that way is that is
> that will also solve a false positive we're seeing when ext4
> encryption is enabled, and for a similar reason (extent zero-out is
> disabled when encryption is enabled).

Yeah, that's an interesting idea. I'll see how to make that work in the
cleanest possible way.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
