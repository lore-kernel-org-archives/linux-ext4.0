From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4 encrypted dir becomes sickish after 4-5 days
Date: Wed, 14 Sep 2016 08:49:35 -0400
Message-ID: <20160914124935.yxfo42bjdlyt2beo@thunk.org>
References: <0951cedc-fff1-682c-daca-b9a1734e43e2@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-ext4@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <0951cedc-fff1-682c-daca-b9a1734e43e2@gmx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Sep 14, 2016 at 11:44:02AM +0200, Toralf Förster wrote:
> I do run a hardened stable Gentoo Linux server w/ kernel 4.7.3-ahrdened-r1 where I use an ext4fs directory /var/lib/tor in the following way :
> 
> 	scp ~/.cryptoSalt user@host:/tmp
> 	cat /tmp/.cryptoPass | ssh user@host 'sudo -u tor e4crypt add_key -S $(cat /tmp/.cryptoSalt) /var/lib/tor && sudo /etc/init.d/tor start; rm /tmp/.cryptoSalt'
> 
> Works fine after reboot.
> 
> But after 4 days or so a restart of the service "tor" fails with messages like :
> 
> Sep 14 11:27:10.000 [warn] Could not open "/var/lib/tor/data/keys/secret_id_key": Required key not available
> Sep 14 11:27:10.000 [warn] Error reading private key from "/var/lib/tor/data/keys/secret_id_key"
> Sep 14 11:27:10.000 [err] Error loading private key.
> Sep 14 11:27:10.000 [err] Error initializing keys; exiting
> Sep 14 11:27:10.000 [warn] Couldn't open "/var/lib/tor/data/state.tmp" (/var/lib/tor/data/state) for writing: Required key not available
> Sep 14 11:27:10.000 [warn] Unable to write state to file "/var/lib/tor/data/state"; will try again later
> 
> No way to get it repaired other than rebooting the machine.

What does "keyctl list @s" display?  And what hapens if you try to
rerun the add_key command?  You should see something like this:

root@kvm-xfstests:~# echo testing | e4crypt add_key -S s:NSAkey
Enter passphrase (echo disabled):
Added key with descriptor [d9edfc8381c3561a]
root@kvm-xfstests:~# keyctl list @s
2 keys in keyring:
676316311: --alswrv     0 65534 keyring: _uid.0
814379254: --alsw-v     0     0 logon: ext4:d9edfc8381c3561a

Note that by default add_key inserts the key into the session keyring,
and if other programs are messing with the session keyring, or tor
gets restarted with in a different session id, it might not have
access to the keys any more.  Depending on whether the key was just
deleted, or tor doesn't have access to the key, tor could function for
a while until the inode gets pushed out of memory, in which case it
wouldn't be able to read it back in.

Remember that the security model of the file system level encryption
is that if the key is present on the system, then Unix permissions is
what prevents another user's process from being able to read the file.
Put another way, you manage to get a particular inode is in the inode
and page cache, we do *not* do a "does the process have access to a
keyring which has a key needed to access the file" on every single
cache access.  #1 it would be way too slow, and #2, the VFS
fundamentally assumes a single view of the dentry and page cache
across the whole system, and we can't do separate instances of the
cache based on user or session id.

The flip side of this is that if you don't have your session keyrings
set up just right, you can end up with a situation where the file is
initially read into cache, and the tor daemon is running in a
different session, so while the file is still in the cache, the tor
daemon is fine, but if the file ever gets pushed out of cache, the tor
daemon doesn't have access to the keys needed to read the file from
disk.

Cheers,

						- Ted
