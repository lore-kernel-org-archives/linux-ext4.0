From: "Donatas G." <dgvirtual@akl.lt>
Subject: Cannot delete a file - could it be ext3 related?
Date: Wed, 25 Apr 2007 11:54:27 +0300
Message-ID: <200704251154.27840.dgvirtual@akl.lt>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_DdxLGmcPb15Ok0z"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bona.tic.lt ([195.182.64.209]:50003 "EHLO bona.tic.lt"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423334AbXDYJNK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 25 Apr 2007 05:13:10 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

--Boundary-00=_DdxLGmcPb15Ok0z
Content-Type: text/plain;
  charset="iso-8859-13"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

I have a problem with system upgrade (Kubuntu Edgy to Feisty) which is caus=
ed=20
by the systems inability to remove a corrupted file. I suspect this could b=
e=20
filesystem related, so I am writing to this list.=20

Since I am not subscribed, COULD YOU SEND ME RESPONCES DIRECTLY?

I ran fsck /dev/hda5 (my partition) to no avail - the filesystem used to=20
contain errors, but they are all corrected before this upgrade.

Here is the story:

## trying to remove the showstopper package:
dg@bala:/var/lib/dpkg/info$ sudo apt-get remove libidn11-dev
=2E..
dpkg: error processing libidn11-dev (--remove):
 Package is in a very bad inconsistent state - you should
 reinstall it before attempting a removal.
terminate called after throwing an instance of 'std::logic_error'
  what():  basic_string::_S_construct NULL not valid
Aborted
dg@bala:/var/lib/dpkg/info$ Errors were encountered while processing:
 libidn11-dev

## trying to update the showstopper package:
dg@bala:/var/lib/dpkg/info$ sudo apt-get install libidn11-dev
=2E.......
Preparing to replace libidn11-dev 0.6.3-1=20
(using .../libidn11-dev_0.6.5-1build1_i386.deb) ...
Unpacking replacement libidn11-dev ...
dpkg: error=20
processing /cdrom//pool/main/libi/libidn/libidn11-dev_0.6.5-1build1_i386.de=
b=20
(--unpack):
 unable to install (supposed) new info file `/var/lib/dpkg/tmp.ci/postinst'=
:=20
Operation not permitted
Errors were encountered while processing:
 /cdrom//pool/main/libi/libidn/libidn11-dev_0.6.5-1build1_i386.deb
E: Sub-process /usr/bin/dpkg returned an error code (1)

## trying to remove the showstopper package:
dg@bala:/var/lib/dpkg/info$ ls -lo libidn11-dev.postinst
=2Drwxr-xr-x 1 root 36864 2007-04-25 09:09 libidn11-dev.postinst
## the date is new because=20
## dg@bala:/var/lib/dpkg/info$ sudo touch libidn11-dev.postinst
command was the only one that did work on this file :)

## trying to chmod the file
dg@bala:/var/lib/dpkg/info$ sudo chmod 777 ./libidn11-dev.postinst
chmod: kei=E8iamos `./libidn11-dev.postinst' teis=EBs: Operation not permit=
ted

## Trying to force remove the file...
dg@bala:/var/lib/dpkg/info$ sudo rm -f libidn11-dev.postinst
rm: cannot remove `libidn11-dev.postinst': Operation not permitted

I am forwarding the contents of the file: kate editor describes it as a=20
binary, it contains a short bash script with all kinds of junk (including m=
y=20
mail addresses and headers) at the end...

Google did not help me. Could someone explain what is happening?

=2D-=20
Donatas Glodenis
http://dg.lapas.info

--Boundary-00=_DdxLGmcPb15Ok0z
Content-Type: application/x-gzip;
  name="libidn11-dev.postinst.gz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="libidn11-dev.postinst.gz"

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
w5l7evf/P2bNRjEAkAAA

--Boundary-00=_DdxLGmcPb15Ok0z--
