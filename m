From: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: Bug#692104: linux-image-3.2.0-3-amd64: NULL pointer dereference
 in ext4fs
Date: Fri, 02 Nov 2012 14:33:50 +0000
Message-ID: <1351866830.13356.100.camel@deadeye.wl.decadent.org.uk>
References: <50938953.6010001@gaast.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-IYv0qRSXsQUNDmFuGO8h"
Cc: 692104@bugs.debian.org, Wilmer van der Gaast <wilmer@gaast.net>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58263 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750746Ab2KBOd7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 2 Nov 2012 10:33:59 -0400
In-Reply-To: <50938953.6010001@gaast.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--=-IYv0qRSXsQUNDmFuGO8h
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-11-02 at 09:50 +0100, Wilmer van der Gaast wrote:
[...]
> I don't know what exactly triggered this, but the result was that my /hom=
e
> was no longer accessible after this event.  My root filesystem was still
> okay.

I assume this means it was no longer accessible until the next boot.

> Marking as important because filesystem bugs could potentially cause
> corruption/data loss, although my /home seems to be fine after a fsck.
> Don't know how lucky I was.
>=20
> I've done a Google search for this crash with no results other than one
> report with a tainted kernel.
>=20
> Sadly I have no idea how this could be reproduced. A few factors:
>=20
> * My laptop was up for >60d already, with many suspend-resume cycles.
> * My /home was recently (week ago?) online-resized.
> * It's on an SSD, with trim/discards enabled. LVM and dm-crypt in between
>    the fs and the SSD.
[...]
> ** Kernel log:
> BUG: unable to handle kernel NULL pointer dereference at           (null)
> IP: [<ffffffffa0160e4b>] ext4_mb_good_group+0x39/0xcd [ext4]
> PGD 134c62067 PUD 134c1b067 PMD 0
> Oops: 0000 [#1] SMP
> CPU 1
> Modules linked in: rndis_host cdc_ether usbnet mii pl2303 nls_utf8=20
> nls_cp437 sg usb_storage uas usbhid hid btrfs crc32c libcrc32c=20
> zlib_deflate ufs qnx4 hfsplus hfs minix ntfs vfat msdos fat jfs xfs=20
> reiserfs tun iwlwifi ftdi_sio usbserial cpufreq_conservative=20
> cpufreq_userspace cpufreq_powersave cpufreq_stats parport_pc ppdev lp=20
> parport rfcomm bnep bluetooth uinput fuse nfsd nfs nfs_acl auth_rpcgss=
=20
> fscache lockd sunrpc kvm_intel kvm ext3 jbd ext2 loop=20
> snd_hda_codec_conexant snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss=
=20
> snd_mixer_oss arc4 snd_pcm snd_page_alloc snd_seq_midi=20
> snd_seq_midi_event snd_rawmidi snd_seq i915 psmouse pcspkr serio_raw=20
> coretemp iTCO_wdt evdev i2c_i801 iTCO_vendor_support snd_seq_device=20
> snd_timer thinkpad_acpi tpm_tis mac80211 ac battery acpi_cpufreq tpm=20
> power_supply tpm_bios nvram drm_kms_helper cfg80211 video snd rfkill wmi=
=20
> drm mperf i2c_algo_bit i2c_core soundcore processor button ext4 crc16=20
> jbd2 mbcache sha256_generic cryptd aes_x86_64 ae
>=20
>=20
> Pid: 12409, comm: xulrunner-stub Not tainted 3.2.0-3-amd64 #1 LENOVO=20

This is based on Linux 3.2.23.  There haven't been any subsequent fixes
to fs/ext4/mballoc.c in the 3.2.y series, though other fixes might be
relevant.

> 7465CTO/7465CTO
> RIP: 0010:[<ffffffffa0160e4b>]  [<ffffffffa0160e4b>]=20
> ext4_mb_good_group+0x39/0xcd [ext4]
> RSP: 0018:ffff8800b27798c8  EFLAGS: 00010293
> RAX: 0000000000000000 RBX: ffff88012b9888d8 RCX: 0000000000000002

This means ext4_get_group_info() returned NULL.

> RDX: ffff88013467a000 RSI: 0000000000000050 RDI: ffff880135cb2800
> RBP: 0000000000000150 R08: ffff8801191d90f0 R09: ffff8801191d90f0
> R10: ffff8801191d90f0 R11: ffff8801191d90f0 R12: 0000000000000000
> R13: 0000000000000000 R14: ffff880135cb2800 R15: 0000000000000000
> FS:  00007f6e1de8f700(0000) GS:ffff88013bc80000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000000 CR3: 0000000092f4a000 CR4: 00000000000406e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process xulrunner-stub (pid: 12409, threadinfo ffff8800b2778000, task=20
> ffff880136ea8040)
> Stack:
> ffff8801191d90f0 ffff88012b9888d8 ffff880135cb2c00 ffff880135cb2800
> 0000000000000000 0000000000000148 0000000000000150 ffffffffa0162397
> 0000000200000000 ffff880135cb2ef8 00000000ffffffff ffff880136ea8040
> Call Trace:
> [<ffffffffa0162397>] ? ext4_mb_regular_allocator+0x110/0x264 [ext4]
> [<ffffffff81036457>] ? should_resched+0x5/0x23
> [<ffffffffa016350a>] ? ext4_mb_new_blocks+0x1c2/0x403 [ext4]
> [<ffffffffa015e00f>] ? __ext4_handle_dirty_metadata+0xd7/0xe8 [ext4]
> [<ffffffffa0166eab>] ? ext4_alloc_branch+0x1ab/0x468 [ext4]
> [<ffffffffa00b5bf1>] ? jbd2_journal_stop+0x209/0x21b [jbd2]
> [<ffffffffa0167922>] ? ext4_ind_map_blocks+0x289/0x4a6 [ext4]
> [<ffffffffa013d4be>] ? ext4_da_write_end+0x1f1/0x232 [ext4]
> [<ffffffff810bd5a1>] ? release_pages+0x68/0x14d
> [<ffffffff810bd5a1>] ? release_pages+0x68/0x14d
> [<ffffffff811ad035>] ? __lookup_tag+0xb6/0x120
> [<ffffffffa013a637>] ? ext4_map_blocks+0x114/0x1f0 [ext4]
> [<ffffffff811ad7a6>] ? radix_tree_gang_lookup_tag_slot+0x77/0x98
> [<ffffffff810f363e>] ? mem_cgroup_add_lru_list+0xd/0xaa
> [<ffffffffa013d58d>] ? mpage_da_map_and_submit+0x8e/0x2f9 [ext4]
> [<ffffffffa013dadf>] ? write_cache_pages_da+0x214/0x2c5 [ext4]
> [<ffffffffa013de32>] ? ext4_da_writepages+0x2a2/0x45b [ext4]
> [<ffffffff810b4c98>] ? __filemap_fdatawrite_range+0x4b/0x50
> [<ffffffffa01365aa>] ? ext4_release_file+0x1b/0x93 [ext4]
> [<ffffffff810fa285>] ? fput+0xf9/0x1a1
> [<ffffffff810f7fde>] ? filp_close+0x62/0x6a
> [<ffffffff810f8074>] ? sys_close+0x8e/0xcb
> [<ffffffff8134fb92>] ? system_call_fastpath+0x16/0x1b
> Code: 53 48 89 fb 41 52 4c 8b 77 08 49 8b 86 b0 02 00 00 4c 89 f7 44 8b=
=20
> b8 20 03 00 00 e8 fd dc ff ff 41 83 fd 03 49 89 c4 76 02 0f 0b <48> 8b=
=20
> 00 a8 01 74 0e 89 ee 4c 89 f7 e8 18 fe ff ff 85 c0 75 69
> RIP  [<ffffffffa0160e4b>] ext4_mb_good_group+0x39/0xcd [ext4]
> RSP <ffff8800b27798c8>
> CR2: 0000000000000000
> ---[ end trace 160e5f4d37523c1f ]---
[...]

(Full bug report is at <http://bugs.debian.org/692104>.)

Ben.

--=20
Ben Hutchings
I'm always amazed by the number of people who take up solipsism because
they heard someone else explain it. - E*Borg on alt.fan.pratchett

--=-IYv0qRSXsQUNDmFuGO8h
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUJPZzue/yOyVhhEJAQrVLg//T+K4VlE+ByeFMfdy3LuPXM64h8iX76Ye
Tm3UeZxAp8uMpec73Y5X2s6C7UyfCpeeku8ZVU5U8JxxxLhUcp3jYMrc0t4Z7ZfE
36GIwfzKZmIYnILL8C7RvR01Q8cGX3CIluHobzKiMDcEu15Cwo8o8EK36mT6DYNj
j9EvV/HLPUV9xrX3LRg4wk6ivQ4oxXWG2cEAof1705jvMi/XDkD5udFM/WpmkN0f
U1l5eJ6fYIpCx/B88n1TEcMWsMeaZaXw+k9SX9zD7ucHA+4n2z2sIhARccow967G
fyBr0A2qne3CMJlcLlyR3htbZ3tbBWHsesFpdEv9pIulZFWPDvhUSWNv5oA0i+OW
miKZST8btUg8/7yzEzoOOIj28RYt/z7qGHz3OvveYB3B0e1/aP4WpkQaNA2MixEx
CvA+T/GvAj/dS9NEGyl8frJXczSEnmdR8eGdGEYsklGvV71bwwwJ2cl0xSrdWYW5
7HTH7G9oLy5HLfsULr54yKE10Ukq9FZ27722pRVHYMzX+b2q6a80gxJ9wAhE8WAx
tN2xwD+uKFfHIsRcVkjyo/E/BpuedDi/BquR+bSCv56Fl9iBDGK4znPV7ThvBFhG
cvq28dK7tSPd5zYkAh/jjep5/nzop6oFwBZ6Xl39saF9yM+7QaBuyjVOybrKUfgI
BccFSBgaKfk=
=tj9a
-----END PGP SIGNATURE-----

--=-IYv0qRSXsQUNDmFuGO8h--
