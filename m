From: "LIOU Payphone" <lioupayphone@gmail.com>
Subject: Re: ask for help; hash-directory machanism of ext3 cannot work well
Date: Fri, 22 Jun 2007 09:52:55 +0800
Message-ID: <467b2b7b.0f98600a.1bbc.ffff9c53@mx.google.com>
References: <20070621165749.GA5664@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
Cc: <linux-ext4@vger.kernel.org>
To: "'Theodore Tso'" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.233]:60973 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbXFVBxC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Jun 2007 21:53:02 -0400
Received: by wr-out-0506.google.com with SMTP id q50so628059wrq
        for <linux-ext4@vger.kernel.org>; Thu, 21 Jun 2007 18:53:00 -0700 (PDT)
In-Reply-To: <20070621165749.GA5664@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hello, Ted. I think I failed to represent it very well. But many thanks. :-)

What makes me puzzled is there are two entries both  named  "3220" with ino
"3350" were shown under "/mnt" when I "ls  -li  /mnt".
The version of kernel is 2.6.17-1.2142; and e2fsprogs-1.28. 
You know that we can set "s_def_hash_version" to be "DX_HASH_LEAGCY" in
function  "main{}" of mke2fs.c 
But I don't know why the latest version e2fsprogs-1.39 takes "DX_HASH_TEA"
for default. Why "DX_HASH_LEAGCY" cannot be taken for default? Could you
tell me the reason for it? Thanks.  :-)

------
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
> two indentical entries under the directory named "mnt"!  both inode->i_ino
and
> filename are in the same. The filename is 3220 and ino 3350

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
