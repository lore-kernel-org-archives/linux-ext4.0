From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH, RFC 0/3] Introduce new O_HOT and O_COLD flags
Date: Sat, 21 Apr 2012 14:24:12 -0400
Message-ID: <4F92FB4C.1010703@garzik.org>
References: <1334863211-19504-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:41753 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082Ab2DUSYQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 21 Apr 2012 14:24:16 -0400
In-Reply-To: <1334863211-19504-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 04/19/2012 03:20 PM, Theodore Ts'o wrote:
> As I had brought up during one of the lightning talks at the Linux
> Storage and Filesystem workshop, I am interested in introducing two new
> open flags, O_HOT and O_COLD.  These flags are passed down to the
> individual file system's inode operations' create function, and the file
> system can use these flags as a hint regarding whether the file is
> likely to be accessed frequently or not.
>
> In the future I plan to do further work on how ext4 would use these
> flags, but I want to first get the ability to pass these flags plumbed
> into the VFS layer and the code points for O_HOT and O_COLD reserved.
>
>
> Theodore Ts'o (3):
>    fs: add new open flags O_HOT and O_COLD
>    fs: propagate the open_flags structure down to the low-level fs's
>      create()
>    ext4: use the O_HOT and O_COLD open flags to influence inode
>      allocation

Full-file seems awfully coarse-grained.  What about doing this at page 
granularity, and hint via VM as well as block layer?

	Jeff




