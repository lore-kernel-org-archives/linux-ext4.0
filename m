From: Dave Jones <davej@redhat.com>
Subject: Re: kernel BUG at fs/ext4/inode.c:2982!
Date: Thu, 16 Oct 2014 16:15:04 -0400
Message-ID: <20141016201504.GA24798@redhat.com>
References: <20141016055718.GA17655@redhat.com>
 <871tq8pdh4.fsf@openvz.org>
 <20141016143346.GA9910@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Dmitry Monakhov <dmonlist@gmail.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20141016143346.GA9910@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Oct 16, 2014 at 10:33:46AM -0400, Dave Jones wrote:

 >  > Try this patch http://www.spinics.net/lists/linux-ext4/msg45683.html
 > 
 > I'll give it a try if I can get it reproducing easily, otherwise I cna't say
 > either way whether the patch is doing any good.

ok, I managed to reproduce it a few times, and then tried again with
your patch.  I'm not sure if it's related, but I'm now seeing lockups
in ext4.  The process that gets stuck looks like this..

trinity-c21     R  running task    13232  9781    831 0x10000004
 0000000000000000 0000000000000001 0000000000000000 0000000000000000
 ffff8800c8d333d8 0000000000000000 0000000000000002 00000000cacaa650
 ffff880217cf7db8 0000000000000000 0000000000000000 ffffffffa929ff8c
Call Trace:
 [<ffffffffa929ff8c>] ? ext4_map_blocks+0x31c/0x560
 [<ffffffffa929fe75>] ? ext4_map_blocks+0x205/0x560
 [<ffffffffa92e689c>] ? ext4_es_find_delayed_extent_range+0x48c/0x4e0
 [<ffffffffa9298fe1>] ? ext4_llseek+0x261/0x3f0
 [<ffffffffa922e6e9>] ? __fdget_pos+0x49/0x50
 [<ffffffffa90e484e>] ? rcu_read_lock_held+0x6e/0x80
 [<ffffffffa920ca44>] ? SyS_lseek+0x94/0xc0

I've got to run right now, but I'll look into tracing it some more when I get back.

	Dave
