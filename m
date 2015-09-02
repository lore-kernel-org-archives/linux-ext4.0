From: Albino B Neto <bino@riseup.net>
Subject: Re: [GIT PULL] Ext3 removal, quota & udf fixes
Date: Wed, 2 Sep 2015 00:30:39 -0300
Message-ID: <CAMu38xK8gEpWurPsV=ViYgZ+Sa50id0P501W3ZY4Z4R=z5PNhQ@mail.gmail.com>
References: <20150831061920.GA2751@quack.suse.cz>
	<CA+55aFweA1J+a5MYxgWDOAg0p+UdqfP+Z1aFKs1c8n0hWUiBDw@mail.gmail.com>
	<55E4D5DE.2030709@gmail.com>
	<CAMu38x+4V2JbGfCB_BxgbMOfR7QtQHFY_ebac1h1WY6wspjWFA@mail.gmail.com>
	<55E5FF01.2000304@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Raymond Jennings <shentino@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <55E5FF01.2000304@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

2015-08-31 23:53 GMT-03:00 Theodore Ts'o <tytso@mit.edu>:
> Yes, you can go back to ext3-only.  In fact, we do *not* automatically
> upgrade the file system to use ext4-specific features.
>
>> So it's not just a "you can use ext4 instead" issue. Can you do that
>> *without* then forcing an upgrade forever on that partition? I'm not
>> sure the ext4 people are really even willing to guarantee that kind of
>> backwards compatibility.
>
> Actually, we do guarantee this.  It's considered poor form to
> automatically change the superblock to add new file system features in
> a way that would break the ability for the user to roll back to an
> older kernel.  This isn't just for ext3->ext4, but for new ext4
> features such as metadata checksumming.  The user has to explicitly
> enable the feature using "tune2fs -O new_feature /dev/sdXX".

Yeah!

2015-09-01 16:39 GMT-03:00 Austin S Hemmelgarn <ahferroin7@gmail.com>:
> NO, it is not logical.  A vast majority of Android smartphones in the wild
> use ext2, as do a very significant portion of embedded systems that don't
> have room for the few hundred kilobytes of extra code that the ext4 driver
> has in comparison to ext2.

Ext2 portion embedded and Ext3 many machines.

-- 
Albino B Neto
www.bino.us
"Debian. Freedom to code. Code to freedom!" faw
