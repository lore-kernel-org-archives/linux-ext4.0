From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Unify log messages in ext4
Date: Mon, 23 Nov 2009 10:16:08 -0600
Message-ID: <4B0AB548.5070608@redhat.com>
References: <4B087DEC.5010402@redhat.com> <1258918735-4496-1-git-send-email-bug-track@fisher-privat.net> <20091123103658.GA15679@duck.suse.cz> <1258976736.4103.1.camel@zwerg> <20091123115513.GD15679@duck.suse.cz> <20091123141108.GC2532@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>,
	Alexey Fisher <bug-track@fisher-privat.net>,
	Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54594 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754600AbZKWQQJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Nov 2009 11:16:09 -0500
In-Reply-To: <20091123141108.GC2532@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

tytso@mit.edu wrote:
> On Mon, Nov 23, 2009 at 12:55:14PM +0100, Jan Kara wrote:
>> On Mon 23-11-09 12:45:36, Alexey Fisher wrote:
>>> Am Montag, den 23.11.2009, 11:36 +0100 schrieb Jan Kara:
>>>> Thanks for the patch. I've merged it into my tree just with the following
>>>> typo fixes.
>>> Thank you,
>>> are there any ext4 patches around? Or this will be my next step. 
>>   I'm not aware of them...
> 
> Ext4 is using ext4_msg() already.  Eric Sandeen added it a while ago,
> and the idea to convert ext2 and ext4 to use ext2_msg() and ext3_msg()
> came from ext4.
> 
> 					- Ted

Actually, I think Andi originally sent it for ext3, and I motivated to
do it for ext4; the ext3 patch from Andi got lost...

-Eric
