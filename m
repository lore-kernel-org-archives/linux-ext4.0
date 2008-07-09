From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 3/3] Add timeout feature
Date: Wed, 09 Jul 2008 08:22:56 +0200
Message-ID: <E1KGT4q-0006fD-Jb@pomaz-ex.szeredi.hu>
References: <20080630212450t-sato@mail.jp.nec.com> <20080701081026.GB16691@infradead.org> <20080707110730.GG5643@ucw.cz> <20080708231026.GP11558@disturbed> <20080708232031.GE18195@elf.ucw.cz> <20080709005254.GQ11558@disturbed> <20080709010922.GE9957@mit.edu> <E1KGSvZ-0006dB-53@pomaz-ex.szeredi.hu> <20080709061621.GA5260@infradead.org>
Cc: miklos@szeredi.hu, tytso@mit.edu, pavel@suse.cz, hch@infradead.org,
	t-sato@yk.jp.nec.com, akpm@linux-foundation.org,
	viro@ZenIV.linux.org.uk, linux-ext4@vger.kernel.org,
	xfs@oss.sgi.com, dm-devel@redhat.com,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	axboe@kernel.dk, mtk.manpages@googlemail.com
To: hch@infradead.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-reply-to: <20080709061621.GA5260@infradead.org> (message from Christoph
	Hellwig on Wed, 9 Jul 2008 02:16:21 -0400)
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 9 Jul 2008, Christoph Hellwig wrote:
> On Wed, Jul 09, 2008 at 08:13:21AM +0200, Miklos Szeredi wrote:
> > This would mean that freeze and thaw will have to be done on the same
> > file descriptor, but this isn't unreasonable to expect, is it?
> 
> It is certainly not the current use case, where you run one command
> to freeze the filesystem and another one to unfreeze it.

So instead of

  freeze_fs mountpoint
  backup-command
  unfreeze_fs mountpoint

the user would have do to

  run_freezed mountpoint backup-command

I find the second one nicer, regardless of any reliability issues.

Miklos
