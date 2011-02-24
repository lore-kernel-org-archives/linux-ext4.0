From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: enable acls and user_xattr by default
Date: Thu, 24 Feb 2011 11:49:13 -0500
Message-ID: <20110224164913.GT2924@thunk.org>
References: <4D5ED705.7010902@redhat.com>
 <20110221134642.GC6584@quack.suse.cz>
 <4D629C78.60600@redhat.com>
 <20110223173152.GM2924@thunk.org>
 <20110224114914.GD23042@quack.suse.cz>
 <4688CF7A-2859-465B-B0EC-B4E31800E5F2@mit.edu>
 <20110224135740.GF23042@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:34298 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755536Ab1BXQtT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 24 Feb 2011 11:49:19 -0500
Content-Disposition: inline
In-Reply-To: <20110224135740.GF23042@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 24, 2011 at 02:57:40PM +0100, Jan Kara wrote:
>   I've actually tried that before posting my email and it's not like that.
> I did:
> jack@quack:~/source> echo 'aaa' >/tmp/f
> jack@quack:~/source> chmod 600 /tmp/f
> jack@quack:~/source> setfacl -m u:nobody:rw /tmp/f
> jack@quack:~/source> sudo su nobody -c "cat /tmp/f"
> aaa
> jack@quack:~/source> sudo su news -c "cat /tmp/f"
> cat: /tmp/f: Permission denied

Hmm... yes, but it's a bit more complicated.  Look at this, and note
how remounting the file system without acl's gave the group "users" rw
access to the file /mnt/f.

						- Ted

<tytso.root@tytso-glaptop> {/}  
2100# mount -o acl /dev/funarg/test /mnt
<tytso.root@tytso-glaptop> {/}  
2101# echo aaa > /mnt/f
<tytso.root@tytso-glaptop> {/}  
2102# chown root:users /mnt/f
<tytso.root@tytso-glaptop> {/}  
2103# chmod 400 /mnt/f
<tytso.root@tytso-glaptop> {/}  
2104# ls -l /mnt/f
4 -r-------- 1 root users 4 Feb 24 11:46 /mnt/f
<tytso.root@tytso-glaptop> {/}  
2105# setfacl -m u:tytso:rw /mnt/f
<tytso.root@tytso-glaptop> {/}  
2106# getfacl /mnt/f
getfacl: Removing leading '/' from absolute path names
# file: mnt/f
# owner: root
# group: users
user::r--
user:tytso:rw-
group::---
mask::rw-
other::---

<tytso.root@tytso-glaptop> {/}  
2107# ls -l /mnt/f
8 -r--rw----+ 1 root users 4 Feb 24 11:46 /mnt/f
<tytso.root@tytso-glaptop> {/}  
2108# umount /mnt
<tytso.root@tytso-glaptop> {/}  
2109# mount -o noacl /dev/funarg/test /mnt
<tytso.root@tytso-glaptop> {/}  
2110# ls -l /mnt/f
8 -r--rw---- 1 root users 4 Feb 24 11:46 /mnt/f



