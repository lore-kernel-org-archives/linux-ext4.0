From: Richard Yao <ryao@gentoo.org>
Subject: Re: [GIT PULL] Ext3 removal, quota & udf fixes
Date: Thu, 3 Sep 2015 18:22:25 +0000
Message-ID: <20150903182225.GA7732@woodpecker.gentoo.org>
References: <20150831061920.GA2751@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: LKML <linux-kernel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Raymond Jennings <shentino@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Theodore Ts'o <tytso@mit.edu>, Albino B Neto <bino@riseup.net>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150831061920.GA2751@quack.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

What happens with this patch if /dev/$DEVICE is ext4 formatted and someone runs
`mount -t ext3 /dev/$DEVICE $MNT`?

This should fail with the ext3 driver, but it looks like it will work fine with
CONFIG_EXT4_USE_FOR_EXT23 because ext3_fs_type maps to ext4_mount. My system is
not built with CONFIG_EXT4_USE_FOR_EXT23 (long story short: it uses a RHEL6
derived config on Linux 4.1) and I do not have time to rebuild it to verify my
suspicion, but I imagine there are others on the list that could trivially check
this.

Also, new kernels are typically drop-in replacements on older userlands. An edge
case that no one appears to have mentioned is the possibility of using a newer
kernel on an older system where the initramfs generator might only include ext3,
which this would break. It might not be terrible to write a small dummy ext3
module whose only purpose is to depend on ext4 and load it into the kernel on
those systems. That way initramfs software that properly grabs module
dependencies will include the ext4 module and `modprobe ext3` will do what it
always did in terms of making ext3 file systems mountable. I suppose that we
could use aliases, but given that there is a compatibility shim for CONFIG_EXT3
to avoid surprises, a dummy module seems reasonable.

These are the only two things that I see preventing ext4 from being a drop-in
replacement for ext3.

That said, my only connection with ext3/ext4 is that I am one of the genkernel
developers (Gentoo's  Linux initramfs/kernel genreation framework/scripts), so
my opinion might not matter much here, but I am also in favor of killing ext3 in
favor of CONFIG_EXT4_USE_FOR_EXT23.
