From: Dmitry Monakhov <dmonlist@gmail.com>
Subject: Re: [PATCH-v2 08/20] ext4 crypto: add encryption key management facilities
Date: Fri, 29 May 2015 20:55:17 +0300
Message-ID: <87wpzrmfp6.fsf@openvz.org>
References: <1428894996-7852-1-git-send-email-tytso@mit.edu> <1428894996-7852-9-git-send-email-tytso@mit.edu> <87382im95e.fsf@openvz.org> <20150527170606.GA31840@thunk.org> <20150527183724.GA18540@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	mhalcrow@google.com, Ildar Muslukhov <muslukhovi@gmail.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-la0-f54.google.com ([209.85.215.54]:33878 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755347AbbE2R5u (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 29 May 2015 13:57:50 -0400
Received: by laat2 with SMTP id t2so61463816laa.1
        for <linux-ext4@vger.kernel.org>; Fri, 29 May 2015 10:57:48 -0700 (PDT)
In-Reply-To: <20150527183724.GA18540@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--=-=-=
Content-Type: text/plain

Theodore Ts'o <tytso@mit.edu> writes:

> On Wed, May 27, 2015 at 01:06:06PM -0400, Theodore Ts'o wrote:
>> 
>> That's not true.  If the attacker finds the encryption key for an
>> inode, and they have the nonce which is stored in file's extended
>> attribute, what the attacker has is a single plaintext/ciphertext
>> pair.  That doesn't imply that they can get the master key; they would
>> still need to do a brute force search on the keyspace try to find the
>> master key.
>
> So an update, after conferring with Michael Halcrow, who set me
> straight.  I was wrong, because I mixed up which was the deriving key
> and which was the source key.  You're correct; if an attacker could
> get ahold of the per-file key, they could use the nonce to decrypt it
> and obtain the master key.
>
> However, there are only two ways to determine the per-file key.  The
> first is a ring 0 compromise, in which case it's likely they could get
> access to the master key, and the second is if there is a practical
> known-plaintext attack on AES, and the attacker has access to the
> block device --- and possibly a chosen-plaintext attack if the
> attacker can control what data is written to the file.  But either
> way, if there is such a crypto-analytic attack on AES, then this is
> going to be least of the whole world's problems.  :-)
Ohh. My knowledge in cryptography is very weak, but imagine same
practical scenarios where attacker can find dozens of files with
known content by using knowledge of inode attributes and environment.
Let's consider user encrypted his encrypted chroot-environment, so
attacker may try to compare file attributes (permission, size and
directory nesting level) with files from distro repositories (rpm/deb) 

For example let's comare two directories encrypted one and my /bin/
kvm-xfstests:~# ls -l /vdc/X/4BbchaihxJLF5D+gErB0DC/ | sort -k 5
 -n | tail -
 -rwxr-xr-x 1 root root  202936 May 29 17:09 l51q60ZbBvtGnUl8a3y3yA
 -rwxr-xr-x 1 root root  219392 May 29 17:09 5NluBcuHcBAb6J6ByLUtBC
 -rwxr-xr-x 1 root root  235768 May 29 17:09 lrFAT0jlaLHwenJ2PqwiEA
 -rwxr-xr-x 1 root root  290816 May 29 17:09 P7A5KsxbBO4Dyv8ofxedhA
 -rwxr-xr-x 1 root root  309488 May 29 17:09 PeOSBWm54qDpEMCov6TqSC
 -rwxr-xr-x 1 root root  313584 May 29 17:09 TEGrdRgB2KxMFqysRtg6LB
 -rwxr-xr-x 1 root root  314560 May 29 17:09 e6waVwHbgdmx97A,CncgxD
 -rwxr-xr-x 1 root root  358072 May 29 17:09 Zz51PHoSv91wjUjn9sCypB
 -rwxr-xr-x 1 root root  538904 May 29 17:09 ulVnXayZZW0SdYp3fJe83B
 root@kvm-xfstests:~# ls -l /bin  | sort -k 5 -n | tail -n10
 -rwxr-xr-x 1 root root  202936 Oct  3  2014 grep
 -rwxr-xr-x 1 root root  219392 Dec  5 09:13 journalctl
 -rwxr-xr-x 1 root root  235768 Dec  5 09:13 systemd-inhibit
 -rwxr-xr-x 1 root root  280816 Dec  5 09:13 machinectl
 -rwxr-xr-x 1 root root  309488 Dec  5 09:13 loginctl
 -rwxr-xr-x 1 root root  313584 Dec  5 09:13 udevadm
 -rwxr-xr-x 1 root root  314560 Sep  5  2014 ip
 -rwxr-xr-x 1 root root  358072 Nov  8  2014 tar
 -rwxr-xr-x 1 root root  538904 Dec  5 09:13 systemctl
 -rwxr-xr-x 1 root root 1029624 Nov 12  2014 bash

This gives me as an attacker very good guess that
l51q60ZbBvtGnUl8a3y3yA == grep and so on, So I have can try brute force
attack on first block (But AFAIU it is not practical for AES-256)
May be we can prevent this my tweak inode size if key is not
available. For example allign i_size to fsblock which makes distro-based
attack impractical. See patch attached.

>
> There are alternatives, such as either using the master to encrypt the
> nonce and none+1: (AES-256-ENCRYPT(nonce) || AES-256-ENCRYPT
> (nonce+1)).  But this will be 40% slower than what we are currently
> doing, which is to use AES-256 to encrypt the master key.
>
At least it would be reasonable to provide this as an mkfs/tune2fs
option. I'll try to prepare patches. 
> Or we could use an HMAC, which would be even slower yet, especially
> since many chips have AES acceleration, but few have SHA hardware
> acceleration.
>
> So ultimately, the question is whether we want to make a change (with
> all of the versioning work we would need for backwards compatibility)
> that decreases performance, which will be especially noticeable for
> small files, to protect against a partial Ring 0 compromise when other
> Ring 0 compromise would make us be toast anyway.
>
> 						- Ted


--=-=-=
Content-Type: text/x-diff
Content-Disposition: inline; filename=ext4-tweak-inode-size.patch

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 0554b0b..e45cec4 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4790,6 +4790,10 @@ int ext4_getattr(struct vfsmount *mnt, struct dentry *dentry,
 	inode = d_inode(dentry);
 	generic_fillattr(inode, stat);
 
+	/* Tweak inode size for encrypted inodes */
+	if (unlikely(ext4_encrypted_inode(inode) && ext4_get_encryption_info(inode) == -ENOKEY))
+		stat->size = (stat->size + stat->blksize - 1 ) & ~(stat->blksize - 1);
+
 	/*
 	 * If there is inline data in the inode, the inode will normally not
 	 * have data blocks allocated (it may have an external xattr block).

--=-=-=--
