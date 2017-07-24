From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: bcache with existing ext4 filesystem
Date: Mon, 24 Jul 2017 15:27:18 -0400
Message-ID: <20170724192718.t7n5zgualz5lillg@thunk.org>
References: <20170724185703.GA31422@amd>
 <64c810cf-a95c-f862-f25a-ebd7419b2632@thelounge.net>
 <20170724191548.GA32425@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Reindl Harald <h.reindl@thelounge.net>, linux-ext4@vger.kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        kent.overstreet@gmail.com, linux-bcache@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-bcache-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170724191548.GA32425@amd>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Jul 24, 2017 at 09:15:48PM +0200, Pavel Machek wrote:
> > 
> > Am 24.07.2017 um 20:57 schrieb Pavel Machek:
> > >Would it be feasible to run bcache (write-through) with existing ext4
> > >filesystem?
> > >
> > >I have 400GB of data I'd rather not move, and SSD I could use for
> > >caching. Ok, SSD is connecte over USB2, but I guess it is still way
> > >faster then seeking harddrive on random access
> > 
> > i doubt that seriously - USB2 has a terrible latency
> 
> Well.. if that's too slow, I can get SSD M.2; plus bcache docs says
> that combination works.
> 
> And... if you ever tried to do git diff while git checkout is running
> on spinning rust... spinning rust has awful parameters when idle, and
> it only gets worse when loaded :-(.

So some hard numbers.  Max throughput of USB 2.0 is 53 MiB/s[1].  In
actual practice the max throughput you will see out of the USB 2.0
interface is 30-40 MiB/s.  In contrast, a HDD doing sequential reads
can easily do much more than that.

[1] https://superuser.com/questions/317217/whats-the-maximum-typical-speed-possible-with-a-usb2-0-drive

So a lot is going to depend on how bcache works.  If you can get large
sequential reads and writes to *bypass* the cache device, then I think
there's a good cache that bcache on a USB 2.0 device won't hurt.  It
might not help as much as you like, but that's a function of the
overhead of populating the cache and whether the cache can keep the
useful bits in the cache device.

Cheers,

					- Ted
