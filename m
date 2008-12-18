From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: Re: [PATCH -v3] vfs: add releasepages hooks to block devices which
 can be used by file systems
Date: Thu, 18 Dec 2008 14:15:25 +0900
Message-ID: <4949DC6D.3050908@jp.fujitsu.com>
References: <20081212062148.GJ10890@mit.edu> <1229104375-11567-1-git-send-email-tytso@mit.edu> <20081217153940.GA6495@atrey.karlin.mff.cuni.cz>
Reply-To: toshi.okajima@jp.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20081217153940.GA6495@atrey.karlin.mff.cuni.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,
 >   Hello,
 >
 > > > From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
 > > >
 > > > Implement blkdev_releasepage() to release the buffer_heads and page
 > > > after we release private data which belongs to a client of the block
 > > > device, such as a filesystem.
 > > >
 > > > blkdev_releasepage() call the client's releasepage() which is
 > > > registered by blkdev_register_client_releasepage() to release its
 > > > private data.
 >   Yes, this is IMO the right fix. I'm just wondering about the fact that we
 > can't block in the client_releasepage(). That seems to be caused by the fact
 > that we need to be protected against client_releasepage() callback changes
 > which essentially means umount, right? I'm not saying I have a better solution
 > but introducing such limitation seems stupid just because of umount...
 >
 > 									Honza
 >

Difference between v2 and v3 in blkdev_releasepage:
<		ret = (*ei->client_releasepage)(ei->client, page, wait);
<	else
--
 >		/*
 >		 * Since we are holding a spinlock (ei->client_lock),
 >		 * make sure the client_releasepage function
 >		 * understands that it must not block.
 >		 */
 >		ret = (*ei->client_releasepage)(ei->client, page,
 >						wait & ~__GFP_WAIT);
 >	else

Ask for clarification.

Which of the following do you mean:
1) If using a spinlock in client_releasepage() is only for mount/umount,
  this implementation is not wise.
2) There is the fact that a spinlock is necessary for blkdev_releasepage().
This fact prevents us from making various implementations of
client_releasepage().
(Without a spinlock, we can implement a client_releasepage() which can release
the buffers with a sleep. As a result, it may enable more buffers release than
before.)

There is the fact that a filesystem can be mounted on several places,
and the lock mechanism is absolutely necessary for this fact.

I also think we are sad that we cannot implement various implementations for
client_releasepage(). But now I cannot imagine what to do for
a client_releasepage() which can sleep, too...

Regards,
Toshiyuki Okajima

