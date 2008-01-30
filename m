From: supersud501 <supersud501@yahoo.de>
Subject: Re: [PATCH, RFC] Add new "development flag" to the ext4 filesystem
Date: Thu, 31 Jan 2008 00:03:03 +0100
Message-ID: <47A10227.8080005@yahoo.de>
References: <20080122231707.GA21968@mit.edu> <47A0F98C.1080304@yahoo.de> <20080130224820.GA20529@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp009.mail.ukl.yahoo.com ([217.12.11.63]:32887 "HELO
	smtp009.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1761387AbYAaB3Y (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Jan 2008 20:29:24 -0500
In-Reply-To: <20080130224820.GA20529@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:

> 
> You can manually set the flag using debugfs:
> 
>     # debugfs -w /dev/hdXX
>     debugfs: set_super_value s_flags 4
>     debugfs: quit
> 
> (Or, if you're lazy, you can also type the shorthand "ssv flags 4" to
> debugfs.)
> 
> With e2fsprogs 1.40.5, if the test_fs flag is set, then blkid will
> return a filesystem type ext4dev, such that if your mount is
> configured to use blkid (instead of vol_id), it will automatically use
> ext4dev to mount a filesystem that has (a) a journal (since ext4
> currently requires a journal), and (b) the test_fs flag set.
> 
> This makes it easier for people who are testing ext4, since they will
> just be able to do something like:
> 
>       # mke2fs -j -E test_fs /dev/mapper/lvmset-test
>       # mount /dev/mapper/lvmset-test
> 
> .. and /dev/mapper/lvmset-test will automatically be mounted using
> ext4.
> 
> 							 - Ted

thanks for your quick answer! i think i've learned something more about 
ext4 and those flags.
