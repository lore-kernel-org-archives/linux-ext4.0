From: Eric Sandeen <esandeen@redhat.com>
Subject: Re: [PATCH 3/3] ext4: Block mmapped writes while the fs is frozen
Date: Wed, 18 May 2011 12:40:44 -0400 (EDT)
Message-ID: <B11A8487-AA73-40DB-81C8-163006369077@redhat.com>
References: <1305066574-1573-1-git-send-email-jack@suse.cz> <1305066574-1573-4-git-send-email-jack@suse.cz> <20110517151108.GB6653@infradead.org> <20110518075614.GB25632@quack.suse.cz> <20110518080731.GA2759@infradead.org> <4DD3D1AF.9060809@redhat.com> <20110518152532.GA8417@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Eric Sandeen <sandeen@redhat.com>,
	Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>,
	Ted Tso <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx4-phx2.redhat.com ([209.132.183.25]:38974 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757020Ab1ERQkz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 18 May 2011 12:40:55 -0400
In-Reply-To: <20110518152532.GA8417@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On May 18, 2011, at 10:25 AM, Jan Kara <jack@suse.cz> wrote:

> On Wed 18-05-11 09:03:27, Eric Sandeen wrote:
>> On 5/18/11 3:07 AM, Christoph Hellwig wrote:
>>> On Wed, May 18, 2011 at 09:56:14AM +0200, Jan Kara wrote:
>>>> __block_page_mkwrite() and return some error value (EAGAIN translating to
>>>> VM_FAULT_RETRY would look logical, I just have to think off better error
>>>> value for VM_FAULT_NOPAGE). But vfs_check_frozen() cannot be in
>>>> __block_page_mkwrite() since ext4 needs to call that with a transaction
>>>> started so that would create a deadlock and we need to call
>>>> vfs_check_frozen() somewhere so that we don't busyloop.
>>>> 
>>>> I can call vfs_check_frozen() inside block_page_mkwrite() but it would be a
>>>> bit surprising difference from __block_page_mkwrite() to me. Not sure what
>>>> the cleanest solution would be here...
>>> 
>>> block_page_mkwrite is supposed to be used directly by filesystems and
>>> do all the right things.  IIRC Eric even mentioned he added
>>> vfs_check_frozen to it for RHEL, but forgot to push it upstream.
>> 
>> Well, I tried, but it was rejected IIRC.  Still, mea culpa....
>> 
>> I can resurrect what I did for RHEL5 and repost if desired...
>  I've just submitted second version of the patch series. So please check
> whether it does all you need... Thanks.
> 
Thanks!  Btw the rejection I mentioned was years ago... Not you :)

-Eric

>                                    Honza
