From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH 1/5] vfs: Add additional owner identifier
Date: Thu, 11 Mar 2010 12:40:11 -0700
Message-ID: <5010E133-F62A-4F97-AB58-73BF30A347ED@sun.com>
References: <1267727677-11956-1-git-send-email-dmonakhov@openvz.org>
 <1267727677-11956-2-git-send-email-dmonakhov@openvz.org>
 <20100311120152.GA4706@infradead.org> <87hbonj942.fsf@openvz.org>
 <20100311185135.GA27145@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7BIT
Cc: Dmitry Monakhov <dmonakhov@openvz.org>,
	Christoph Hellwig <hch@infradead.org>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Jan Kara <jack@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>
To: "J. Bruce Fields" <bfields@fieldses.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:44155 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933868Ab0CKTkT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Mar 2010 14:40:19 -0500
In-reply-to: <20100311185135.GA27145@fieldses.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-03-11, at 11:51, J. Bruce Fields wrote:
> On Thu, Mar 11, 2010 at 04:11:57PM +0300, Dmitry Monakhov wrote:
>> Christoph Hellwig <hch@infradead.org> writes:
>>> There's really no reason to make this a config option.
>> Project id feature is not likely to be widely used (i hope only
>> at the beginning). Personally this is not bad to avoid config option.
>> At least we will have many new users for free. But I predict
>> many angry voices against enabling this feature by default.
>
> How would those "angry voices" notice this feature?


The embedded folks are continually complaining about kernel bloat.

I don't see it as a bad thing that there is a config option for a  
feature that will likely be used by < 1% of Linux users.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

