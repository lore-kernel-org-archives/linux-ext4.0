From: Wolfgang Walter <linux@stwm.de>
Subject: Re: JBD2: Spotted dirty metadata buffer....
Date: Wed, 06 Sep 2017 14:46:48 +0200
Message-ID: <14919146.PgSzFZYKi6@stwm.de>
References: <1744886.OgPgGFoXj7@stwm.de> <6EBBE85C-8A87-4D8B-9897-3D67D4B6D732@dilger.ca> <10283498.RxsF1TCk0q@stwm.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <10283498.RxsF1TCk0q@stwm.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Am Montag, 28. November 2016, 12:26:38 schrieb Wolfgang Walter:
> Am Mittwoch, 23. November 2016, 16:40:07 schrieb Andreas Dilger:
> > On Nov 23, 2016, at 3:43 AM, Wolfgang Walter <linux@stwm.de> wrote:
> > > Am Dienstag, 22. November 2016, 16:02:53 schrieben Sie:
> > >> On Nov 22, 2016, at 6:56 AM, Wolfgang Walter <linux@stwm.de> wrote:
> > >>> Am Montag, 21. November 2016, 17:49:36 schrieben Sie:
> > >>>> On Nov 21, 2016, at 8:28 AM, Wolfgang Walter <linux@stwm.de> wrote:
> > >>>>> Hello,
> 
> [snip]
> 
> > Stepping back a bit - does this problem only happen with an external
> > journal device, or does it also happen with an internal journal?
> > 
> 
> So I tried that this weekend. I got again these messages 
> 
> JBD2: Spotted dirty metadata buffer (dev = dm-22, blocknr = 241763277). There's a risk of filesystem corruption in case of system crash.
> 
> So this also happens with an internal journal.
> 

[snip]

I last tried with 4.9.46 and I still see that problem when rsyncing data to the filesystem: errors similar to

JBD2: Spotted dirty metadata buffer (dev = dm-25, blocknr = 1008028301). There's a risk of filesystem corruption in case of system 

A later filesystem check does not show any errors.


With 4.9.46 stable kernels I also sometimes get the following error:

EXT4-fs error (device dm-25): ext4_iget:4501: inode #74061557: comm rsync: checksum invalid
or
EXT4-fs error (device dm-25): ext4_iget:4501: inode #155844677: comm nfsd: checksum invalid

A filesystem check then says that the inode itselfs seems ok but the checksum is indeed wrong.

As these inodes are inodes of very small files.

So I finally copied all away and reinitialized the filesystem. But this time without -O inline_data

Since then all works fine. So I assume there is a proplem with inodes and inline-data (at least until 4.9.46), maybe only with data=journal.

Regards,
-- 
Wolfgang Walter
Studentenwerk München
Anstalt des öffentlichen Rechts
