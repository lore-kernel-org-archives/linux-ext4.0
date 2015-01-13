From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] [ATTEND] [RESEND] Generic
 defragmentation strategies
Date: Tue, 13 Jan 2015 11:30:48 -0800
Message-ID: <1421177448.2076.24.camel@HansenPartnership.com>
References: <87wq4q3li0.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: lsf-pc@lists.linux-foundation.org, Theodore Ts'o <tytso@mit.edu>,
	Dave Chinner <david@fromorbit.com>,
	Christoph Hellwig <hch@infradead.org>,
	linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:56102 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751004AbbAMTav (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 13 Jan 2015 14:30:51 -0500
In-Reply-To: <87wq4q3li0.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 2015-01-13 at 15:36 +0300, Dmitry Monakhov wrote:
> Sorry, previous message was refused by lsf-pc@'s spam filter (probably due to gpg
> mime signature), this is second attempt.

I think I've found and fixed that.  All unrecognised mime types
(everything except multipart/mixed and multipart/alternative) get
rejected.  A lot of mail tools have taken to using a new type
(multipart/signed) for gpg messages, so I've added that to the
acceptable mime types.

James


