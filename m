From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] jbd: change the field "b_cow_tid" of struct journal_head
 from type unsigned to tid_t
Date: Mon, 25 Jul 2011 17:19:29 +0300
Message-ID: <CAOQ4uxhr8M=+p7oWK6NevHNDm=E3qY3Aju8D0ZAc+D2M8aFG1A@mail.gmail.com>
References: <4E2D6961.9000909@gmail.com>
	<20110725134442.GA9826@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Wang Sheng-Hui <shhuiw@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, Theodore Tso <tytso@mit.edu>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:37347 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633Ab1GYOTa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 25 Jul 2011 10:19:30 -0400
In-Reply-To: <20110725134442.GA9826@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 25, 2011 at 4:44 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Mon, Jul 25, 2011 at 09:02:25PM +0800, Wang Sheng-Hui wrote:
>> The patch is against 3.0
>>
>> In the definition of struct journal_head, the comment for
>> the field "unsigned b_cow_tid" says the field tracks the
>> last transaction id in which this buffer has been cowed.
>
> The correct fix is to simply remove the field, as it's entirely unused.
>

It's part of the ext4 snapshot patches, which are making their way into mainline
as slowly as one could expect them to.
This patch was merged for 2.6.39, so more users will be able to test
ext4 snapshots
independent module without having to patch their kernels, so that the
patches get proper
QA before they arrive to mainline.

Cheers,
Amir.
