From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: EXT4 nodelalloc => back to stone age.
Date: Mon, 01 Apr 2013 10:18:51 -0500
Message-ID: <5159A55B.1090302@redhat.com>
References: <87d2uese6t.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org, axboe@kernel.dk,
	Jan Kara <jack@suse.cz>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31539 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758478Ab3DAPTp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Apr 2013 11:19:45 -0400
In-Reply-To: <87d2uese6t.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 4/1/13 6:06 AM, Dmitry Monakhov wrote:

> 1)Do we really have to use WRITE_SYNC in case of WB_SYNC_ALL ?

...

> 2) Why don't we have writepages for non delalloc case ?

...

I'd add:

3) Why do we have a "nodelalloc" mount option at all?

but then I thought:

Is it also this bad when using the ext4 driver to run an ext3 fs?

-Eric

