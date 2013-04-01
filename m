From: Chris Mason <chris.mason@fusionio.com>
Subject: Re: EXT4 nodelalloc => back to stone age.
Date: Mon, 1 Apr 2013 11:45:41 -0400
Message-ID: <20130401154541.16754.22860@localhost.localdomain>
References: <87d2uese6t.fsf@openvz.org> <5159A55B.1090302@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"axboe@kernel.dk" <axboe@kernel.dk>, Jan Kara <jack@suse.cz>
To: Eric Sandeen <sandeen@redhat.com>,
	Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <5159A55B.1090302@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Quoting Eric Sandeen (2013-04-01 11:18:51)
> On 4/1/13 6:06 AM, Dmitry Monakhov wrote:
> 
> > 1)Do we really have to use WRITE_SYNC in case of WB_SYNC_ALL ?

Yes?  The stuff we wait on should be WRITE_SYNC.

> 
> ...
> 
> > 2) Why don't we have writepages for non delalloc case ?
> 
> ...
> 
> I'd add:
> 
> 3) Why do we have a "nodelalloc" mount option at all?
> 
> but then I thought:
> 
> Is it also this bad when using the ext4 driver to run an ext3 fs?

Quick comparison on a single iodrive:

Ext4 (defaults):
# dd if=/dev/zero of=foo bs=1M count=1024 conv=fsync,notrunc
1073741824 bytes (1.1 GB) copied, 1.95442 s, 549 MB/s
# dd if=/dev/zero of=foo bs=1M count=1024 conv=fsync,notrunc
1073741824 bytes (1.1 GB) copied, 1.45012 s, 740 MB/s

Ext4 (nodelalloc):
dd if=/dev/zero of=foo bs=1M count=1024 conv=fsync,notrunc
1073741824 bytes (1.1 GB) copied, 2.97308 s, 361 MB/s
# dd if=/dev/zero of=foo bs=1M count=1024 conv=fsync,notrunc
1073741824 bytes (1.1 GB) copied, 1.76617 s, 608 MB/s
# dd if=/dev/zero of=foo bs=1M count=1024 conv=fsync,notrunc

XFS   gives 628, 733MB/s

Btrfs gives 659, 635MB/s -- since we're doing fsync, this includes all
the crcs for the data.

Ext3 mounted by ext4.ko: 291, 467MB/s

-chris

