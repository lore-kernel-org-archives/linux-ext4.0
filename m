From: Deepa Dinamani <deepa.kernel@gmail.com>
Subject: Re: [Y2038] [PATCH 02/21] fs: ext4: Use current_fs_time() for inode timestamps
Date: Tue, 14 Jun 2016 10:55:39 -0700
Message-ID: <CABeXuvp6ob-KC=y3FoEFQGEGXbDf2hCD07o_3ZW7Mxta4_x70Q@mail.gmail.com>
References: <1465448705-25055-1-git-send-email-deepa.kernel@gmail.com>
 <1465448705-25055-3-git-send-email-deepa.kernel@gmail.com>
 <CA+55aFx7ES7D_9uVL3T1htJj6onQP2Z2TrDqTG+Qd9AuHnVf-g@mail.gmail.com> <3299877.khhcQSIs8Z@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: y2038@lists.linaro.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Al Viro <viro@zeniv.linux.org.uk>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:34564 "EHLO
	mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932218AbcFNRzl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 14 Jun 2016 13:55:41 -0400
In-Reply-To: <3299877.khhcQSIs8Z@wuerfel>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 10, 2016 at 3:19 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Thursday, June 9, 2016 11:45:01 AM CEST Linus Torvalds wrote:
>> On Wed, Jun 8, 2016 at 10:04 PM, Deepa Dinamani <deepa.kernel@gmail.com> wrote:
>> > CURRENT_TIME_SEC and CURRENT_TIME are not y2038 safe.
>> > current_fs_time() will be transitioned to be y2038 safe
>> > along with vfs.
>> >
>> > current_fs_time() returns timestamps according to the
>> > granularities set in the super_block.
>>
>> All existing users and all the ones in this patch (and the others too,
>> although I didn't go through them very carefully) really would prefer
>> just passing in the inode directly, rather than the superblock.
>>
>> So I don't want to add more users of this broken interface.  It was a
>> mistake to use the superblock. The fact that the time granularity
>> exists there is pretty much irrelevant. If every single user wants to
>> use an inode pointer, then that is what the function should get.
>
> I guess it would help to give the function a new name in the process,
> if only to avoid possible conflicts. That new name of course needs to
> be at least as intuitive as the old one. How about
>
> struct timespec fs_timestamp(struct inode *);

Would moving the function to fs/ directory (filesystems.c/ super.c /
inode.c) and calling it current_time() or fs_current_time() make
sense?
The declaration is already part of fs.h.

This is actually a vfs function.
And, the time functions it uses are already exported.
Leaving it in the time.c by renaming to current_time() would be
confusing in spite of
the struct inode* argument.

-Deepa
