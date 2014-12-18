From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] fs: make generic_block_fiemap sig-tolerant PING2...
Date: Thu, 18 Dec 2014 15:12:47 -0800
Message-ID: <20141218151247.b6ccd73351f40db66818c07e@linux-foundation.org>
References: <1413552269-32203-1-git-send-email-dmonakhov@openvz.org>
	<871toikt7c.fsf@openvz.org>
	<87zjavehsx.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org,
	ext4 development <linux-ext4@vger.kernel.org>,
	"Theodore Ts'o" <tytso@mit.edu>, Al Viro <viro@ZenIV.linux.org.uk>,
	Michael Kerrisk <mtk.manpages@gmail.com>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87zjavehsx.fsf@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 10 Dec 2014 16:49:18 +0300 Dmitry Monakhov <dmonakhov@openvz.org> wrote:

> 
> Hello. Someone please take care of this patch.
> 
> W/o that patch unprivileged user may abuse system resources simply by spawning
> wast number of unkilable busyloops (works on ext2/ext3):
> 
> truncate --size 1T test
> for ((i=0;i<1024;i++))
> do
>        filefrag test > /dev/null &
> done
> 
> >> --- a/fs/ioctl.c
> >> +++ b/fs/ioctl.c
> >> @@ -379,6 +379,11 @@ int __generic_block_fiemap(struct inode *inode,
> >>  				past_eof = true;
> >>  		}
> >>  		cond_resched();
> >> +		if (fatal_signal_pending(current)) {
> >> +			ret = -EINTR;
> >> +			break;
> >> +		}
> >> +
> >>  	} while (1);
> >>  

Is FIEMAP documented anywhere (manpage)?  If so, that will need an
update.
