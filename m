From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH, RFC] Don't do page stablization if
 !CONFIG_BLKDEV_INTEGRITY
Date: Thu, 8 Mar 2012 20:02:07 -0500
Message-ID: <20120309010207.GM29510@shiny>
References: <E1S5QTU-0005Cc-Kl@tytso-glaptop.cam.corp.google.com>
 <4F57F523.3020703@redhat.com>
 <4F581BF6.8000305@zabbo.net>
 <20120308155419.GB6777@thunk.org>
 <20120308180951.GB29510@shiny>
 <4F59148A.4070001@panasas.com>
 <20120308212412.GC11861@thunk.org>
 <20120308213808.GK29510@shiny>
 <20120308214148.GD11861@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Boaz Harrosh <bharrosh@panasas.com>, Zach Brown <zab@zabbo.net>,
	Eric Sandeen <sandeen@redhat.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120308214148.GD11861@thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Mar 08, 2012 at 04:41:48PM -0500, Ted Ts'o wrote:
> On Thu, Mar 08, 2012 at 04:38:08PM -0500, Chris Mason wrote:
> > Btrfs currently does this, and the DIF code is by definition right
> > before the write.  The pages really only get set writeback when they are
> > being sent in flight, so the waiting being done by the stable pages
> > patch is file_write or page_mkwrite being polite and waiting for the IO
> > to finish before changing the page.
> 
> Right before submission to the bio layer?  Or right before the device
> driver sends the request to the host bus adapter?  I was thinking of
> the latter....

blktrace can probably give us numbers for how big that wait is, but
hopefully it is very small.  If it is too big, you can always bump
nr_requests.

Btrfs crcs before submit_bio, not sure when the dif code does it.

-chris
