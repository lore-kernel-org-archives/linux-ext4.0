From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4: media error but where?
Date: Fri, 4 Jul 2014 14:56:26 -0400
Message-ID: <20140704185626.GB11103@thunk.org>
References: <20140626202021.GA8512@xo-6d-61-c0.localdomain>
 <20140626203052.GA9449@xo-6d-61-c0.localdomain>
 <20140627024659.GF6826@thunk.org>
 <20140629202516.GA11430@amd.pavel.ucw.cz>
 <20140629210428.GD2162@thunk.org>
 <20140630064644.GA23079@amd.pavel.ucw.cz>
 <20140630134313.GA3753@thunk.org>
 <20140704102307.GA19252@amd.pavel.ucw.cz>
 <20140704121119.GB10514@thunk.org>
 <20140704172104.GA4877@xo-6d-61-c0.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kernel list <linux-kernel@vger.kernel.org>,
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140704172104.GA4877@xo-6d-61-c0.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jul 04, 2014 at 07:21:04PM +0200, Pavel Machek wrote:
> 
> Is it possible that my fsck is so old it does not clear this "filesystem
> had error in past" flag? Because I strongly suspect I'll boot into
> init=/bin/bash, run fsck, it will tell me "all clean", and the messages
> will repeat in the middle of fsck run.

Yes, that's what's going on.  E2fsprogs v1.41.12 does not have the
code to clear those fields in the superblock; that code was added in
v1.41.13.

(There have also been a ****huge**** number of bug fixes since May
2010, which is when 1.41.12 was released, so I'd strongly suggest that
you upgrade to a newer version of e2fsprogs.  In particular DON'T try
resizing an an ext4 file system, either on-line or off-line with a
version of e2fsprogs that ancient; there is a very good chance you
will badly corrupt the file system.)

Cheers,

					- Ted
