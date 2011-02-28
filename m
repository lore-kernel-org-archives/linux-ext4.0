From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext3: skip orphan cleanup on rocompat fs
Date: Mon, 28 Feb 2011 13:05:08 -0600
Message-ID: <4D6BF1E4.6010503@redhat.com>
References: <AANLkTimLAL7hPL+Yb392hyVAWEfHtObv7WwjzKt2awur@mail.gmail.com> <20110228101454.GE4834@bitwizard.nl> <20110228182201.GE20805@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Rogier Wolff <R.E.Wolff@BitWizard.nl>,
	Amir Goldstein <amir73il@gmail.com>,
	Theodore Tso <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22215 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752712Ab1B1TFP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Feb 2011 14:05:15 -0500
In-Reply-To: <20110228182201.GE20805@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2/28/11 12:22 PM, Jan Kara wrote:
> On Mon 28-02-11 11:14:55, Rogier Wolff wrote:
>>
>> On Sat, Feb 26, 2011 at 10:40:19PM +0200, Amir Goldstein wrote:
>>> This patch skips the orphan cleanup if readonly compatible features
>>> would prevent the fs from being mounted (or remounted) readwrite.
>>
>> I use the "mount readonly" option to, for instance, view/check the
>> filesystem to determine wether or not I need to fsck first. I use the
>> "readonly" feature to prevent the mounting to be a mistake-prone
>> situation. It prevents e.g. applications from dropping temporary files
>> in my current directory.
>>
>> Every time fsck or such a cleanup does something, there is the option
>> of the cleanup or fixup being wrong. When you honour the "readonly"
>> request from the user, the careful user can go back to the situation
>> where he/she started.
>>
>> If the cleanup/fixup is really neccesary, do so in in-core buffers of
>   Mounting (even read-only) without recovering the journal will give you a
> view of a corrupted filesystem. Usually not what you want (although I agree
> with you that there are occasions where this *is* what you want).

Also, you can tell ext3/4 -not- to recover the journal, or, you can mark the
device RO before mount.  So while not the default behavior, it is at least
possible.

-Eric
