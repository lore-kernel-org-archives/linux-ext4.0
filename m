From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: v4.16-rc2: virtio-block + ext4 lockdep splats / sleeping from
 invalid context
Date: Tue, 27 Feb 2018 12:03:59 +0000
Message-ID: <20180227120358.6x5pnhgv7o2z62iz@lakrids.cambridge.arm.com>
References: <20180223154735.x4ezmpjbjm6o6duw@lakrids.cambridge.arm.com>
 <20180226105256.jagidoki6vsrvzb4@quack2.suse.cz>
 <20180226113818.v544mmjsavc4x5q2@lakrids.cambridge.arm.com>
 <20180226124455.rkp3xfn3cqplzh4p@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-ext4@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180226124455.rkp3xfn3cqplzh4p@quack2.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Feb 26, 2018 at 01:44:55PM +0100, Jan Kara wrote:
> On Mon 26-02-18 11:38:19, Mark Rutland wrote:
> > That seems to be it!
> > 
> > With the below patch applied, I can't trigger the bug after ~10 minutes,
> > whereas prior to the patch I can trigger it in ~10 seconds. I'll leave
> > that running for a while just in case there's another part to the
> > problem, but FWIW:
> > 
> > Tested-by: Mark Rutland <mark.rutland@arm.com>
> 
> Thanks for testing! Sent the patch to Jens for inclusion.

Cheers!

FWIW, I left my test case running for a day with no issue, so this looks
rock solid.

Mark.
