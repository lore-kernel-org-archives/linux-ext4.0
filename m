From: Ric Wheeler <ricwheeler@gmail.com>
Subject: Re: [PATCH 2/2] ext4: Automatically enable journal_async_commit on
 ext4 file systems
Date: Mon, 07 Sep 2009 19:42:58 -0400
Message-ID: <4AA59A82.9090502@gmail.com>
References: <1252189963-23868-1-git-send-email-tytso@mit.edu> <1252189963-23868-2-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.221.181]:47560 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793AbZIGXm5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Sep 2009 19:42:57 -0400
Received: by qyk11 with SMTP id 11so2358583qyk.1
        for <linux-ext4@vger.kernel.org>; Mon, 07 Sep 2009 16:43:00 -0700 (PDT)
In-Reply-To: <1252189963-23868-2-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Ts'o wrote:
> Now that we have cleaned up journal_async_commit, it's safe to enable
> it all the time.  But we only want to do so if ext4-specific INCOMPAT
> features are enabled, since otherwise we will prevent the filesystem
> from being mounted using ext3.
>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>   

Hi Ted,

I am not sure that we are really good with ASYNC commit being on all of 
the time - I really worry that we will see lots of issues.

Can we leave it off by default until we get some run time on it?

Ric

