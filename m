From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 1/5] vfs: Add additional owner identifier
Date: Fri, 12 Mar 2010 11:47:43 +0300
Message-ID: <87r5nq9b9s.fsf@openvz.org>
References: <1267727677-11956-1-git-send-email-dmonakhov@openvz.org>
	<1267727677-11956-2-git-send-email-dmonakhov@openvz.org>
	<20100311120152.GA4706@infradead.org> <87hbonj942.fsf@openvz.org>
	<20100311185135.GA27145@fieldses.org>
	<5010E133-F62A-4F97-AB58-73BF30A347ED@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "J. Bruce Fields" <bfields@fieldses.org>,
	Christoph Hellwig <hch@infradead.org>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Jan Kara <jack@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:33446 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756606Ab0CLIrr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 12 Mar 2010 03:47:47 -0500
In-Reply-To: <5010E133-F62A-4F97-AB58-73BF30A347ED@sun.com> (Andreas Dilger's
	message of "Thu, 11 Mar 2010 12:40:11 -0700")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger <adilger@sun.com> writes:

> On 2010-03-11, at 11:51, J. Bruce Fields wrote:
>> On Thu, Mar 11, 2010 at 04:11:57PM +0300, Dmitry Monakhov wrote:
>>> Christoph Hellwig <hch@infradead.org> writes:
>>>> There's really no reason to make this a config option.
>>> Project id feature is not likely to be widely used (i hope only
>>> at the beginning). Personally this is not bad to avoid config option.
>>> At least we will have many new users for free. But I predict
>>> many angry voices against enabling this feature by default.
>>
>> How would those "angry voices" notice this feature?
>
>
> The embedded folks are continually complaining about kernel bloat.
>
> I don't see it as a bad thing that there is a config option for a
> feature that will likely be used by < 1% of Linux users.
Definitely we have to hide projectid under kernel config option, bu,t
what option should it be? We have two choices
1) CONFIG_QUOTA: because most of users who use quota probably
   will also use project id support
2) introduce new config option: This may be reasonable if projectid
   may be usefull witout quota and inode size is critical.
   (i dont know such cases for now)
>
> Cheers, Andreas
> --
> Andreas Dilger
> Sr. Staff Engineer, Lustre Group
> Sun Microsystems of Canada, Inc.
