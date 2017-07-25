From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: bcache with existing ext4 filesystem
Date: Tue, 25 Jul 2017 12:10:54 -0400
Message-ID: <20170725161054.dbf6ily5jb7gjvdg@thunk.org>
References: <20170724185703.GA31422@amd>
 <64c810cf-a95c-f862-f25a-ebd7419b2632@thelounge.net>
 <20170724191548.GA32425@amd>
 <20170724192718.t7n5zgualz5lillg@thunk.org>
 <20170724200451.GA4318@amd>
 <20170725045156.kbyaxj4mmi75yyt5@thunk.org>
 <20170725064304.GA11723@amd>
 <20170725103248.GA12869@suse.com>
 <20170725111210.GA5667@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Vojtech Pavlik <vojtech@ucw.cz>,
        Reindl Harald <h.reindl@thelounge.net>,
        linux-ext4@vger.kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        kent.overstreet@gmail.com, linux-bcache@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170725111210.GA5667@amd>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jul 25, 2017 at 01:12:10PM +0200, Pavel Machek wrote:
> 
> Well... if I move the partition, grub2 (etc) will be unable to access
> data on it. (Plus I do not have free space before some of the
> partitions I'd like to be cached).

Both Grub and Linux's implementation of ext4 expect the superblock to
be at offset 1024 bytes from the beginning of the block device.

>From looking at Documentation/bcache.txt, the problem is that bcache
works much like LVM or device mapper.  That is, you have to create the
file system on /dev/bcacheN.  That simplies that grub needs to
understand bcache, which as far as I understand, it doesn't today.

      	     	  	      	 	 - Ted
