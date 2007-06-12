From: Valerie Clement <valerie.clement@bull.net>
Subject: Re: [RFC][PATCH 0/12] e2fsprogs: add 64-bit support
Date: Tue, 12 Jun 2007 13:25:37 +0200
Message-ID: <466E82B1.5000709@bull.net>
References: <466D7B54.7050005@bull.net> <20070611231248.GE5181@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:49218 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660AbXFLLYT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 12 Jun 2007 07:24:19 -0400
In-Reply-To: <20070611231248.GE5181@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Andreas Dilger wrote:
> On Jun 11, 2007  18:41 +0200, Valerie Clement wrote:
>> This patchset is also not complete:
>> TODO:
>>   - update code under ext2ed/,
>=20
> This code should just be removed entirely.  It is dangerous to use, a=
nd
> by including it in e2fsprogs it lends a false sense of credibility to
> the code.  Hopefully most of the functionality here has been incorpor=
ated
> into debugfs?
>=20
OK.

>> Code compiled, booted and briefly tested on a 20TB device (mkfs,=20
>> debugfs, e2fsck, dumpe2fs, filefrag tested)
>> Some non-regression tests also done on ext3 filesystems when compili=
ng=20
>> code without _EXT4FS_ option.
>=20
> Did you run the "make check" tests?  We've found these invaluable for
> catching regressions.  Ideally there would also be some test cases
> for this support using "lazy_bg", a script to generate the filesystem=
,
> and conditional upon being able to create sparse files that big.
>=20
I missed to mention that some changes have to be done under tests/ too.
Without changes, "make check" fails.

     Val=E9rie
