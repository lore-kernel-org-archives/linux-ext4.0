From: Andreas Dilger <adilger.kernel@dilger.ca>
Subject: Re: How to remove a corrupted dir in an ext4 FS?
Date: Mon, 25 Oct 2010 22:16:55 +0800
Message-ID: <062C162D-7D68-4C2A-A6E8-B51F771E88D3@dilger.ca>
References: <201010241312.53784.melendro@terra.es>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org
To: Jesus Sanchez Melendro <melendro@terra.es>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:3713 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164Ab0JYOQ7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 25 Oct 2010 10:16:59 -0400
In-Reply-To: <201010241312.53784.melendro@terra.es>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-10-24, at 19:12, Jesus Sanchez Melendro wrote:
> After a corruption in an ext4 filesystem, I've checked and moved to the 
> correct position all the files and dirs in lost+found, but one of the dirs is 
> corrupted.
> 
> The "ls -l" command says:
> d????????? ? ? ? ? ? /lost+found/#90116
> 
> If I try to remove it with "rmdir" or "rm -rf" or "mv" or "unlink", all 
> commands say:
> <command used>: failed to remove `#90116': Input/output error
> 
> Running "fsck" says that the filesystem is OK.
> 
> Is there a way to remove that corrupted dir?

You can probably check "lsattr /lost+found/#90116" to see if either the "i" (immutable) or "a" (append-only) attribute is set.  If yes, then running "chattr -i -a/lost+found/#90116" will remove those attributes, and it should be removable.

Cheers, Andreas





