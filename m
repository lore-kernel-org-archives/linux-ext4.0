From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH e2fsprogs] libblkid: detect squashfs
Date: Mon, 15 Oct 2007 12:48:44 -0500
Message-ID: <4713A7FC.3080507@redhat.com>
References: <46F93F3A.7080406@redhat.com> <20071014141242.GA6724@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:41764 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757572AbXJORtq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 15 Oct 2007 13:49:46 -0400
In-Reply-To: <20071014141242.GA6724@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Theodore Tso wrote:

> On Tue, Sep 25, 2007 at 12:02:50PM -0500, Eric Sandeen wrote:
>   
>> libblkid: recognize squashfs filesystems
>>
>> squashfs has no uuid or labels, so all we need is the magic.
>>
>> Addresses-Red-Hat-Bugzilla: #305151
>>     
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>>     
>
> Thanks, applied to the maint branch.
>
> 				- Ted
>   
Thanks... and now for the big endian version.  :(  Sorry about that!

===================

libblkid: recognize squashfs filesystems on BE systems.

squashfs has no uuid or labels, so all we need is the magic
(for big-endian too!)

Addresses-Red-Hat-Bugzilla: #305151
    
Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Index: e2fsprogs-1.40.2/lib/blkid/probe.c
===================================================================
--- e2fsprogs-1.40.2.orig/lib/blkid/probe.c
+++ e2fsprogs-1.40.2/lib/blkid/probe.c
@@ -898,6 +898,7 @@ static struct blkid_magic type_array[] =
   { "ocfs2",	 4,	 0,  6,	"OCFSV2",		probe_ocfs2 },
   { "ocfs2",	 8,	 0,  6,	"OCFSV2",		probe_ocfs2 },
   { "crypt_LUKS", 0,	 0,  6,	"LUKS\xba\xbe",		probe_luks },
+  { "squashfs",	 0,	 0,  4,	"sqsh",			0 },
   { "squashfs",	 0,	 0,  4,	"hsqs",			0 },
   {   NULL,	 0,	 0,  0, NULL,			NULL }
 };
