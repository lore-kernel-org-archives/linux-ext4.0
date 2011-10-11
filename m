From: Miklos Szeredi <mszeredi@suse.cz>
Subject: Re: EXT4-fs (dm-1): Couldn't remount RDWR because of unprocessed
 orphan inode list
Date: Tue, 11 Oct 2011 10:45:05 +0200
Message-ID: <1318322705.5661.1.camel@tucsk.pomaz.szeredi.hu>
References: <alpine.DEB.2.01.1109021346290.9183@trent.utfs.org>
	 <4E66478E.90102@redhat.com>
	 <alpine.DEB.2.01.1109060923340.9183@trent.utfs.org>
	 <4E664DFD.80308@redhat.com> <20110908185139.GA2393@quack.suse.cz>
	 <alpine.DEB.2.01.1109091809180.9183@trent.utfs.org>
	 <20110910200414.GA6709@quack.suse.cz>
	 <alpine.DEB.2.01.1109122150060.9183@trent.utfs.org>
	 <alpine.DEB.2.01.1109152044090.5628@trent.utfs.org>
	 <20111005180339.GG23467@quack.suse.cz>
	 <alpine.DEB.2.01.1110051823380.8000@trent.utfs.org>
	 <4E8D7F11.8050309@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Christian Kujau <lists@nerdbynature.de>,
	Jan Kara <jack@suse.cz>, Eric Sandeen <sandeen@redhat.com>,
	Al Viro <viro@ZenIV.linux.org.uk>
To: toshi.okajima@jp.fujitsu.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4E8D7F11.8050309@jp.fujitsu.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 2011-10-06 at 19:12 +0900, Toshiyuki Okajima wrote:

> With Miklos' patches applies to -rc8, I could display
> "Couldn't remount RDWR because of unprocessed orphan inode list".
> on my x86_64 machine by my reproducer.
> 
> Because actual removal starts from over a range between mnt_want_write() and
> mnt_drop_write() even if do_unlinkat() or do_rmdir() calls mnt_want_write()
> and mnt_drop_write() to prevent a filesystem from re-mounting read-only.


Thanks for the reproducer.

I'm looking at this now...

Miklos


