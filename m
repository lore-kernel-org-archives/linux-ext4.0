From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: Porting Zfs features to ext2/3
Date: Thu, 07 Aug 2008 14:01:46 +0200
Message-ID: <87bq056nkl.fsf@frosties.localdomain>
References: <18674437.post@talk.nabble.com> <1217199281.6992.0.camel@telesto>
	<20080727233855.GB9378@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:37401 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756781AbYHGM2s (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 7 Aug 2008 08:28:48 -0400
Received: from smtp05.web.de (fmsmtp05.dlan.cinetic.de [172.20.4.166])
	by fmmailgate02.web.de (Postfix) with ESMTP id 6A146E834F9E
	for <linux-ext4@vger.kernel.org>; Thu,  7 Aug 2008 14:01:47 +0200 (CEST)
Received: from [85.216.73.182] (helo=frosties.localdomain)
	by smtp05.web.de with asmtp (TLSv1:AES256-SHA:256)
	(WEB.DE 4.109 #226)
	id 1KR4Bf-0008Pc-00
	for linux-ext4@vger.kernel.org; Thu, 07 Aug 2008 14:01:47 +0200
Received: from mrvn by frosties.localdomain with local (Exim 4.69)
	(envelope-from <goswin-v-b@web.de>)
	id 1KR4Be-0001uF-FR
	for linux-ext4@vger.kernel.org; Thu, 07 Aug 2008 14:01:46 +0200
In-Reply-To: <20080727233855.GB9378@mit.edu> (Theodore Tso's message of "Sun,
	27 Jul 2008 19:38:55 -0400")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso <tytso@mit.edu> writes:

> On Sun, Jul 27, 2008 at 04:54:41PM -0600, Eric Anopolsky wrote:
>> On Sun, 2008-07-27 at 01:49 -0700, postrishi wrote:
>> > Hello
>> > 
>> > I want to know that has any work been done to port the Zfs features to
>> > ext2/3
>> 
>> Did you know that ZFS is available for Linux?
>
> ZFS is available in a FUSE filesystem.  As a userspace filesystem, it
> means a huge number of context switches to get data between the disk,
> to the kernel, to the FUSE userspace, back to the kernel, and to the
> process trying to access the ZFS file.  That's not going to be high
> performance.  For someone who wants to migrate from Solaris to Linux,
> it might be useful, but I'm not sure you would really want to use a
> ZFS/FUSE implementation in production.

In most situations the limiting factor is the users
harddisk. Esspecially for metadata the seek time is the real limiting
factor. In the case of ZFS there is another big factor though, the
checksumming. A kernel implementation could use the async crypto
engine and take advantage of hardware checksumming.

To truely compete with a kernel ZFS there would have to be an
interface for passing data to the crypto engine from
userspace. Combine that with splice or some other zero copy solution
and the performance will be mostly the same.


On the other hand never forget how complex the filesystem code is in
the kernel. One of the biggest advantages of fuse is the simplicity of
the code. As such it is much easier to get the codebase stable.

MfG
        Goswin
