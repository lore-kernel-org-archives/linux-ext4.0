From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 2/2] Add batched discard support for ext4
Date: Wed, 14 Jul 2010 11:40:56 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1007141101110.2980@localhost>
References: <1278489212-12110-1-git-send-email-lczerner@redhat.com> <1278489212-12110-3-git-send-email-lczerner@redhat.com> <87tyo2a2f7.fsf@dmon-lap.sw.ru>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, eshishki@redhat.com,
	jmoyer@redhat.com, rwheeler@redhat.com, linux-ext4@vger.kernel.org,
	sandeen@redhat.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48939 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752895Ab0GNJlD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 14 Jul 2010 05:41:03 -0400
In-Reply-To: <87tyo2a2f7.fsf@dmon-lap.sw.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 14 Jul 2010, Dmitry Monakhov wrote:

> Lukas Czerner <lczerner@redhat.com> writes:
> 
> > Walk through each allocation group and trim all free extents. It can be
> > invoked through TRIM ioctl on the file system. The main idea is to
> > provide a way to trim the whole file system if needed, since some SSD's
> > may suffer from performance loss after the whole device was filled (it
> > does not mean that fs is full!).
> >
> > It search fro free extents in each allocation group. When the free
> > extent is found, blocks are marked as used and then trimmed. Afterwards
> > these blocks are marked as free in per-group bitmap.
> Looks ok, except two small notes:
> 1) trim_fs is a time consuming operation and we have to add
>    condresced, and signal_pending checks to allow user to interrupt
>    cmd if necessery. See patch attached.

Hi, Dimitry

thanks for your patch! Although I have one question:


 	for (group = 0; group < ngroups; group++) {
-		int err;
-
-		err = ext4_mb_load_buddy(sb, group, &e4b);
-		if (err) {
+		ret = ext4_mb_load_buddy(sb, group, &e4b);
+		if (ret) {
 			ext4_error(sb, "Error in loading buddy "
 					"information for %u", group);
-			continue;
+			break;
 		}

Is there really need to jump out from the loop and exit in the case of
load_buddy failure ? Next group may very well succeed in loading buddy,
or am I missing something ?

> 2) IMHO runtime trim support is useful sometimes, for example when
>    user really care about data security i.e. unlinked file should be
>    trimmed ASAP. I think we have to provide 'secdel' mount option
>    similar to secdeletion flag for inode, but this is another story
>    not directly connected with the patch.

I like the idea, but IMO this should work for any underlying storage,
not just for SSDs.

Thanks!
-Lukas
