From: Felipe Monteiro de Carvalho <felipemonteiro.carvalho@gmail.com>
Subject: Which features should I implement in my ext4 reader?
Date: Mon, 12 Aug 2013 17:38:03 +0200
Message-ID: <CACyNnZNJssSL+UWOXYmWk9xy07WRT_z+Fk9Kjwfws9JRfWoNEQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f175.google.com ([209.85.192.175]:51378 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756374Ab3HLPiE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 12 Aug 2013 11:38:04 -0400
Received: by mail-pd0-f175.google.com with SMTP id q10so3564019pdj.6
        for <linux-ext4@vger.kernel.org>; Mon, 12 Aug 2013 08:38:03 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

Thanks to the help here I have essentially finished my ext4 reader =)
At least it can read ext4 filesystems with these features, which is
what I found when using Ubuntu and Mageia LInux:

   EXT4_FEATURE_INCOMPAT_JOURNAL_DEV	= $0008; // Journal device */
   EXT4_FEATURE_INCOMPAT_META_BG	= $0010;
   EXT4_FEATURE_INCOMPAT_EXTENTS	= $0040; // extents support */
   EXT4_FEATURE_INCOMPAT_FLEX_BG	= $0200;
   EXT4_FEATURE_INCOMPAT_64BIT		= $0080;

Some features seam to not require any extra care for my reader:

   EXT4_FEATURE_INCOMPAT_COMPRESSION	= $0001;
   EXT4_FEATURE_INCOMPAT_FILETYPE	= $0002;
   EXT4_FEATURE_INCOMPAT_RECOVER	= $0004; // Needs recovery */
   EXT4_FEATURE_INCOMPAT_BG_USE_META_CSUM= $2000; // use crc32c for bg */

But I now wonder about these features:

   EXT4_FEATURE_INCOMPAT_MMP            = $0100;
   EXT4_FEATURE_INCOMPAT_EA_INODE	= $0400; // EA in inode */
   EXT4_FEATURE_INCOMPAT_DIRDATA	= $1000; // data in dirent */
   EXT4_FEATURE_INCOMPAT_LARGEDIR	= $4000; // >2GB or 3-lvl htree */
   EXT4_FEATURE_INCOMPAT_INLINEDATA	= $8000; // data in inode */

Could anyone comment how common is the use of those features and if
they are already stable and in production usage (I read that they were
under development in 2011)?

And also which ones require an active work for a reader application to
implement. As I already found out that FLEX_BG does not require active
work to be supported despite being in the INCOMPAT list...

>From the description I'm pretty sure that at least DIRDATA and
INLINEDATA would require adjustments in my software. But I wonder if
they are already being used and stable, etc, and if it is a good idea
to work on supporting them.

thanks, =)
-- 
Felipe Monteiro de Carvalho
