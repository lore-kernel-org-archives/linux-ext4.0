From: Tao Ma <tm@tao.ma>
Subject: [PATCH V4 00/22] ext4: Add inline data support
Date: Mon, 20 Feb 2012 15:00:37 +0800
Message-ID: <4F41EF95.2000909@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Ted Ts'o <tytso@mit.edu>, Andreas Dilger <adilger@dilger.ca>,
	ext4 development <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Ted, Andreas and list,
        This is the v4 attempt to add inline data support to ext4 inode.
For more information about the background, please refer to the thread
http://marc.info/?l=linux-ext4&m=131715205428067&w=2

Changlog from v3 to v4:
1. Add support for truncate which is really a bug.
2. Some bug fixes.
3. rebased to the latest kernel.

Changelog from v2 to v3:
1. Add support for evict data from inode if we can store xattr in it.
2. Add support for fiemap
3. Some nasty bug fixes

The v3 can be found here:
http://marc.info/?l=linux-ext4&m=132421821001634&w=2

The v2 can be found here:
http://marc.info/?l=linux-ext4&m=132189338604177&w=2

The v1 can be found here:
http://marc.info/?l=linux-ext4&m=131961438221255&w=2

any suggestions are welcomed.

Thanks
Tao
