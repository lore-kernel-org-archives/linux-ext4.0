From: Valdis.Kletnieks@vt.edu
Subject: Re: [RFC PATCH] ext4: increase the protection of drop nlink and ext4 inode destroy
Date: Sat, 31 Dec 2016 17:59:13 -0500
Message-ID: <141922.1483225153@turing-police.cc.vt.edu>
References: <1482755657-28791-1-git-send-email-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1483225153_2772P";
         micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, tytso@mit.edu,
        adilger.kernel@dilger.ca
To: yi zhang <yi.zhang@huawei.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1482755657-28791-1-git-send-email-yi.zhang@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

--==_Exmh_1483225153_2772P
Content-Type: text/plain; charset=us-ascii

On Mon, 26 Dec 2016 20:34:17 +0800, yi zhang said:
> Because of the disk and hardware issue, the ext4 filesystem have
> many errors, the inode->i_nlink of ext4 becomes zero abnormally
> but the dentry is still positive, it will cause memory corruption
> after the following process:
>
>  1) Due to the inode->i_nlink is 0, this inode will be added into
> the orhpan list,

> +	if (WARN(inode->i_nlink == 0, "inode %lu nlink"
> +		" is already 0", inode->i_ino))

Can we get the filesystem? Or at least the device major/minor? If a system
has multiple large ext4 filesystems, it would be helpful to know which
one is having the problem.

--==_Exmh_1483225153_2772P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Comment: Exmh version 2.5 07/13/2001

iQEVAwUBWGg4QY0DS38y7CIcAQIwYwf/YCbanNpTT/1qBJEdRkRSDQ2CDXhrsWfE
eMgzqNkA/3J+kjpJYS+jnRJTqdYU78Hph+SuOY6TF9nAQv6XH49Zs6oeXx+9NqxK
oV36KCMq+KNd9sIRyK+zrD6muhGi5otzaygIa3ft5xzntkKlr5C/zAV+C79MGukB
dYEwLtFGZAVvm3187ooMXAw17MGgZVhsgRv9sLPF8c26n6cAPhG6MRf6kFVLTgX2
JlG3bsMnt3kR06OB/31OCPK4SyuInJupejYzGIWzPK9i8tFy4yv0Ohbq73HLKrIY
icm/GrRlap/SjGLowVtNDOyvsaqat9YDUKSXI8ZW25sSjUxr6/6LCg==
=qSJX
-----END PGP SIGNATURE-----

--==_Exmh_1483225153_2772P--
