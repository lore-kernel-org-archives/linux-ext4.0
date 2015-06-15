From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [RFC] keyctl {clear,revoke} serialization with key-users
Date: Mon, 15 Jun 2015 18:51:28 +0300
Message-ID: <87ioapt1fj.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"
Cc: ext4 development <linux-ext4@vger.kernel.org>, dhowells@redhat.com
To: keyrings@linux-nfs.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:34900 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755187AbbFOPyN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 15 Jun 2015 11:54:13 -0400
Received: by lbbwc1 with SMTP id wc1so4442495lbb.2
        for <linux-ext4@vger.kernel.org>; Mon, 15 Jun 2015 08:54:12 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,
I'm not an expert in security/keyring stuff but I want to solve an
issue which originally comes from ext4 in most convenient way

Description:
ext4 now use security/key infrastructure for data encryption (keytype =3D '=
logon')
see: https://github.com/torvalds/linux/blob/master/fs/ext4/crypto_key.c
There are use-cases where key added and removed dynamically
#################
# User login and add user's key
e4crypt add_key -S /home/$USER  # analog of keyctl add $SOME_ARG
# some activity
echo test > /home/$USER/my_file
#Logout
keyctl clear @s
############
But currently there is not synchronization between 'keyctl clear' and dirty=
 page
buffers write-back, which result in data loss(because key no longer availab=
le).
There are several ways to synchronize key-management with key-usage
1) ext4 specific way via userspace
   add 'del_key' command to e4crypto which will do:
       ioctl(ext4_del_key)          # sync and invalidate all inodes which =
referees given key
       keyctl(KEYCTL_INVALIDATE,..) # wipe key from kernel
2) Generic keyring way:
   Add kernel API to register event listeners for a key so any subsystem
   may listen for such events and performs necessary actions once it happen.
   For example:
   key =3D request_key(....)
   notify_changes_key(key, event_mask, my_callback)


   keyring_clear() {
   for_each_listener{
        notify_key(callback, KEY_CLEAR)
   }
=20=20=20
First one is easy and clean also it preserves original keyring management a=
ssumptions,
but second one is more generic (since other fs will likely to implement
encryption in near future), the only visible changes of second option
is that callbacks must be synchronous so 'keyctl clear @s' may takes
long time. IMHO such implicit synchronization is good for 99% use-cases,
the only exception is 'emergency key clear' case where we do not
care about data consistency but do care about key to be wiped ASAP.

I would like to implement second option. Please rise your objections if any.




--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBCgAGBQJVfvSAAAoJELhyPTmIL6kB+gQH/3CBVSENczNF8i/cUu3VNXYz
EEoL0g6+BNCXEQbyJjKcnE8dtsTj/FA5/OkorCMXmNkRIXuWDn0cAGRru1XVGtPE
BKVthTSeiYwTW9nZa47Dwt74y2y/JwtgreulE16QnPhowEmtgNDg/L6EmrCIVJSY
Ic9wquZw0FcZSpj1eCorfg+bFft4N4z2sTPmEN5FYZpxzSbnUqG9e2jlkLbau57L
+drvrlDWDJucR/Xx6vlpWUaKa3BgnLDlKvxWie3gej1WHAvhEA+4WjOli9P5vyWE
ubDDNixbK0i4s9BEKFD4qBPje2Bq1+JPehPSBReKq/IYNv4C+v+HkRQVpvm4KfY=
=wA5I
-----END PGP SIGNATURE-----
--=-=-=--
