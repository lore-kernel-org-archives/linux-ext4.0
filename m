From: Ben Hutchings <ben@decadent.org.uk>
Subject: jbd2 tid wrap seen on NFS server
Date: Sat, 16 Mar 2013 05:34:22 +0000
Message-ID: <1363412062.3937.196.camel@deadeye.wl.decadent.org.uk>
References: <B2EC601CDDA242189A46599B31EA6AD3@atlassian.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-KIOyhg3QvIYnY8nxAuCT"
Cc: linux-ext4@vger.kernel.org,
	Debian kernel maintainers <debian-kernel@lists.debian.org>
To: George Barnett <gbarnett@atlassian.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46511 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751134Ab3CPFed (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 16 Mar 2013 01:34:33 -0400
In-Reply-To: <B2EC601CDDA242189A46599B31EA6AD3@atlassian.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--=-KIOyhg3QvIYnY8nxAuCT
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2013-03-16 at 16:12 +1100, George Barnett wrote:
> Hi,=20
>=20
> We use debian for a number of machines in our storage infrastructure
> and we have recently been seeing a number of "hangs". We primary
> notice this by seeing nfsd processes locking up and then a hung task
> killer going wild. We finally managed to get a trace last night - its
> pasted below:=20
>=20
> We did not see this crash under 2.6.39 back port however this kernel
> spontaneously rebooted at ~200 days uptime (we had about 3/4 of our
> infra reboot in a few weeks. It was not a good time for our ops
> teams).=20
>=20
> I would be grateful if anybody who could help me narrow this down
> would jump in and help with requests for further info, or provide
> further advice.=20

There was some discussion on the ext4 development list in December about
why this warning can appear and how that should be dealt.  It didn't
seem like this actually got resolved though.  I'm cc'ing that list in
the hope of either reviving that discussion or finding out what the fix
is.

Ben.

> [11309697.466397] ------------[ cut here ]------------=20
> [11309697.466556] WARNING: at /build/buildd-linux_3.2.23-1~bpo60+2-amd64-=
oLufer/linux-3.2.23/fs/jbd2/journal.c:507 __jbd2_log_start_commit+0x7e/0x8c=
 [jbd2]()
> [11309697.466660] Hardware name: X8DT6
> [11309697.466728] JBD2: bad log_start_commit: 2205591757 2205591757 14613=
566 0
> [11309697.466798] Modules linked in: netconsole autofs4 8021q garp bridge=
 stp nfsd nfs lockd fscache auth_rpcgss nfs_acl sunrpc bonding tcp_htcp ext=
4 jbd2 crc16 configfs loop ohci_hcd tpm_tis tpm i7core_edac i2c_i801 snd_pc=
m snd_timer snd soundcore edac_core i2c_core ioatdma tpm_bios snd_page_allo=
c coretemp crc32c_intel psmouse pcspkr joydev evdev acpi_cpufreq mperf proc=
essor serio_raw button thermal_sys ext3 jbd mbcache usbhid hid sd_mod ses e=
nclosure crc_t10dif uhci_hcd ahci libahci libata igb ehci_hcd e1000e usbcor=
e dca megaraid_sas usb_common scsi_mod [last unloaded: netconsole]
> [11309697.470190] Pid: 62, comm: kswapd0 Not tainted 3.2.0-0.bpo.3-amd64 =
#1
> [11309697.470261] Call Trace:
> [11309697.470329] [<ffffffff810498a8>] ? warn_slowpath_common+0x78/0x8c
> [11309697.470399] [<ffffffff8104995a>] ? warn_slowpath_fmt+0x45/0x4a
> [11309697.470471] [<ffffffffa01cabad>] ? __jbd2_log_start_commit+0x7e/0x8=
c [jbd2]
> [11309697.470558] [<ffffffffa01cac83>] ? jbd2_log_start_commit+0x21/0x2f =
[jbd2]
> [11309697.470634] [<ffffffffa02dee7a>] ? ext4_evict_inode+0x86/0x2d1 [ext=
4]
> [11309697.470707] [<ffffffff81119626>] ? evict+0x9a/0x14e
> [11309697.470775] [<ffffffff811198b4>] ? dispose_list+0x35/0x3f
> [11309697.470844] [<ffffffff81119b87>] ? prune_icache_sb+0x2c9/0x2d8
> [11309697.470915] [<ffffffff811081b0>] ? prune_super+0xd6/0x147
> [11309697.470987] [<ffffffff810cb9e2>] ? shrink_slab+0x1a3/0x266
> [11309697.471056] [<ffffffff810cd937>] ? balance_pgdat+0x335/0x625
> [11309697.471126] [<ffffffff810cdf31>] ? kswapd+0x30a/0x325
> [11309697.471196] [<ffffffff81063815>] ? wake_up_bit+0x20/0x20
> [11309697.471265] [<ffffffff810cdc27>] ? balance_pgdat+0x625/0x625
> [11309697.471334] [<ffffffff810cdc27>] ? balance_pgdat+0x625/0x625
> [11309697.471403] [<ffffffff810633d9>] ? kthread+0x7a/0x82
> [11309697.471472] [<ffffffff8136d3f4>] ? kernel_thread_helper+0x4/0x10
> [11309697.471543] [<ffffffff8106335f>] ? kthread_worker_fn+0x147/0x147
> [11309697.471613] [<ffffffff8136d3f0>] ? gs_change+0x13/0x13
> [11309697.471680] ---[ end trace 56d2be5ea52d0917 ]---

--=20
Ben Hutchings
It is easier to change the specification to fit the program than vice versa=
.

--=-KIOyhg3QvIYnY8nxAuCT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUUQEXue/yOyVhhEJAQpo9RAAt0Hb7vSgtIhRMXhclx8IntZWKVMeXDp/
THI9MOCSCj6TyrLgZVm75TNIlUJ/OoR10RPsjXromenYXc+txgnPSeOYc16Wiaec
JlcVxncD1TDyQRYAsnIRQAkHkmImtTdV1YVfXC4M0zCWwpy5eeWlVZss2rxggjwI
ilD2BpnqrXono33UyEjqKAcenJbY3Of9nXwDfFlWjbLMFhVdtFDj8oCVW5JH0Wvv
1dl0xkbfyLHvDLfZRx4ierRZXfIlA4NpkfS6jfEqwTtTsUXZkeCHXTWBT8/X761k
AKziMXBDoHk4Ck5wDzmi+xHclf7ZoydumOvLo7levsC+Udr0Yed1YkIyeypXQvoj
/uabCk0Pegk8EBcZEidBQhHnXJzS4SXhBluILN2g3wtHJ1XMfbY+lMnAn1FwJJ8s
ZwOtt3fDwXt4qnwpLNGWWNL8X303njo1UDxToquewS5eTeMLSVDtANo8wK0Dm949
yzrStJlGh3tFWgZN+3MgTql7rH8/P4DKuxvpF53sXbkxCcxCct1XzcbyLJCuhYHJ
GMnzYa43Hs/So+M3cr77kainWFAWTy4dDoT2WH6XaGd7qZa0nZkmcUcDfuo/dVMN
8Rys1urVLVE00TAx5gSapfjiwXvyqsmvJ0canlMo+ylHFHv2ZoOfhoVTRc+Wmaph
ty/TUAhZjG0=
=4uRF
-----END PGP SIGNATURE-----

--=-KIOyhg3QvIYnY8nxAuCT--
