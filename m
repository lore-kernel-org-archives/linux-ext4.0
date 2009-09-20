From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: howto downgrade ext4 to ext3
Date: Sat, 19 Sep 2009 20:14:23 -0500
Message-ID: <4AB581EF.7050701@redhat.com>
References: <4AB39EC5.6070107@it-sudparis.eu> <20090918175851.GH26991@mit.edu> <4AB3D060.2020101@redhat.com> <20090918193456.GA27303@mit.edu> <4AB3F9C4.1010702@it-sudparis.eu> <20090918225834.GC28781@mit.edu> <4AB53F3E.4040007@it-sudparis.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: jehan.procaccia@it-sudparis.eu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9223 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752749AbZITBO1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 19 Sep 2009 21:14:27 -0400
In-Reply-To: <4AB53F3E.4040007@it-sudparis.eu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

jehan procaccia wrote:
...

> [root@gizeh ~]
> $ getent passwd |grep 42658
> karipha:x:42658:426:Karipha 
> BOUMER:/mci/mast2008/karipha:/usr/local/bin/bash
> [root@gizeh ~]
> $ quota -s karipha
> Disk quotas for user karipha (uid 42658):
>     Filesystem  blocks   quota   limit   grace   files   quota   limit   
> grace
> /dev/mapper/VolGroup02S2IA-LVVG02Users07
>                   603M*   489M    538M   39:07    6622   50000   55000
> 
> $ find /disk07 -inum 3542694
> /disk07/mast2008/karipha/.recently-used.xbel
> 
> Other inodes incriminated showed the same result -> over-quota . So if 
> user data finally cannot be written, after all ... quota wouldn't allow 
> it anyway .

The unfortunate thing in your situation though is that the user 
-thought- it did get written, just FYI.

When quota is working properly, the denial is obvious up front.

-Eric

>> Hope this helps you understand what's going on.
>>                             - Ted
>>   
> Yes, thanks for that detailed answer.
> regards , jehan .

