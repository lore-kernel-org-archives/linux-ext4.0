From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: s390x: kernel BUG at fs/ext4/inode.c:1591! (powerpc too!)
Date: Tue, 02 Apr 2013 13:47:44 +0400
Message-ID: <877gkls1q7.fsf@openvz.org>
References: <2133129347.8273339.1364549222854.JavaMail.root@redhat.com> <87ip46ss0o.fsf@openvz.org> <1211053180.322948.1364797847717.JavaMail.root@redhat.com> <87fvzaspr8.fsf@openvz.org> <874841142.414482.1364875584266.JavaMail.root@redhat.com> <alpine.DEB.2.10.1304012249440.5874@trent.utfs.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Cc: Theodore Ts'o <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>,
	linux-s390 <linux-s390@vger.kernel.org>,
	Steve Best <sbest@redhat.com>, linux-ext4@vger.kernel.org
To: Christian Kujau <lists@nerdbynature.de>,
	CAI Qian <caiqian@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-la0-f47.google.com ([209.85.215.47]:52437 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757780Ab3DBJru (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 2 Apr 2013 05:47:50 -0400
In-Reply-To: <alpine.DEB.2.10.1304012249440.5874@trent.utfs.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--=-=-=

On Mon, 1 Apr 2013 23:15:07 -0700 (PDT), Christian Kujau <lists@nerdbynature.de> wrote:
> Hi,
> 
> my machine (PowerBook G4) just crashed and the only thing netconsole was 
> able to transmit was:
> 
>   ------------[ cut here ]------------
>   kernel BUG at /usr/local/src/linux-git/fs/ext4/inode.c:1591!
> 
> But (unfortunately) nothing more. I have no clear way to reproduce this, 
> but I have some kind of a (longish) backstory to this, see below. The 
> system is running 3.9-rc4, its .config and dmesg:
> 
>   http://nerdbynature.de/bits/3.9.0-rc1/config.gz (oldconfig'ed to -rc4)
>   http://nerdbynature.de/bits/3.9.0-rc1/dmesg.txt (w/o the calltrace at the end)
> 
> 
> I was having trouble all day downloading a file via bittorrent to an 
> ext4 filesystem. It came always back as corrupted, though I won't be able 
> to point out the corruption, as don't know the contents of the source 
> file. The ext4 filesystem sits on top of a dm-crypt LUKS device:
> 
>  /dev/mapper/wdc0 on /mnt/data type ext4 (rw,nosuid,nodev,noexec,relatime,data=ordered)
> 
> While looking around as to why the file would be corrupt, the internet 
> suggested "bad memory" or "bad disk" or "kernel bugs". I have dismissed 
> the first two, as the system is rock-stable otherwise and dmesg has no 
> kernel messages suggesting disk or filesystem problems.
Unfortunately it is like a regression which we missed
due to s390x and ppc is not well tested.
> 
> The file in question is ~800 MB in size. Not getting any further on a 
> solution to my corrupted file, I decided to download a 4.3GB Fedora 
> installation image via bittorrent to the same filesystem and that's when 
> the machine crashed, leaving only the single BUG message as a hint.
Ohh that is sad. Unfortunately I can't reproduce this on my own
environment. I have power mac pro G5 but w/o graphics card, so i cant
install linux on it. If you know how to do that w/o monitor please let
me know.

So you just do bunch of writes/mmap to fallocated area.
The only guess I have is that some bug in extent status tree

Please run test with a patch which was posted here:
http://marc.info/?l=linux-kernel&m=136455173926544&w=2
This patch enable sanity checks for extent_status tree.
Also please try following patch. It voluntary disable es_lookup functionality.

--=-=-=
Content-Type: text/x-patch
Content-Disposition: inline; filename=disable-es_lookup_extent.patch

diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
index fe3337a..95d27cd 100644
--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@ -689,6 +689,7 @@ int ext4_es_lookup_extent(struct inode *inode, ext4_lblk_t lblk,
 	trace_ext4_es_lookup_extent_enter(inode, lblk);
 	es_debug("lookup extent in block %u\n", lblk);
 
+	return 0;
 	tree = &EXT4_I(inode)->i_es_tree;
 	read_lock(&EXT4_I(inode)->i_es_lock);
 

--=-=-=

> 
> The system is back now, e2fsck-1.42.5 came back with no errors.
> 
> Thanks for reading,
> Christian.
> 
> PS: somewhat off-topic, but: is there a way to have BUG_ON print only
>     fs/ext4/inode.c:1591! instead of the full pathname? Is there are
>     config option for this?
> -- 
> BOFH excuse #339:
> 
> manager in the cable duct

--=-=-=--
