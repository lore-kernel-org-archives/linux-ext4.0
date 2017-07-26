From: Jason Baron <jbaron@akamai.com>
Subject: nowait aio return value
Date: Wed, 26 Jul 2017 14:45:23 -0400
Message-ID: <04be5a78-3428-c09e-bc63-5061fa568ea5@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: jack@suse.cz, axboe@kernel.dk, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: rgoldwyn@suse.com
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

In testing nowait aio on ext4, I found that when appending to a file
the return value is EAGAIN/EWOULDBLOCK, because as mentioned in the 
commit this will potentially trigger an allocation. However, the EAGAIN, 
seems somewhat misleading to me, in that if I continuously try the 
write, it will never succeed.

The relevant commit is:
728fbc0 ext4: nowait aio support

As you can see there, failure to get the inode lock is treated as
EAGAIN, which seems more appropriate to me, as its very likely
to succeed on subsequent calls.

Perhaps, it could be switched to -EINVAL, or something else?

Thanks,

-Jason
