From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Ext4: Slow performance on first write after mount
Date: Mon, 20 May 2013 07:37:58 -0500
Message-ID: <519A1926.4050408@redhat.com>
References: <1679869241.585607.1368809483337.JavaMail.ngmail@webmail12.arcor-online.net> <20130519140023.GB7183@thunk.org> <FB0094B8-15F8-4190-ABC6-2C06C6BC2521@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	"frankcmoeller@arcor.de" <frankcmoeller@arcor.de>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21942 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756378Ab3ETMiE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 May 2013 08:38:04 -0400
In-Reply-To: <FB0094B8-15F8-4190-ABC6-2C06C6BC2521@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 5/20/13 1:39 AM, Andreas Dilger wrote:
> On 2013-05-19, at 8:00, Theodore Ts'o <tytso@mit.edu> wrote:
>> On Fri, May 17, 2013 at 06:51:23PM +0200, frankcmoeller@arcor.de wrote:
>>> - Why do you throw away buffer cache and don't store it on disk during umount? The initialization of the buffer cache is quite awful for application which need a specific write throughput.
>>> - A workaround would be to read whole /proc/.../mb_groups file right after every mount. Correct?
>>
>> Simply adding "cat /proc/fs/<dev>/mb_groups > /dev/null" to one of the
>> /etc/init.d scripts, or to /etc/rc.local is probably the simplest fix,
>> yes.
>>
>>> - I can try to add a mount option to initialize the cache at mount time. Would you be interested in such a patch?
>>
>> Given the simple nature of the above workaround, it's not obvious to
>> me that trying to make file system format changes, or even adding a
>> new mount option, is really worth it.  This is especially true given
>> that mount -a is sequential so if there are a large number of big file
>> systems, using this as a mount option would be slow down the boot
>> significantly.  It would be better to do this parallel, which you
>> could do in userspace much more easily using the "cat
>> /proc/fs/<dev>/mb_groups" workaround.
> 
> Since we already have a thread starting at mount time to check the
> inode table zeroing, it would also be possible to co-opt this thread
> for preloading the group metadata from the bitmaps. 

Only up to a point, I hope; if the fs is so big that you start dropping the
first ones that were read, it'd be pointless.  So it'd need some nuance,
at the very least least.

How much memory are you willing to dedicate to this, and how much does
it really help long-term, given that it's not pinned in any way?

As long as we don't have efficiently-searchable on-disk freespace info
it seems like anything else is just a workaround, I'm afraid.

-Eric
