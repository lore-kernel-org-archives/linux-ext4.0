From: Andreas Mohr <andi@lisas.de>
Subject: Re: Noticeable usability weakness of ext4 recovery, especially
 during boot
Date: Sat, 26 Mar 2016 18:03:45 +0100
Message-ID: <20160326170345.GA11382@rhlx01.hs-esslingen.de>
References: <20160320171053.GA24115@rhlx01.hs-esslingen.de>
 <20160320215123.GC3331@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Theodore Ts'o <tytso@mit.edu>, Andreas Mohr <andi@lisas.de>,
	linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:60802 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738AbcCZRDr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 26 Mar 2016 13:03:47 -0400
Content-Disposition: inline
In-Reply-To: <20160320215123.GC3331@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

On Sun, Mar 20, 2016 at 05:51:23PM -0400, Theodore Ts'o wrote:
> On Sun, Mar 20, 2016 at 06:10:53PM +0100, Andreas Mohr wrote:
> > [   18.164828] EXT4-fs (sda2): mounting ext3 file system using the =
ext4 subsyste
> > [  248.211176] EXT4-fs (sda2): recovery complete
> > [  249.595977] EXT4-fs (sda2): mounted filesystem with ordered data=
 mode. Opts:=20
> > (null)
> >=20
> > (note the HUGE gap in dmesg timestamps above)
> >=20
> > All that *may* have been acceptable, if it were not for the fact
> > that especially during boot
> > certain activity progress is not readily visible,
> > thus there's a *lot* of confusion of what is [not] happening with t=
he system
> > (as strongly opposed to a situation where one is mounting an ext4 p=
artition
> > directly via the shell, where it's quite obvious that mount is hang=
ing
> > right at the shell prompt,
> > and diagnostic verification via dmesg etc. is readily reachable,
> > as opposed to system boot).
>=20
> I'm curious --- what kind of removable USB drive is your sda drive?

Bus 001 Device 002: ID 0951:1665 Kingston Technology=20
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0=20
  bDeviceProtocol         0=20
  bMaxPacketSize0        64
  idVendor           0x0951 Kingston Technology
  idProduct          0x1665=20
  bcdDevice            1.00
  iManufacturer           1 Kingston
  iProduct                2 DataTraveler 2.0

Case label: DTSE9 64GB
USB 2.0 stick on USB 2.0 port.


Both hdparm -i and hdparm -I did not work, interestingly:

# hdparm -i /dev/sda

/dev/sda:
SG_IO: bad/missing sense data, sb[]:  70 00 05 00 00 00 00 0a 00 00 00 =
00 20 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 HDIO_GET_IDENTITY failed: Invalid argument

# hdparm -I /dev/sda

/dev/sda:
SG_IO: bad/missing sense data, sb[]:  70 00 05 00 00 00 00 0a 00 00 00 =
00 20 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

ATA device, with non-removable media
        Model Number:       =EF=BF=BDH=EF=BF=BD=EF=BF=BD=EF=BF=BDH=EF=BF=
=BD=EF=BF=BD=EF=BF=BDH=EF=BF=BD=EF=BF=BDH=EF=BF=BD =EF=BF=BDH=EF=BF=BD@=
=EF=BF=BDH=EF=BF=BD`=EF=BF=BDH=EF=BF=BD=EF=BF=BD=EF=BF=BDH=EF=BF=BD=EF=BF=
=BD=EF=BF=BDH
        Serial Number:      =EF=BF=BD`=EF=BF=BDI=EF=BF=BD =EF=BF=BDH=EF=
=BF=BD=EF=BF=BD=EF=BF=BDH=EF=BF=BD=EF=BF=BDH=EF=BF=BD =EF=BF=BDH
        Firmware Revision:  =EF=BF=BDH=EF=BF=BD=EF=BF=BD=EF=BF=BDH=EF=BF=
=BD=EF=BF=BD
Standards:
        Likely used: 1
Configuration:
        Logical         max     current
        cylinders       0       0
        heads           0       0
        sectors/track   52736   0
        --
        bytes/track: 1021       bytes/sector: 0
        Logical/Physical Sector size:           512 bytes
        device size with M =3D 1024*1024:           0 MBytes
        device size with M =3D 1000*1000:           0 MBytes=20
        cache/buffer size  =3D unknown
Capabilities:
        IORDY not likely
        Buffer type: 9340: dual port, multi-sector with read caching ab=
ility
        Buffer size: 31396.0kB  bytes avail on r/w long: 37728
        Cannot perform double-word IO
        R/W multiple sector transfer: not supported
        DMA: not supported
        PIO: pio0



(but these hdparm queries also fail when testing another USB stick -
on that machine at least,
so I'm not certain any more whether such behaviour is expected or not -
but I did sorta expect a plain IDENTIFY to work)

Just tested second USB stick on another machine - IDENTIFY failed, too
(also with sg_ident),
so that seems "normal" behaviour.

> Normally journal replay does *not* take nearly four minutes.  It
> usually only takes at most a few seconds --- which is why we've not
> bothered to put in any kind of progress notification scheme.  (Which
> on most Linux distribution would be covered by some boot graphics
> anyway, so it would be largely wasted.)

True, from recollection
for various devices
ext* recovery is a lot faster than a standard full fsck.
Makes it all the more mysterious why it now happened that way here.


> There *is* such a progress bar system for a file system consistency
> check, which normally is what can take minutes.
>=20
> > - progress may easily not be determinable via "out of band signalli=
ng" ;)
> >   (completely silent USB stick rather than plain old metal platters=
 HDD!!)
>=20
> Ah, it's some USB stick.  I'm guessing it must be a *really* crappy
> USB stick that doesn't do random writes well at all.  Even so, though
> this is quite unusual.  This is much more normal:
>=20
> [8583.604009] sd 9:0:0:0: [sdc] Attached SCSI removable disk
> [8589.049603] EXT4-fs (sdc1): recovery complete
> [8589.055767] EXT4-fs (sdc1): mounted filesystem with ordered data mo=
de. Opts: (null)
>=20
> This is with an amazingly craptastic 1GB USB stick drive made of
> plastic which looks like it would fall apart if you twisted it
> slightly as you insert or remove it, and for which I paid less than
> $4.00 USD.  (Basically something I treat as completely disposable.  :=
-)


Hmm, yeah, it might have started to happen now
since device seems to be more in use now
(read: pristine factory status now gone, thus all blocks used,
thus it now actively needs to do erase block processing,
and if that has annoying weaknesses, then......).
So yeah, that might hint at annoyingly strong weaknesses
(annoyingly weak strongness ;)
in flash management implementation.



bonnie++ -s512 -r256 -d bonnie_test
Writing a byte at a time...done
Writing intelligently...done
Rewriting...done
Reading a byte at a time...done
Reading intelligently...done
start 'em...done...done...done...done...done...
Create files in sequential order...done.
Stat files in sequential order...done.
Delete files in sequential order...done.
Create files in random order...done.
Stat files in random order...done.
Delete files in random order...done.
Version  1.97       ------Sequential Output------ --Sequential Input- -=
-Random-
Concurrency   1     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- -=
-Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  =
/sec %CP
mint           512M   110  72  5173   3  5721   1   704  98 +++++ +++  =
91.0   1
Latency              6428ms    2545ms    2241ms   26638us      64us    =
7248us
Version  1.97       ------Sequential Create------ --------Random Create=
--------
mint                -Create-- --Read--- -Delete-- -Create-- --Read--- -=
Delete--
              files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  =
/sec %CP
                 16  1624   7 +++++ +++  3263  11  3676  19 +++++ +++ 1=
0935  49
Latency              1061us    1950us    1766us     555us     257us    =
 993us
1.97,1.97,mint,1,1458889676,512M,,110,72,5173,3,5721,1,704,98,+++++,+++=
,91.0,1,16,,,,,1624,7,+++++,+++,3263,11,3676,19,+++++,+++,10935,49,6428=
ms,2545ms,2241ms,26638us,64us,7248us,1061us,1950us,1766us,555us,257us,9=
93us



I haven't had the "opportunity" to do another reboot yet,
thus I couldn't check whether behaviour is now different.


> > Thus, the question here would be
> > which parts may need to be sufficiently improved
> > to achieve an acceptable level of usability.
> > I'd think that even simply adding a message
> > that one is about to enter a potentially longer-term operation
> > (with a details message such as "recovery")
> > rather than "standard" mount activity
> > would be sufficient,
> > both for text boot *and* GUI boot with some sufficiently accessible
> > "boot details" window.
>=20
> Well, we could, but on most devices, it's largely wasted.  Perhaps th=
e
> more interesting question is why is your USB stick so slow?  Because
> that's going to have a much larger usability issue for you...

Hmm, ok, I guess I could accept
not having a pre-recovery announcement done
if recovery is fully intended to be rather fast always.
Still, in my case status reporting then ended up sufficiently irritatin=
g,
due to rather unexpected behaviour (probably of this stick).

> Cheers,
>=20
> 							- Ted

Thank you!
(and apologies for the large delay in replying)

Andreas Mohr

--=20
GNU/Linux. It's not the software that's free, it's you.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
