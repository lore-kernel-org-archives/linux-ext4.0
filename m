From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RFC PATCH] coredump: avoid ext4 auto_da_alloc for core file
Date: Tue, 5 Jul 2016 12:57:15 -0400
Message-ID: <20160705165715.GH15193@thunk.org>
References: <5cdda475417b2719dced162cce89a283153cb818.1466012020.git.osandov@fb.com>
 <ae759802-f111-2c11-769e-e24e5dda4a5b@fb.com>
 <20160705143714.GG15193@thunk.org>
 <e906173a-a589-ec6a-73e0-ecf899e86b0e@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Omar Sandoval <osandov@osandov.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	kernel-team@fb.com
To: Josef Bacik <jbacik@fb.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <e906173a-a589-ec6a-73e0-ecf899e86b0e@fb.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jul 05, 2016 at 11:01:40AM -0400, Josef Bacik wrote:
> > > Omar, this probably breaks the case where we do
> > > fallocate(FALLOC_FL_KEEP_SIZE), the i_size will be 0 but there will be
> > > blocks to truncate.  Probably want to check i_blocks or something.  Thanks,
> > 
> > Sure, but this is in the coredump code; do we care there?  What are
> > the odds that someone will have fallocated blocks beyond i_size in a
> > file named "core"?  And if so, it's not like it's going to make the
> > coredump invalid or non-useful in any way.
> 
> Wow I totally didn't notice this was in coredump.c, I thought it was in ext4
> code because you said it failed regression tests, which I assumed were your
> ext4 tests.  Ignore me.  Thanks,

Yeah, Omar's original patch was something he described as a "hack" to
the coredump code.  I actually don't think it's that bad, but it does
make sense to have ext4 not enable the "replace-via-truncate" code
when the truncate is a no-op, but it turns out this is a bit tricky
because the places where we set i_size and where we decide to truncate
beyond i_size are separated.  I tried to do something simple but it
didn't quite work right; I'll look into why it didn't work hopefully
later today.

						- Ted
