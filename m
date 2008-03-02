From: Eric Sandeen <sandeen@redhat.com>
Subject: blkid -w is ignored... fix the code or the manpage? :)
Date: Sun, 02 Mar 2008 10:46:59 -0600
Message-ID: <47CADA03.2040102@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:57671 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753803AbYCBQrD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 2 Mar 2008 11:47:03 -0500
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m22Gl1g8010159
	for <linux-ext4@vger.kernel.org>; Sun, 2 Mar 2008 11:47:01 -0500
Received: from pobox-2.corp.redhat.com (pobox-2.corp.redhat.com [10.11.255.15])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m22Gl0uq001996
	for <linux-ext4@vger.kernel.org>; Sun, 2 Mar 2008 11:47:01 -0500
Received: from Liberator.local (sebastian-int.corp.redhat.com [172.16.52.221])
	by pobox-2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m22GkxBE000718
	for <linux-ext4@vger.kernel.org>; Sun, 2 Mar 2008 11:47:00 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

the blkid manpage says:

	-w	<writecachefile>  Write  the  device  cache  to
		writecachefile instead of writing it to the default
		cache file /etc/blkid.tab. If you don=92t want to save
		the cache to the default file,  specify  /dev/null.
		If  not specified it will be the same file as that
		given by the -c option.

and yet, since:

http://thunk.org/hg/e2fsprogs/?rev/ad62cded89a8 (I think...)

(2003...) it has been completely ignored.

I have a bug on this, from before my time at Red Hat,
https://bugzilla.redhat.com/show_bug.cgi?id=3D200191  Bugzilla Bug 2001=
91:
blkid does not rewrite blkid.tab as documented in the man page.
=2E..filed in 2006.

It'd be easy enough to fix, although this might be a library API change=
,
at least if we want to make blkid_get_cache() symmetric with
blkid_put_cache(), each taking a filename...

But it's been broken so long, with (few) complaints, is the
functionality worth resurrecting, or should I just submit a patch to
remove the -w option?  :)

Thanks,

-Eric

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
