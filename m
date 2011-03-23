From: Lukas Czerner <lczerner@redhat.com>
Subject: Discard request and write counters
Date: Wed, 23 Mar 2011 14:07:40 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1103231352250.1486@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	"Theodore Ts'o" <tytso@mit.edu>, Eric Sandeen <esandeen@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hello,

I have noticed that we do treat discard requests (REQ_DISCARD) as write
requests which is probably right, but it has the side effect of
increasing write counters as well (disk_stats->sectors[1]) which leads
to confusing result.

For example in ext4 filesystem we have counter s_kbytes_written which
stores amount of kbytes written to the filesystem throughout its
lifetime. Now, if you mount the filesystem with -o discard mount option,
which means that with every commit blocks used by unlinked files are
discarded, you'll get approx. twice as many kb writes as it should be
(if you delete every file you have previously written of course).

So this means that with -o discard the ext4 s_kbytes_written counter is
no longer reliable. Now the question is how to fix that ? Should the
users of the disk_stats->sectors[1] count with this behaviour as the
REQ_DISCARD is treated as write and should be accounted for, or should
we change that in block layer and do not count REQ_DISCARD as write in
the first place ?

Thanks!
-Lukas
