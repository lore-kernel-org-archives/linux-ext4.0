From: "Mike Snitzer" <snitzer@gmail.com>
Subject: potential regression in ext[34] call to __page_symlink()?
Date: Tue, 28 Oct 2008 20:11:48 -0400
Message-ID: <170fa0d20810281711s2a508ed2o1af0db30733e8d2d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Nick Piggin" <npiggin@suse.de>, "Kirill Korotaev" <dev@openvz.org>
To: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The gfp_mask that is passed to __page_symlink() is being completely
dropped on the floor.  Historically this mask was at least used by
ext3 and ext4 to avoid recursing back into the FS from within a
journal transaction; Kirill fixed that issue with this commit:
0adb25d2e71ab047423d6fc63d5d184590d0a66f

I'm quite naive when it comes to Nick's relatively new (>= 2.6.24) AOP
pagecache_write_{begin,end} code that motivated __page_symlink to
change with this commit:
afddba49d18f346e5cc2938b6ed7c512db18ca68

Nick's change clearly did away with using the explicitly passed
gfp_mask in __page_symlink().
So at a minimum it would seem __page_symlink() now has an unused
parameter that should be removed.

But a more serious concern would be: have ext[34]_symlink() regressed
to being susceptible to the bug that Kirill fixed some time ago?

Please advise, thanks.
Mike
