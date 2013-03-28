From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: take i_mutex in ext4_symlink to eliminate a
 warning from ext4_truncate
Date: Thu, 28 Mar 2013 10:06:35 -0400
Message-ID: <20130328140635.GA32635@thunk.org>
References: <1364390347-4360-1-git-send-email-wenqing.lz@taobao.com>
 <20130327134110.GI5861@thunk.org>
 <20130327140250.GA4316@gmail.com>
 <20130327135155.GK5861@thunk.org>
 <20130327150735.GA4395@gmail.com>
 <20130327151922.GA4487@gmail.com>
 <20130327151248.GE14900@thunk.org>
 <20130327153506.GA4565@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Zheng Liu <wenqing.lz@taobao.com>,
	Al Viro <viro@ZenIV.linux.org.uk>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130327153506.GA4565@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

I looked more closely at the assumption that ext4_write_begin() holds
i_mutex.  This is guaranteed by Documentation/filesystems/Locking,
which notes that write_begin() and write_end() functions hold i_mutex:

			PageLocked(page)	i_mutex
write_begin:		locks the page		yes
write_end:		yes, unlocks		yes

So the bug is that ext4_symlink() calls __page_symlink();
__page_symlink() calls pagecache_write_begin() which calls
write_begin(), without taking i_mutex.

So we can fix this by taking i_mutex in ext4_symlink(), but I think it
would be better to take the i_mutex in __page_symlink(), since it
would then address a violation of the locking rules for all file
systems.

Al, do you agree?

					- Ted
