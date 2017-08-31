From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: e2fsck: set dir_nlink feature if large dir exists
Date: Thu, 31 Aug 2017 12:17:59 -0600
Message-ID: <6FF8BA29-74A3-483D-A194-C5AD3A4E3BF2@dilger.ca>
References: <1503080382-37376-1-git-send-email-adilger@dilger.ca>
 <20170830022000.b7mgzksytvcwirx5@thunk.org>
 <604C57FC-C3A6-478F-BDA6-E8550555C70F@dilger.ca>
 <20170830151332.2ikr5dfox3aeebyd@thunk.org>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_D6320DDB-5460-4383-BEAC-292B2CADB05B";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f181.google.com ([209.85.223.181]:36740 "EHLO
        mail-io0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750911AbdHaSSL (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 31 Aug 2017 14:18:11 -0400
Received: by mail-io0-f181.google.com with SMTP id f99so3371210ioi.3
        for <linux-ext4@vger.kernel.org>; Thu, 31 Aug 2017 11:18:11 -0700 (PDT)
In-Reply-To: <20170830151332.2ikr5dfox3aeebyd@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_D6320DDB-5460-4383-BEAC-292B2CADB05B
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii

On Aug 30, 2017, at 9:13 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> 
> On Wed, Aug 30, 2017 at 01:43:30AM -0600, Andreas Dilger wrote:
>> On a related note, I was trying to implement the optimization for
>> more efficient ext2fs_link() insertion, but this has proven to be
>> much more complex than I expected.  I was thinking I would just
>> call the link_proc() function directly to handle insertion of the
>> new name, using block number of the previous caller.  However, this
>> function depends on the directory leaf buffers having been read
>> from disk, and being passed a dirent pointer to the free space after
>> being called through a series of callback indirections.
> 
> I think it's more trouble than it's worth to preseve the existing
> link_proc() function.  I'd recommend out to be just what is necessary
> to do the directory entry insert, and make that a helper function
> which is called by link_proc() and the shortcut handling code in
> ext2fs_link().

I looked at implementing it this way, but unfortunately that doesn't
appear workable since ext2fs_link() never gets the block numbers to
be able to do this.  I'd essentially have to reimplement all of the
block and directory leaf processing in ext2fs_dir_iterate2() to get
figure out where to store the first entries in the directory.

What I'm looking at now is add a new ext2fs_dir_iterate3() function
that passes *blocknr and blockcnt to the link_proc() and unlink_proc()
callback functions so they can be stored in struct_ext2_filsys, and
used to shortcut the iteration in ext2fs_link() for multiple inserts.
It is added to unlink_proc() so that we can reset the saved state if
entries are being deleted.

Cheers, Andreas






--Apple-Mail=_D6320DDB-5460-4383-BEAC-292B2CADB05B
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFZqFLcpIg59Q01vtYRArpQAKDJo6wJqt56IYokOAou9j7SN4bKzgCfY+BL
z8lnPdVDn8M34YJnxIW5KCE=
=jkVJ
-----END PGP SIGNATURE-----

--Apple-Mail=_D6320DDB-5460-4383-BEAC-292B2CADB05B--
