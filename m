From: Theodore Tso <tytso@mit.edu>
Subject: Re: ask for help; hash-directory machanism of ext3 cannot work well
Date: Thu, 21 Jun 2007 12:57:49 -0400
Message-ID: <20070621165749.GA5664@thunk.org>
References: <467a39a0.1997600a.2ec2.ffffd4d1@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: LIOU Payphone <lioupayphone@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:48849 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752763AbXFUQ6A (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 21 Jun 2007 12:58:00 -0400
Content-Disposition: inline
In-Reply-To: <467a39a0.1997600a.2ec2.ffffd4d1@mx.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jun 21, 2007 at 04:40:55PM +0800, LIOU Payphone wrote:
> 
> my problem :

First of all, what version of e2fsprogs and kernel are you using?n

> (1) when i want to format /dev/sda1 to be ext3-filesystem, i  set
> "s_def_hash_version" of "struct ext3_super_block" to be "DX_HASH_LEGACY".
> when the filesystem was formatted successfully, i mounted it under a
> directory named "/mnt". 

How did you set the s_def_hash_version?   Were you using debugfs?

And did you turn on the dir_index feature?  

With recent versions of e2fsprogs the dir_index feature is enabled
default, with DX_HASH_TEA as the default.

> (2) subsequently, i created 40000 empty regular-files under "/mnt" named
> from "0" to "39999".
> (3) then , "ls -li  /mnt" was executed; i saw a puzzling thing : there are
> two indentical entries of the directory named "mnt"!  both inode->i_ino and
> filename are in the same. 

Huh?  What do you mean by that?  Are you seeing two entries named
"mnt" in the /mnt directory?   I wasn't able to reproduce this.

> 32203 -rwxrwxrwx 1 liupf liupf 0 Jun 14 11:37 24010
> 32204 -rwxrwxrwx 1 liupf liupf 0 Jun 14 11:37 24011
> 32205 -rwxrwxrwx 1 liupf liupf 0 Jun 14 11:37 24012
> 32206 -rwxrwxrwx 1 liupf liupf 0 Jun 14 11:37 24013 
> 32207 -rwxrwxrwx 1 liupf liupf 0 Jun 14 11:37 24014
> 32208 -rwxrwxrwx 1 liupf liupf 0 Jun 14 11:37 24015
> 32209 -rwxrwxrwx 1 liupf liupf 0 Jun 14 11:37 24016
> 33220 -rwxrwxrwx 1 liupf liupf 0 Jun 14 11:37 25027
> 3220 -rwxrwxrwx 1 liupf liupf 0 Jun 14 11:31 3090
> 3350 -rwxrwxrwx 1 liupf liupf 0 Jun 14 11:31 3220
> 3350 -rwxrwxrwx 1 liupf liupf 0 Jun 14 11:31 3220

You didn't list any "mnt" entries above.  So I don't know what you saw.

						- Ted
