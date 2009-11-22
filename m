From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: i_version, NFSv4 change attribute
Date: Sun, 22 Nov 2009 17:20:47 -0500
Message-ID: <20091122222047.GB21944@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Since c654b8a9cba6002aad1c01919e4928a79a4a6dcf, the NFS server has made
use of ext4's i_version when available.

However, the new i_version support is available only when the filesystem
is mounted with the i_version mount option.  And the change attribute is
required for completely correct NFSv4 operation, which we'd prefer to
offer by default!

I recall having a conversation with Ted T'so about ways to do this
without affecting non-NFS-exported filesystems: maybe by providing some
sort of persistant flag on the superblock which the nfsd code could turn
on automatically if desired?

But first it would be useful to know whether there is in fact any
disadvantage to just having the i_version on all the time.  Jean Noel
Cordenner did some tests a couple years ago:

	http://www.bullopensource.org/ext4/change_attribute/index.html

and didn't find any significant difference.  But I don't know if those
results were convincing (I don't understand what we're looking for
here); any suggestions for workloads that would exercise the worst
cases?

--b.
