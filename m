From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] resize2fs: exit fix_sb_journal_backup early for external
 	journal
Date: Tue, 10 Nov 2009 23:42:07 -0600
Message-ID: <4AFA4EAF.8040502@redhat.com>
References: <4AF88220.90908@redhat.com>	 <4877c76c0911091954p237058cfn2ce9f41cd966d2dc@mail.gmail.com> <4877c76c0911102125t5eef5cf1y228c02ed9c05d3fd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Michael Evans <mjevans1983@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45040 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751233AbZKKFmH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Nov 2009 00:42:07 -0500
In-Reply-To: <4877c76c0911102125t5eef5cf1y228c02ed9c05d3fd@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Michael Evans wrote:
> I've run this test case a few times on my system.  It looks like it's
> the right thing to do, but before I run it on a drive that actually
> has data I care about I'd like to make sure it's doesn't have some
> kind of unforeseen side effects.

I really think the patch is fine, but you can wait 'til Ted merges it 
for the official stamp of approval... :)

-eric

> #!/bin/sh
> touch testfs
> truncate -s1500M testfs
> touch testjournal
> truncate -s128M testjournal
> LOLOG=`losetup -f`
> losetup "${LOLOG}" testjournal
> mke2fs -O journal_dev "${LOLOG}"
> LOFS=`losetup -f`
> losetup "${LOFS}" testfs
> mkfs.ext4 -J device="${LOLOG}" "${LOFS}" 200000
> mkdir /tmp/testfs
> mount "${LOFS}" /tmp/testfs
> echo "Filesystem mounted, copying /usr/src/linux/ to (try to) fill the device."
> find /usr/src/linux/ -depth -print0 | cpio -p0mud /tmp/testfs
> pushd /tmp/testfs
> echo "Generating checksums"
> find ./ -type f -print0 | xargs -0I = md5sum = > /tmp/check.md5
> popd
> df | grep "/tmp/testfs"
> wc /tmp/check.md5
> umount /tmp/testfs
> fsck -fy "${LOFS}"
> resize2fs "${LOFS}"
> fsck -fy "${LOFS}"
> ./resize/resize2fs "${LOFS}"
> mount "${LOFS}" /tmp/testfs
> pushd /tmp/testfs
> df | grep "/tmp/testfs"
> md5sum -c /tmp/check.md5 | sed '/OK[\r\n]*$/d'
> if [ "$?" == "0" ] ; then echo "MD5 check PASSED" ; fi
> popd
> umount /tmp/testfs
> rm -rf /tmp/testfs /tmp/check.md5
> losetup -d "${LOLOG}"
> losetup -d "${LOFS}"
> rm testfs testjournal
> echo "Cleanup Complete"

