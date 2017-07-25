From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: bcache with existing ext4 filesystem
Date: Tue, 25 Jul 2017 00:51:56 -0400
Message-ID: <20170725045156.kbyaxj4mmi75yyt5@thunk.org>
References: <20170724185703.GA31422@amd>
 <64c810cf-a95c-f862-f25a-ebd7419b2632@thelounge.net>
 <20170724191548.GA32425@amd>
 <20170724192718.t7n5zgualz5lillg@thunk.org>
 <20170724200451.GA4318@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Reindl Harald <h.reindl@thelounge.net>, linux-ext4@vger.kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        kent.overstreet@gmail.com, linux-bcache@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-bcache-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170724200451.GA4318@amd>
Sender: linux-bcache-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Jul 24, 2017 at 10:04:51PM +0200, Pavel Machek wrote:
> Question for you was... Is the first 1KiB of each ext4 filesystem still
> free and "reserved for a bootloader"?

Yes.

> If I needed more for bcache superblock (8KiB, IIRC), would that be
> easy to accomplish on existing filesystem?

Huh?  Why would the bcache superblock matter when you're talking about
the ext4 layout?  The bcache superblock will be on the bcache
device/partition, and the ext4 superblock will be on the ext4
device/partition.

						- Ted
