From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH, RFC] Don't do page stablization if !CONFIG_BLKDEV_INTEGRITY
Date: Thu, 8 Mar 2012 12:20:26 -0800
Message-ID: <4F59148A.4070001@panasas.com>
References: <E1S5QTU-0005Cc-Kl@tytso-glaptop.cam.corp.google.com> <4F57F523.3020703@redhat.com> <4F581BF6.8000305@zabbo.net> <20120308155419.GB6777@thunk.org> <20120308180951.GB29510@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: Chris Mason <chris.mason@oracle.com>, "Ted Ts'o" <tytso@mit.edu>,
	Zach Brown <zab@zabbo.net>, Eric Sandeen <sandeen@redhat.com>,
	<linux-fsdevel@vger.kernel.org>, <linux-ext4@vger.kernel.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20120308180951.GB29510@shiny>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 03/08/2012 10:09 AM, Chris Mason wrote:
> 
> But, why are we writeback for a second or more?  Aren't there other
> parts of this we would want to fix as well?
> 
> I'm not against only turning on stable pages when they are needed, but
> the code that isn't the default tends to be somewhat less used.  So it
> does increase testing burden when we do want stable pages, and it tends
> to make for awkward bugs that are hard to reproduce because someone
> neglects to mention it.
> 
> IMHO it's much more important to nail down the 2 second writeback
> latency. That's not good.
> 

I think I understand this one. It's do to the sync nature introduced
by page_waiting in mkwrite.

The system is loaded everything is somewhat 2 second or more in a lag.
The 2 sec (or more) comes from the max-dirty-limit/disk-speed so any
IO you'll submit will probably be on stable disk 2 sec later. (In theory,
any power fail will loose all dirty pages which is in our case
max-dirty-limit)

Now usually that's fine because everything is queued and waits a bit
evenly distributed and you wait, theoretically, only the rate of your
IO. But here, all of a sudden, you are not allowed to be queued and you
are waiting for the head of queue to be actually done, and the app is
just frozen.

Actually now when I think of it the pages were already submitted for
them to be waited on. So the 2-sec is the depth of the block+scsi+target
queues. I guess they can be pretty deep.

I have a theory of how we can fix that 2-sec wait, by avoiding writeback of
the last n pages of an inode who's mtime is less then 2-sec. This would
solve any sequential writer wait penalty, which is Ted's case

Thanks
Boaz
