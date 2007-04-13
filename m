From: Jeff Mahoney <jeffm@suse.com>
Subject: Re: [RFC] add FIEMAP ioctl to efficiently map file allocation
Date: Fri, 13 Apr 2007 10:53:50 -0400
Message-ID: <461F997E.30002@suse.com>
References: <20070412110550.GM5967@schatzie.adilger.int> <97211C89-1810-4B22-B2F4-9D206D43C1F6@cam.ac.uk> <20070413040156.GU5967@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Anton Altaparmakov <aia21@cam.ac.uk>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20070413040156.GU5967@schatzie.adilger.int>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Andreas Dilger wrote:
> On Apr 12, 2007  12:22 +0100, Anton Altaparmakov wrote:
>> This would say that the offset on disk can move at any time or that  
>> the data is compressed or encrypted on disk thus the data is not  
>> useful for direct disk access.
> 
> This makes sense.  Even for Reiserfs the same is true with packed tails,
> and I believe if FIBMAP is called on a tail it will migrate the tail into
> a block because this is might be a sign that the file is a kernel that
> LILO wants to boot.

Actually, reiserfs_aop_bmap() returns 0 when the requested block is in a
tail. There's a separate ioctl for unpacking them.

- -Jeff

- --
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFGH5l+LPWxlyuTD7IRAn5/AJ9VcocIcDGr9wtAlgGZuOAQWqVASwCfVdWM
uLZQq1mkf8hsGXOpZtKQH5w=
=AxnN
-----END PGP SIGNATURE-----
