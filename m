From: Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH, v5] ext3: validate directory entry data before use
Date: Thu, 03 Jul 2008 03:51:49 -0400
Message-ID: <42526.1215071509@turing-police.cc.vt.edu>
References: <20080630143427.GA5473@dastardly>
            <1214863218-14828-1-git-send-email-duaneg@dghda.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1215071509_4193P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, sct@redhat.com, adilger@clusterfs.com,
	Sami Liedes <sliedes@cc.hut.fi>, jochen.voss@googlemail.com,
	Jan Kara <jack@suse.cz>
To: Duane Griffin <duaneg@dghda.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from turing-police.cc.vt.edu ([128.173.14.107]:36782 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937032AbYGCHwm (ORCPT
	<RFC822;linux-ext4@vger.kernel.org>); Thu, 3 Jul 2008 03:52:42 -0400
In-Reply-To: Your message of "Mon, 30 Jun 2008 23:00:18 BST."
             <1214863218-14828-1-git-send-email-duaneg@dghda.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--==_Exmh_1215071509_4193P
Content-Type: text/plain; charset=us-ascii

On Mon, 30 Jun 2008 23:00:18 BST, Duane Griffin said:
> ext3_dx_find_entry uses ext3_next_entry without verifying that the entry is
> valid. If its rec_len == 0 this causes an infinite loop. Refactor the loop
> to check the validity of entries before checking whether they match and
> moving onto the next one.

This may or may not be related, but I've managed to hit another interesting
piece of ext3 damage while running 26-rc8-mmotd-0701:

% /bin/ls -l /usr/share/man/man5 | grep lvm
/bin/ls: cannot access /usr/share/man/man5/lvm.conf.5.gz: Stale NFS file handle
-????????? ? ?    ?        ?                ? lvm.conf.5.gz

Yes, that *is* on an ext3 filesystem.

debugfs on /usr/share is interesting:

debugfs:  stat  /man/man5/lvm.conf.5.gz
Inode: 59918   Type: regular    Mode:  0644   Flags: 0x0
Generation: 4228691378    Version: 0x00000000
User:     0   Group:     0   Size: 0
File ACL: 239201    Directory ACL: 0
Links: 0   Blockcount: 0
Fragment:  Address: 0    Number: 0    Size: 0
ctime: 0x486c6c0b -- Thu Jul  3 02:04:59 2008
atime: 0x47efcad7 -- Sun Mar 30 13:16:07 2008
mtime: 0x486c6c0b -- Thu Jul  3 02:04:59 2008
dtime: 0x486c6c0b -- Thu Jul  3 02:04:59 2008
BLOCKS:

Zero links, even though man/man5 references it.  and the ctime/mtime/dtime
are suspicious as well - that file belongs to an RPM that was last updated
back on June 20, and there's no obvious culprit processes in lastcomm that
were running at 2:04AM, and none of the current ones look obvious either.

(system was booted at 00:21, so the failure happened about 1 hours 40 mins
after the current kernel launched).

Nothing in dmesg from around 2:04AM, and nothing around when the /bin/ls is run.

An 'ls -lR /usr/share' shows that the *other* 127,619 files on the filesystem
are all OK, it's just this one.

Any brilliant ideas on how to track this down further?


--==_Exmh_1215071509_4193P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFIbIUVcC3lWbTT17ARAsSVAKD93xD2f3V6YfGWH2wZMEJgSEeaaQCgryy9
Bz6jm/AzUgZS1fkC2yGkYVI=
=ehLj
-----END PGP SIGNATURE-----

--==_Exmh_1215071509_4193P--
