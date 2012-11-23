From: Andreas Dilger <aedilger@gmail.com>
Subject: Re: e2fsck repeatedly asks to clear the same entry?
Date: Fri, 23 Nov 2012 12:18:42 -0700
Message-ID: <07FA29B6-B150-4A93-B6FF-3072DF31B577@gmail.com>
References: <k8of5a$sjb$1@ger.gmane.org>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Mark Casey <markc@unifiedgroup.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63394 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753818Ab2KWTXk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 23 Nov 2012 14:23:40 -0500
Received: by mail-pb0-f46.google.com with SMTP id wy7so6688892pbc.19
        for <linux-ext4@vger.kernel.org>; Fri, 23 Nov 2012 11:23:39 -0800 (PST)
In-Reply-To: <k8of5a$sjb$1@ger.gmane.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-11-23, at 11:26, Mark Casey <markc@unifiedgroup.com> wrote:
> I'm in a bit of a loop trying to fix my ext4 filesystem; it always goes like this even after several passes.
> 
>> root@host:/home/luser# /root/latest/sbin/e2fsck -f /dev/vgdalr6/lv1
>> e2fsck 1.42.5 (29-Jul-2012)
>> Pass 1: Checking inodes, blocks, and sizes
>> Pass 2: Checking directory structure
>> Entry 'A5 11-3' in /share/path/09/Brett/Pines/Flynt's Side Drive - Complete Archive Copy/SA Version Pines/Chris Pics 11-2-10 (268533857) has deleted/unused inode 15115.  Clear<y>? yes
>> Pass 3: Checking directory connectivity
>> Pass 4: Checking reference counts
>> Pass 5: Checking group summary information
>> 
>> /dev/vgdalr6/lv1: ***** FILE SYSTEM WAS MODIFIED *****
>> /dev/vgdalr6/lv1: 8993801/268697600 files (0.8% non-contiguous), 2152234742/4299161600 blocks
>> root@host:/home/luser#
> 
> 
> Would anyone have any suggestions how to proceed?
> 
> The cause of this is that I did an unsupported resize (a shrink) by commenting out one of resize2fs' checks...as described here: (note I'm not claiming this as "permission"; I knew it might not work)

E2fsck should be able to fix (i.e. get into some consistent state) anything regardless of how it got into that state. 

> http://article.gmane.org/gmane.comp.file-systems.ext4/35375
> 
>  this current issue with the directory 'A5 11-3' is the only symptom presenting. I have most of the e2fsck log that followed the resize in case that would be of use.

It would probably be useful to get information from debugfs for this directory and inode (stats, ls -l <268533857>, stat <15115>, and checki 15115). 

Normally I'd say that getting a e2image of the filesystem would be useful for debugging and to create a test case, but since the filesystem is 16TB in size that won't be practical. 

In the worst case, it should be possible to fix this manually on debugfs either by marking the inode in use in the bitmap (seti 15115) or clear the inode number in the directory entry (on my phone right now and can't check the command for this).

It would be nice to get a test case first, so that e2fsck could be fixed, so if this isn't causing you grief it would be nice to keep this around until there is a chance to understand the problem. 

Cheers, Andreas