From: Andreas Dilger <adilger@whamcloud.com>
Subject: Re: Questions about dx --- hash conflicts and limit
Date: Tue, 31 Jul 2012 11:56:49 -0700
Message-ID: <ADFAE24A-7440-4AA3-B74E-F8431D6C0F26@whamcloud.com>
References: <5017D9B8.5080103@gmail.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Wang Sheng-Hui <shhuiw@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:63449 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547Ab2GaS4u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 31 Jul 2012 14:56:50 -0400
Received: by yhmm54 with SMTP id m54so6435624yhm.19
        for <linux-ext4@vger.kernel.org>; Tue, 31 Jul 2012 11:56:49 -0700 (PDT)
In-Reply-To: <5017D9B8.5080103@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-07-31, at 6:12, Wang Sheng-Hui <shhuiw@gmail.com> wrote:
> 
> I have 2 questions about dx in ext4:
> 
> 1) hash conflict
> 
>   I walked through the ext4/namei.c, but didn't find any
>   code dealing with hash conflicts.
> 
>   I wonder if some name hash conflicts, how can they be stored
>   and retrieved with the dir ops?

Sorry, don't have code available to look at to comment on this issue. 

> 2) limit on size of dir
> 
>   For the limit on items of the dir, the dir size is limited
>   to a height of 2 HTree: 
>       root node
>          |
>    intermidate node ...
>        |    |
>    leaf node...
> 
>   Is this right?

Correct, though this is only an implementation limit and not a format limit.

We have a patch to increase the htree depth to 3 levels and beyond 2GB directories, but it needs e2fsck support still, and it needs to be separated from a patch that also allows multi-threaded access to the same directory (though not via the VFS, unfortunately).

You can find this patch in the Lustre Git repo at git.whamcloud.com/fs/lustre-release in the ldiskfs/patches directory, if you are interested in this. 

Cheers, Andreas