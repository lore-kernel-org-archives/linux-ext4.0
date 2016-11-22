From: Wolfgang Walter <linux@stwm.de>
Subject: Re: JBD2: Spotted dirty metadata buffer....
Date: Tue, 22 Nov 2016 14:56:06 +0100
Message-ID: <4346106.R74lp01Hl2@stwm.de>
References: <1744886.OgPgGFoXj7@stwm.de> <FB4C6A4A-2A9F-4AE2-9CA2-E2C1F881A651@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <FB4C6A4A-2A9F-4AE2-9CA2-E2C1F881A651@dilger.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Am Montag, 21. November 2016, 17:49:36 schrieben Sie:
> On Nov 21, 2016, at 8:28 AM, Wolfgang Walter <linux@stwm.de> wrote:
> > Hello,
> > 
> > I'm testing EXT4 with an external journal (data=journal). When writing I
> > rather often get> 
> > 	JBD2: Spotted dirty metadata buffer (dev = dm-22, blocknr = 1008028301).
> > 	There's a risk of filesystem corruption in case of system crash.
> Can you please determine what file this block belongs to and/or what kind
> of metadata block it is.  You can check "dumpe2fs /dev/dm-22" to list all
> of the metadata blocks, and if it isn't listed as filesystem metadata, you
> can run "debugfs -c -R 'icheck 1008028301' /dev/dm-22" to find which file
> this block belongs to, then "debugfs -c -R 'ncheck <inum>' /dev/dm-22" after
> you have the inode number.

This think this is the metadata block which covers 1008028301? :

Group 30762: (Blocks 1008009216-1008041983) csum 0xb3c0 [INODE_UNINIT, ITABLE_ZEROED]
  Block bitmap at 1007681546 (bg #30752 + 10), csum 0x94b3d052
  Inode bitmap at 1007681562 (bg #30752 + 26), csum 0x00000000
  Inode table at 1007684128-1007684383 (bg #30752 + 2592)
  8340 free blocks, 4096 free inodes, 0 directories, 4096 unused inodes
  Free blocks: 1008021210-1008021211, 1008021506-1008021511, 1008021520-1008021698, 1008021749-1008021887, 1008022528
-1008022655, 1008024576-1008024768, 1008024839-1008024959, 1008026624-1008026879, 1008028524-1008035839
  Free inodes: 126001153-126005248

I'm not sure if I read it correct but 1008028301 is part of the metadata?


I checked all of the other blocks logged so far and they are all alike, they are
in between <x> and <y> of a "(Blocks <x>-<y>)" and they are above <b> of the
"Inode table at <a>-<b>". 

Another thing I found was that no block has been mentioned more then twice.
If they are mentioned twice this is within a second or so. Maybe this is simply
because they only where touched when I did the rsync.

Here is an example:

[303709.144704] JBD2: Spotted dirty metadata buffer (dev = dm-22, blocknr = 1085342550). There's a risk of filesystem corruption in case of system crash.
[303709.145561] JBD2: Spotted dirty metadata buffer (dev = dm-22, blocknr = 1085342538). There's a risk of filesystem corruption in case of system crash.
[303709.145571] JBD2: Spotted dirty metadata buffer (dev = dm-22, blocknr = 1085342527). There's a risk of filesystem corruption in case of system crash.
[303709.145579] JBD2: Spotted dirty metadata buffer (dev = dm-22, blocknr = 1085342516). There's a risk of filesystem corruption in case of system crash.
[303709.145593] JBD2: Spotted dirty metadata buffer (dev = dm-22, blocknr = 1085342504). There's a risk of filesystem corruption in case of system crash.
[303709.145604] JBD2: Spotted dirty metadata buffer (dev = dm-22, blocknr = 1085342493). There's a risk of filesystem corruption in case of system crash.
[303709.145612] JBD2: Spotted dirty metadata buffer (dev = dm-22, blocknr = 1085342482). There's a risk of filesystem corruption in case of system crash.
[303709.145625] JBD2: Spotted dirty metadata buffer (dev = dm-22, blocknr = 1085342469). There's a risk of filesystem corruption in case of system crash.
[303719.119889] JBD2: Spotted dirty metadata buffer (dev = dm-22, blocknr = 1085343261). There's a risk of filesystem corruption in case of system crash.
[303719.119896] JBD2: Spotted dirty metadata buffer (dev = dm-22, blocknr = 1085343263). There's a risk of filesystem corruption in case of system crash.
[303719.120074] JBD2: Spotted dirty metadata buffer (dev = dm-22, blocknr = 1085343328). There's a risk of filesystem corruption in case of system crash.
[303719.120079] JBD2: Spotted dirty metadata buffer (dev = dm-22, blocknr = 1085343330). There's a risk of filesystem corruption in case of system crash.
[303719.120083] JBD2: Spotted dirty metadata buffer (dev = dm-22, blocknr = 1085343332). There's a risk of filesystem corruption in case of system crash.
[303719.121607] JBD2: Spotted dirty metadata buffer (dev = dm-22, blocknr = 148936933). There's a risk of filesystem corruption in case of system crash.
[303719.121625] JBD2: Spotted dirty metadata buffer (dev = dm-22, blocknr = 148936936). There's a risk of filesystem corruption in case of system crash.
[303719.121651] JBD2: Spotted dirty metadata buffer (dev = dm-22, blocknr = 148936948). There's a risk of filesystem corruption in case of system crash.
[303719.121701] JBD2: Spotted dirty metadata buffer (dev = dm-22, blocknr = 148936962). There's a risk of filesystem corruption in case of system crash.
[303719.121814] JBD2: Spotted dirty metadata buffer (dev = dm-22, blocknr = 198776202). There's a risk of filesystem corruption in case of system crash.
[303719.121887] JBD2: Spotted dirty metadata buffer (dev = dm-22, blocknr = 198776224). There's a risk of filesystem corruption in case of system crash.
[303719.149886] JBD2: Spotted dirty metadata buffer (dev = dm-22, blocknr = 198776224). There's a risk of filesystem corruption in case of system crash.
[303719.149912] JBD2: Spotted dirty metadata buffer (dev = dm-22, blocknr = 198776202). There's a risk of filesystem corruption in case of system crash.
[303719.167924] JBD2: Spotted dirty metadata buffer (dev = dm-22, blocknr = 148936962). There's a risk of filesystem corruption in case of system crash.
[303719.167941] JBD2: Spotted dirty metadata buffer (dev = dm-22, blocknr = 148936948). There's a risk of filesystem corruption in case of system crash.
[303719.167950] JBD2: Spotted dirty metadata buffer (dev = dm-22, blocknr = 148936936). There's a risk of filesystem corruption in case of system crash.
[303719.167956] JBD2: Spotted dirty metadata buffer (dev = dm-22, blocknr = 148936933). There's a risk of filesystem corruption in case of system crash.
[303719.167999] JBD2: Spotted dirty metadata buffer (dev = dm-22, blocknr = 1085343332). There's a risk of filesystem corruption in case of system crash.
[303719.168001] JBD2: Spotted dirty metadata buffer (dev = dm-22, blocknr = 1085343330). There's a risk of filesystem corruption in case of system crash.
[303719.168004] JBD2: Spotted dirty metadata buffer (dev = dm-22, blocknr = 1085343328). There's a risk of filesystem corruption in case of system crash.
[303719.168054] JBD2: Spotted dirty metadata buffer (dev = dm-22, blocknr = 1085343263). There's a risk of filesystem corruption in case of system crash.
[303719.168056] JBD2: Spotted dirty metadata buffer (dev = dm-22, blocknr = 1085343261). There's a risk of filesystem corruption in case of system crash.


> 
> > No other message is logged. If I unmount the filesystem an do an forced
> > fsck, all seems fine.
> This is likely a bug in the code, marking a block dirty without setting
> up the journaling for it correctly.  A few bugs like this were fixed a
> while ago by Eric, but those fixes should be in 4.8.8.
> 
> > The filesystem as it's journal are on a LV (which is again backed by
> > DRBD). The journal, too.
> > 
> > I'm using stable kernel 4.8.8.
> > 
> > I created the journal with:
> > 	mkfs.ext4 -O journal_dev -v -b 4096  -L jdyn /dev/export/jdyn
> > 
> > I created the filesystem with:
> > 	mkfs.ext4 -J device=UUID=625d871f-c278-4acb-916d-774dc78dbd8a -v -b 4096
> > 	-E
> > 	stride=$((512/4)),stripe_width=$((512/4*3)),lazy_itable_init=0,nodiscard
> > 	-O inline_data,mmp -L dyn /dev/export/dyn
> It may be that inline_data is the culprit, since this is a relatively new
> feature that isn't widely used yet.
> 
> Cheers, Andreas
> 
> > I tested it also with data=writeback. I didn't see these errors then.
> > 
> > Regards,
> > --
> > Wolfgang Walter
> > Studentenwerk München
> > Anstalt des öffentlichen Rechts
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> Cheers, Andreas

Regards,
-- 
Wolfgang Walter
Studentenwerk München
Anstalt des öffentlichen Rechts
