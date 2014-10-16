From: Dave Jones <davej@redhat.com>
Subject: Re: kernel BUG at fs/ext4/inode.c:2982!
Date: Thu, 16 Oct 2014 10:33:46 -0400
Message-ID: <20141016143346.GA9910@redhat.com>
References: <20141016055718.GA17655@redhat.com>
 <871tq8pdh4.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonlist@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <871tq8pdh4.fsf@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Oct 16, 2014 at 01:31:51PM +0400, Dmitry Monakhov wrote:
 > Dave Jones <davej@redhat.com> writes:
 > 
 > > Just hit this on Linus' current tree while running my fuzz-tester.
 > > (No logs unfortunatly, so no idea what actually happened).
 > >
 > > kernel BUG at fs/ext4/inode.c:2982!
 > Looks
 > familiar.http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2014-8086
 > Are you playing with fcntl?

Actually, I was mistaken, there was a partial log.

Pid that oopsed was 24261. Last two calls of that pid was..

[child10:24261] [125] sendfile(out_fd=672, in_fd=672, offset=0x1, count=0xce89) = -1 (Bad address)
[child10:24261] [126] sendfile(out_fd=672, in_fd=672, offset=0x0, count=0xa1f000) 

The second call was the one that oopsed.
No idea what fd 672 was unfortunatly. I'll have to add better logging of fd types.

At the same time that was running, other pids were also doing stuff with that same fd.

[child6:24355] [124] writev(fd=672, vec=0x1d2ec60, vlen=206) 
[child8:24515] [1498] lseek(fd=672, offset=-1, whence=0x2) 

Note that those calls also didn't complete, meaning they probably blocked on
some lock that the oopsing pid was holding.

So no recent fcntl's unless they were done before the last 2 syscalls each process did.

 > Try this patch http://www.spinics.net/lists/linux-ext4/msg45683.html

I'll give it a try if I can get it reproducing easily, otherwise I cna't say
either way whether the patch is doing any good.

	Dave
