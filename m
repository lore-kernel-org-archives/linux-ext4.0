From: Alexey Lyashkov <alexey.lyashkov@gmail.com>
Subject: Re: [PATCH] Add largedir feature
Date: Mon, 20 Mar 2017 14:34:31 +0300
Message-ID: <AC9DD60D-37A5-458B-AFA2-5EDDAAFD5E9E@gmail.com>
References: <20170319133425.gxeg3mba3brvztjf@thunk.org>
 <2F91584E-6351-4523-9821-54AD6A7CD889@dilger.ca>
Mime-Version: 1.0 (Mac OS X Mail 10.2 \(3259\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Cc: Theodore Ts'o <tytso@mit.edu>,
        Artem Blagodarenko <artem.blagodarenko@gmail.com>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        Yang Sheng <yang.sheng@intel.com>,
        Zhen Liang <liang.zhen@intel.com>,
        Artem Blagodarenko <artem.blagodarenko@seagate.com>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33328 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753445AbdCTLfH (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 20 Mar 2017 07:35:07 -0400
Received: by mail-wm0-f68.google.com with SMTP id n11so13893734wma.0
        for <linux-ext4@vger.kernel.org>; Mon, 20 Mar 2017 04:34:34 -0700 (PDT)
In-Reply-To: <2F91584E-6351-4523-9821-54AD6A7CD889@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


>=20
>> I brought up the 32-bit inode limit because Alexey was using this as
>> an argument not to move ahead with merging the largedir feature.  Now
>> that I understand his concerns are also based around Lustre, and the
>> fact that we are inserting into the hash tree effectively randomly,
>> that *is* a soluble problem for Lustre, if it has control over the
>> directory names which are being stored in the MDS file.  For example,
>> if you are storing in this gargantuan MDS directory file names which
>> are composed of the 128-bit Lustre FileID, we could define a new hash
>> type which, if the filename fits the format of the Lustre FID, parses
>> the filename and uses the low the 32-bit object ID concatenated with
>> the low-32 bits of the sequence id (which is used to name the =
target).
>=20
> No, the directory tree for the Lustre MDS is just a regular directory
> tree (under "ROOT/" so we can have other files outside the visible
> namespace) with regular filenames as with local ext4.  The one =
difference
> is that there are also 128-bit FIDs stored in the dirents to allow =
readdir
> to work efficiently, but the majority of the other Lustre attributes
> are stored in xattrs on the inode.

To make picture clean. OST side is regular FS with 32 directories where =
a stripe objects is live.
With current 4G inodes limit each directory will filled with up 100k =
regular files.
Files allocated in batch, up to 20k files per batch. Allocated object =
used on MDT side to make mapping between metadata objects and data for =
such file.
I worry about it part, not about MDT. these directories have a large =
number creations/unlinks and performance degradation started after 3M-5M =
creations/unlinks.
With Large dir feature i think this performance problems may deeper.


Alexey=20=
