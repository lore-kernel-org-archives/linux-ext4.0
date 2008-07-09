From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 3/3] Add timeout feature
Date: Wed, 09 Jul 2008 08:48:42 +0200
Message-ID: <E1KGTTm-0006ke-Jh@pomaz-ex.szeredi.hu>
References: <20080630212450t-sato@mail.jp.nec.com>
	<20080701081026.GB16691@infradead.org>
	<20080707110730.GG5643@ucw.cz>
	<20080708231026.GP11558@disturbed>
	<20080708232031.GE18195@elf.ucw.cz>
	<20080709005254.GQ11558@disturbed>
	<20080709010922.GE9957@mit.edu>
	<E1KGSvZ-0006dB-53@pomaz-ex.szeredi.hu>
	<20080709061621.GA5260@infradead.org>
	<E1KGT4q-0006fD-Jb@pomaz-ex.szeredi.hu> <20080708234120.5072111f@infradead.org>
Cc: miklos@szeredi.hu, hch@infradead.org, miklos@szeredi.hu,
	tytso@mit.edu, pavel@suse.cz, t-sato@yk.jp.nec.com,
	akpm@linux-foundation.org, viro@ZenIV.linux.org.uk,
	linux-ext4@vger.kernel.org, xfs@oss.sgi.com, dm-devel@redhat.com,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	axboe@kernel.dk, mtk.manpages@googlemail.com
To: arjan@infradead.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-reply-to: <20080708234120.5072111f@infradead.org> (message from Arjan van
	de Ven on Tue, 8 Jul 2008 23:41:20 -0700)
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 8 Jul 2008, Arjan van de Ven wrote:
> nah he needs to do
> 
> make_snapshot ; backup-command ; unref_snapshot.
> 
> freezing isn't the right solution for the backup problem ;)

Confused, what's freezing _is_ for then?  Patch description says:

  Currently, ext3 in mainline Linux doesn't have the freeze feature which
  suspends write requests.  So, we cannot take a backup which keeps
  the filesystem's consistency with the storage device's features
  (snapshot and replication) while it is mounted.
  In many case, a commercial filesystem (e.g. VxFS) has
  the freeze feature and it would be used to get the consistent backup.
  If Linux's standard filesytem ext3 has the freeze feature, we can do it
  without a commercial filesystem.

Miklos
