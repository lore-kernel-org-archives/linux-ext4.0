From: Andi Kleen <andi@firstfloor.org>
Subject: Re: Maximum filename length
Date: Sun, 23 Nov 2008 23:15:35 +0100
Message-ID: <87abbqhywo.fsf@basil.nowhere.org>
References: <87a8dc10811210451p3ec1e3dar371a3ebffcedcdc@mail.gmail.com>
	<20081121223248.GA22671@mit.edu>
	<87a8dc10811221048t27b0c6dx253bed61418389e8@mail.gmail.com>
	<20081122233618.GR3186@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alexey Salmin <alexey.salmin@gmail.com>,
	Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:56236 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062AbYKWWPc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 23 Nov 2008 17:15:32 -0500
In-Reply-To: <20081122233618.GR3186@webber.adilger.int> (Andreas Dilger's message of "Sat, 22 Nov 2008 17:36:18 -0600")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger <adilger@sun.com> writes:
>
> #define EXT4_FT_ENTRY_3 0x80			/* file_type for dir_entry_3 */
> #define EXT4_FT_MASK    0x0f			/* EXT4_FT_* mask */
> #define EXT4_INODE_MASK 0x00ffffffffffffff	/* 48-bit inode number mask */
> #define EXT4_NAME_LEN3  1012
>
> struct ext4_dir_entry_3 {
> 	__le64 inode;		/* High byte holds file_type */
> 	__le16 rec_len;
> 	__le16 name_len;

The new format should also reserve space for a checksum. Adding that
would be actually a reasonable practical improvement for everyone.

> 	char   name[EXT4_NAME_LEN3];

-Andi

-- 
ak@linux.intel.com
