From: Solofo.Ramangalahy@bull.net
Subject: Re: mke2fs and lazy_itable_init
Date: Wed, 27 Aug 2008 11:29:13 +0200
Message-ID: <18613.7785.128407.136911@frecb006361.adech.frec.bull.fr>
References: <20080508224847.GR3627@webber.adilger.int>
	<20080509021827.GA8871@mit.edu>
	<20080509081929.GD3627@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@sun.com>
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:51252 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912AbYH0J3j (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 27 Aug 2008 05:29:39 -0400
Cc: linux-ext4@vger.kernel.org
In-Reply-To: <20080509081929.GD3627@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>>>>> On Fri, 09 May 2008 02:19:30 -0600, Andreas Dilger <adilger@sun.com> said:

    Andreas> On May 08, 2008 22:18 -0400, Theodore Ts'o wrote:
    >> On Thu, May 08, 2008 at 04:48:47PM -0600, Andreas Dilger wrote:
    >> > I just noticed lazy_itable_init in the mke2fs.8.in man page.
    >> I think > a warning needs to be added there that this is not
    >> currently safe to > use, because the kernel does not yet do the
    >> background zeroing.  There > is nothing in the man page to
    >> indicate that this is unsafe...
    >> 
    >> Yeah, I was hoping we would actually get this fixed before 1.41
    >> was released....  (i.e., implement the background zeroing).

    Andreas> It would still be an issue for 2.6.24 and 2.6.25 kernels,
    Andreas> so I think it at least deserves a warning until there is
    Andreas> a specific kernel that can be referenced that has this
    Andreas> functionality.

I think this patch (from Andreas) would be good for e2fsprogs 1.41.1,
as discussed at Monday call.

-- 
solofo

Index: b/misc/mke2fs.8.in
===================================================================
--- a/misc/mke2fs.8.in
+++ b/misc/mke2fs.8.in
@@ -221,6 +221,12 @@ initialization noticeably, but it requir
 initializing the filesystem in the background when the filesystem is
 first mounted.  If the option value is omitted, it defaults to 1 to
 enable lazy inode table initialization.
+. BR NOTE:
+No kernels do the background zeroing of the inode table at this time,
+so this option is unsafe for production use, due to the risk of
+filesystem corruption if e2fsck has to scan the whole inode table for
+some reason (e.g. incorrect group descriptor checksum).
+
 .TP
 .B test_fs
 Set a flag in the filesystem superblock indicating that it may be
