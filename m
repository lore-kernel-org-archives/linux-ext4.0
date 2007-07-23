From: Karsten Hopp <karsten@redhat.com>
Subject: Re: Patch to support LUKS UUIDs in libblkid
Date: Mon, 23 Jul 2007 17:00:02 +0200
Message-ID: <46A4C272.3040907@redhat.com>
References: <4665479E.2060707@redhat.com> <20070608153600.GA9726@thunk.org> <466D373C.6000502@redhat.com> <20070612234004.GA12189@thunk.org> <466FCE52.4000605@redhat.com> <20070621175618.GA22285@thunk.org> <46964694.7000707@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:43289 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754657AbXGWPAK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Jul 2007 11:00:10 -0400
In-Reply-To: <46964694.7000707@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Theodore Tso schrieb:
> Thanks, I've applied the blkid LUKS patch to the e2fsprogs SCM (modulo
> a minor whitespace breakage which I fixed up).
>

  I've encountered a problem with this patch, consider the following
  setup:

  in /etc/fstab:
  UUID=<some LUKS uuid>  / ext3 defaults 0 0

  During bootup the init scripts run 'fsck -A', fsck reads in /etc/fstab and
  converts the LUKS-uuid to a device name. It then uses this devicename to
  populate filesys_info and sets the type to ext3 (from fstab). It then tries to check
  the underlying device instead of the /dev/mapper/ LUKS device.

  I'm not sure how to work around this, adding crypt_luks to ignored_types won't work
  because fsck thinks the device has an ext3 FS.
  Is create_fs_device() the right place to add a check if this is a LUKS device or would it be better
  to do that in parse_fstab_line() around the blkid_get_devname() call ?

  Karsten


--
  Karsten Hopp        | Mail: karsten@redhat.de
  Red Hat Deutschland | Tel: +49-711-96437-0
  Hauptstaetterstr.58 | Fax: +49-711-613590
  D-70178 Stuttgart   | http://www.redhat.de
