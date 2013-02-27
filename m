From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [GIT PULL] ext4 updates for 3.9
Date: Thu, 28 Feb 2013 00:58:55 +0400
Message-ID: <87k3pteank.fsf@openvz.org>
References: <20130227154450.GA23402@x4> <20130227170157.GA222@x4> <98C6DE45-F050-4AAD-82E2-7352F5BB0A5D@gmail.com> <20130227172256.GA236@x4> <7BFB2135-A1F0-4B6D-9962-16E75E5560F8@gmail.com> <20130227174553.GA224@x4> <CA+55aFwWA1jPEEQNx_5oJ6Ze=3yFb6=E9nraBfX-Ve=WjRkQMw@mail.gmail.com> <20130227184912.GA19624@thunk.org> <20130227185625.GA224@x4> <20130227191923.GA1121@redhat.com> <20130227192907.GB14253@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Ts'o <tytso@mit.edu>, Dave Jones <davej@redhat.com>,
	Markus Trippelsdorf <markus@trippelsdorf.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"gnehzuil.liu" <gnehzuil.liu@gmail.com>,
	Zheng Liu <wenqing.lz@taobao.com>,
	Borislav Petkov <bp@alien8.de>,
	"linux-ext4\@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130227192907.GB14253@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 27 Feb 2013 14:29:07 -0500, Theodore Ts'o <tytso@mit.edu> wrote:
> On Wed, Feb 27, 2013 at 02:19:23PM -0500, Dave Jones wrote:
> > 
> > Looks like it's fixed here too.
> > 
> > How did this make it through -next without anyone hitting it ?
> > 
> > I can't remember how many years ago I last bought a disk < 1TB,
> > and I can't be alone.  Or is everyone all about SSDs these days?
> 
> I use LVM, so I have a number of volues which are smaler than 512GB,
> but very few which are actually larger than 1TB.  And none on my test
> boxes.  I was running the bleeding edge ext4 code on my laptop as for
> dogfooding purposes, but I have an 80GB mSATA SSD and a 500GB HDD on
> my X230 laptop (it requires a thin laptop drive, and 7mm drives don't
> come any bigger, alas).
> 
> > Is anyone running xfstests or similar on linux-next regularly ?
> 
> I run xfstests on the ext4 tree, and I ran it on ext4 plus Linus's tip
> before I submitted a pull request.  The problem is that XFSTESTS is
> S-L-O-W if you use large partitions, so typically I use a 5GB
Indeed. That's why i give-up rotated disks and run xfstest only on SSD
or brd module 
> partition sizes for my test runs.  Normally we're worried about race
> condition bugs, not something as bone-headed as a bitmasking problem,
> so it makes sense to use a smaller disk for most of your testing.
> (Some folks do their xfstests run on SSD's or tmpfs image files, again
> for speed reasons, and it's unlikely they would be big enough.)
> 
> So what we probably need to do is to have a separate set of tests
> using a loopback mount, and perhaps an artificially created file
> system which has a large percentage of the blocks in the middle of the
> file system busied out, to make efficient testing of these sorts of
> bugs more efficient.  As I said, I'm thinking about how's the best way
> to improve our testing regime to catch such problems the next time around.
Amazing idea. Something like:

#dd if=/dev/zero of=/tmp/fs.img bs=1M seek=2000000 count=1
#mkfs.ext4 -m0 -i4096000 /tmp/fs.img
#mount /tmp/fs.img /mnt/ -oloop
#for ((i=0; i < 2000; i++));do   fallocate -l $((1024*1024*1024)) /mnt/f$i ;done
#for ((i=0; i < 2000; i++));do   truncate -s $((1023*1024*1024)) /mnt/f$i ;done

As result file system image has 2gb of free space wich is fragmented to ~2000
chunks 1Mb each. But image itself is quite small
# df /mnt
Filesystem      1K-blocks       Used Available Use% Mounted on
/dev/loop0     2047678076 2045679228   1998848 100% /mnt
# du -sch /tmp/fs.img 
242M     /tmp/fs.img
242M     total

Later we can simply run xfstest/fio/fsx on this image.
I'll prepare new xfstest based on that idea. But the only disadvantage
is that loop dev has bottleneck, all requests will be serialized on i_mutex.
> 
> Cheers,
> 
>    	       	       	      	       	    - Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
