From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: [PATCH] xfstests: add disk failure simulation test
Date: Thu, 21 Feb 2013 22:27:22 -0500
Message-ID: <CAGpXXZKZM1Pa6hefYqq0pOyUbVvbif8KqcdC+APdUo6uxT=+LQ@mail.gmail.com>
References: <1360770097-6351-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	dchinner@redhat.com, xfs@oss.sgi.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <xfs-bounces@oss.sgi.com>
In-Reply-To: <1360770097-6351-1-git-send-email-dmonakhov@openvz.org>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
List-Id: linux-ext4.vger.kernel.org

On Wed, Feb 13, 2013 at 10:41 AM, Dmitry Monakhov <dmonakhov@openvz.org> wrote:
> There are many situations where disk may fail for example
> 1) brutal usb dongle unplug
> 2) iscsi (or any other netbdev) failure due to network issues
> In this situation filesystem which use this blockdevice is
> expected to fail(force RO remount, abort, etc) but whole system
> should still be operational. In other words:
> 1) Kernel should not panic
> 2) Memory should not leak
> 3) Data integrity operations (sync,fsync,fdatasync, directio) should fail
>    for affected filesystem
> 4) It should be possible to umount broken filesystem

Out of curiosity, does xfstest also have fault injection at the sector level?

It may be a little too aggressive, but hdparm --make-bad-sector
nnnnnnn can use a ATA long_write to write out a sector and
non-matching crc.  When the sector is then read after that, the drive
returns a media error.

At the end of the test  hdparm --repair-sector nnnnnnn will fix the
bad sector and store a valid crc.

The reason I say it is aggressive is that matched pairs of
--make-bad-sector and --repair-sector should have no long term effect
on the drive, but non-matched pairs will leave the drive with a media
error.  A normal write to that "bad" sector will force it to be
remapped to a spare sector.  I don't know of a simple way to undo that
mapping.

Greg

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
