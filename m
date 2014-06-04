From: Benno Schulenberg <bensberg@justemail.net>
Subject: Re: [2/4 v2] e2fsck: make a prompt message simpler and thus translatable
Date: Wed, 04 Jun 2014 14:23:21 +0200
Message-ID: <1401884601.6870.125052445.0CA47507@webmail.messagingengine.com>
References: <20140602234001.GJ30598@thunk.org>
 <1401827722-13286-1-git-send-email-bensberg@justemail.net>
 <20140604020719.GC27426@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:42244 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752932AbaFDMX1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Jun 2014 08:23:27 -0400
In-Reply-To: <20140604020719.GC27426@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Wed, Jun 4, 2014, at 4:07, Theodore Ts'o wrote:
> You forgot to fix up the regression test suite f_extra_journal so
> "make check" doesn't fail.
> 
> I've taken care of it,

Thanks.

> but in general before sending patches, I'd
> appreicate a quick run of "make -j8 check"

Okay.

Running 'make check' now, I see these messages along the way:

mktemp: too few X's in template `r_64bit_big_expand.XXXXXX.tmp'
touch: missing file operand
Try `touch --help' for more information.
rm: missing operand
Try `rm --help' for more information.
r_64bit_big_expand: very large fs growth using ext4 w/64bit: skipped
mktemp: too few X's in template `r_bigalloc_big_expand.XXXXXX.tmp'
touch: missing file operand
Try `touch --help' for more information.
rm: missing operand
Try `rm --help' for more information.
r_bigalloc_big_expand: ext4 with bigalloc: skipped
mktemp: too few X's in template `r_ext4_big_expand.XXXXXX.tmp'
touch: missing file operand
Try `touch --help' for more information.
rm: missing operand
Try `rm --help' for more information.
r_ext4_big_expand: very large fs growth using ext4: skipped


That doesn't look intentional.
The contents of r_ext4_big_expand.log are:

very large fs growth using ext4 starting
dd: truncating at 2199023255552 bytes in output file `/tmp/e2fsprogs-tmp.I08Z35': File too large
using 
dd: opening `': No such file or directory


On this system, 'info mktemp' says:
"The last six characters of this string must be `XXXXXX'."

So by doing a 's/XXXXXX.tmp/tmp.XXXXXX/' in tests/scripts/resize_test
those messages disappear and 144 tests succeeded     0 tests failed.

Patch is coming up in a minute.

Benno

-- 
http://www.fastmail.fm - IMAP accessible web-mail

