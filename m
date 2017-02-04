From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH] ext4: don't allow encrypted operations without keys
Date: Sat, 4 Feb 2017 13:44:28 -0800
Message-ID: <20170204214428.GC5621@zzz>
References: <20161228034812.ikoat5x3e7ucnac7@thunk.org>
 <20161228052252.10314-1-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Linux Filesystem Development List
        <linux-fsdevel@vger.kernel.org>, jaegeuk@kernel.org,
        richard@nod.at, ebiggers@google.com
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161228052252.10314-1-tytso@mit.edu>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Dec 28, 2016 at 12:22:52AM -0500, Theodore Ts'o wrote:
> While we allow deletes without the key, the following should not be
> permitted:
> 
> # cd /vdc/encrypted-dir-without-key
> # ls -l
> total 4
> -rw-r--r-- 1 root root   0 Dec 27 22:35 6,LKNRJsp209FbXoSvJWzB
> -rw-r--r-- 1 root root 286 Dec 27 22:35 uRJ5vJh9gE7vcomYMqTAyD
> # mv uRJ5vJh9gE7vcomYMqTAyD  6,LKNRJsp209FbXoSvJWzB
> 
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>

Hi Ted, this commit shows up twice in the ext4 tree, as 173b8439e1ba3 and
a7ede371cb821, but the second actually adds the check two *more* times to
ext4_cross_rename(), such that there are now a total of three checks in that
function, all the same.  Do you want to revert the second, unnecessary, commit?

Thanks,

Eric
