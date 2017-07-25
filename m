From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: bcache with existing ext4 filesystem
Date: Tue, 25 Jul 2017 14:02:25 -0400
Message-ID: <20170725180225.2k3o6xtdnhygrhia@thunk.org>
References: <20170724185703.GA31422@amd>
 <64c810cf-a95c-f862-f25a-ebd7419b2632@thelounge.net>
 <20170724191548.GA32425@amd>
 <20170724192718.t7n5zgualz5lillg@thunk.org>
 <20170724200451.GA4318@amd>
 <20170725045156.kbyaxj4mmi75yyt5@thunk.org>
 <20170725134604.GA26445@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Reindl Harald <h.reindl@thelounge.net>, linux-ext4@vger.kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        kent.overstreet@gmail.com, linux-bcache@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170725134604.GA26445@amd>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jul 25, 2017 at 03:46:04PM +0200, Pavel Machek wrote:
> 
> Is there some field in ext2 superblock that changes every time
> filesystem is changed? Is mtime changed by fsck/badblocks/...?

No, there isn't.  If we were writing the superblock every time the
file system is changed it would be ***extremely*** flash unfriendly.
It would also be a scalability bottleneck, it would cause us to pay an
extra HDD seek, etc.  So it's a really bad Bad BAD idea, and so we
don't do it.

Cheers,

					- Ted
