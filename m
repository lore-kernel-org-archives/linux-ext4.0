From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: fsck.ext4 taking months
Date: Mon, 28 Mar 2011 10:07:22 -0500
Message-ID: <4D90A42A.3070401@redhat.com>
References: <4D8F1F75.8010201@psi5.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Christian Brandt <brandtc@psi5.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19482 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754184Ab1C1PH3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Mar 2011 11:07:29 -0400
In-Reply-To: <4D8F1F75.8010201@psi5.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 3/27/11 6:28 AM, Christian Brandt wrote:
> Situation: External 500GB drive holds lots of snapshots using lots of
> hard links made by rsync --link-dest. The controller went bad and
> destroyed superblock and directory structures. The drive contains
> roughly a million files and four complete directory-tree-snapshots with
> each roughly a million hardlinks.
> 
> Tried
> 
> e2fsck 1.41.12 (17-May-2010)
>         Benutze EXT2FS Library version 1.41.12, 17-May-2010
> 
> e2fsck 1.41.11 (14-Mar-2010)
>         Benutze EXT2FS Library version 1.41.11, 14-Mar-2010
> 
> Symptoms: fsck.ext4 -y -f takes nearly a month to fix the structures on
> a P4@2,8Ghz, with very little access to the drive and 100% cpu use.

Does that mean very little access to -this- drive or to -any- drive?
IOW, are you swapping madly?

-Eric

> output of fsck looks much like this:
> 
> File ??? (Inode #123456, modify time Wed Jul 22 16:20:23 2009)
>   block Nr. 6144 double block(s), used with four file(s):
>     <filesystem metadata>
>     ??? (Inode #123457, mod time Wed Jul 22 16:20:23 2009)
>     ??? (Inode #123458, mod time Wed Jul 22 16:20:23 2009)
>     ...
> multiply claimed block map? Yes
> 
> Is there an adhoc method of getting my data back faster?
> 
> Is the slow performance with lots of hard links a known issue?
> 

