From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 14/38] fallthru: ext2 fallthru support
Date: Fri, 06 Aug 2010 10:15:14 +0200
Message-ID: <E1OhI5C-0005PG-3G@pomaz-ex.szeredi.hu>
References: <1276627208-17242-1-git-send-email-vaurora@redhat.com> <1276627208-17242-15-git-send-email-vaurora@redhat.com> <E1OgfCU-0000ko-Lu@pomaz-ex.szeredi.hu> <20100804224831.GB29353@shell> <E1Ogxol-0002xs-De@pomaz-ex.szeredi.hu> <20100805233019.GA30761@shell>
Cc: miklos@szeredi.hu, viro@zeniv.linux.org.uk, jblunck@suse.de,
	hch@infradead.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, tytso@mit.edu,
	linux-ext4@vger.kernel.org
To: Valerie Aurora <vaurora@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fxip-0047f.externet.hu ([88.209.222.127]:42963 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759216Ab0HFIPg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Aug 2010 04:15:36 -0400
In-reply-to: <20100805233019.GA30761@shell> (message from Valerie Aurora on
	Thu, 5 Aug 2010 19:30:19 -0400)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 5 Aug 2010, Valerie Aurora wrote:
> On Thu, Aug 05, 2010 at 12:36:55PM +0200, Miklos Szeredi wrote:
> > On Wed, 4 Aug 2010, Valerie Aurora wrote:
> > > --zYM0uCDKw75PZbzx
> > > Content-Type: text/plain; charset=us-ascii
> > > Content-Disposition: inline
> > > 
> > > On Wed, Aug 04, 2010 at 04:44:10PM +0200, Miklos Szeredi wrote:
> > > > On Tue, 15 Jun 2010, Valerie Aurora wrote:
> > > > > Add support for fallthru directory entries to ext2.
> > > > 
> > > > If a previously used ext2 filesystem with is mounted again then
> > > > fallthroughs don't appear to work as expected.  Stat returns ENOENT
> > > > for these entries.
> > > > 
> > > > Can't see anything obviously wrong with the code.
> > > 
> > > Hm, I wrote one test case for this that worked (attached).  Can you
> > > give me more details on your test case?  Thanks,
> 
> Cool, thanks.  Yes, I suppose the fallthrus should be ignored if they
> don't fall through to anything.

That's not the case here.  They _should_ fall through to ext3.img, yet
apparently after ovl.img being mounted again they don't seem to work.

Note, ovl.img starts out as a completely empty filesystem.

The difference between your test case and mine mitght be that yours
not only reads the directory but stats the files as well, while mine
does not.

Thanks,
Miklos


> 
> > uml:~# mount -oloop -r ext3-2.img /mnt/img/
> > uml:~# mount -oloop -r ext3.img /mnt/img/
> > uml:~# losetup -f ovl.img 
> > uml:~# mmount -b 8 -t ext2 /dev/loop2 /mnt/img/
> > uml:~# "ls" /mnt/img
> > bunion  lost+found  union
> > uml:~# "ls" /mnt/img/union
> > 1  2  3
> > uml:~# "ls" /mnt/img/union/1
> > a  x
> > uml:~# umount /mnt/img/
> > uml:~# mmount -b 8 -t ext2 /dev/loop2 /mnt/img/
> > uml:~# ls -l /mnt/img/  
> > total 14
> > drwxr-xr-x 2 root root  1024 Aug  5 09:56 bunion
> > drwx------ 2 root root 12288 Aug  5 09:41 lost+found
> > drwxr-xr-x 3 root root  1024 Aug  5 09:56 union
> > uml:~# ls -l /mnt/img/union/
> > ls: cannot access /mnt/img/union/3: No such file or directory
> > ls: cannot access /mnt/img/union/2: No such file or directory
> > total 1
> > drwxr-xr-x 2 root root 1024 Aug  5 09:56 1
> > ?????????? ? ?    ?       ?            ? 2
> > ?????????? ? ?    ?       ?            ? 3
> > uml:~# ls -l /mnt/img/union/1
> > ls: cannot access /mnt/img/union/1/a: No such file or directory
> > ls: cannot access /mnt/img/union/1/x: No such file or directory
> > total 0
> > ?????????? ? ? ? ?            ? a
> > ?????????? ? ? ? ?            ? x
> > uml:~# 
> > 
> > Thanks,
> > Miklos
> 
