From: "Duane Griffin" <duaneg@dghda.com>
Subject: Re: [PATCH V2] dir_index: error out instead of BUG on corrupt dx dirs
Date: Tue, 11 Sep 2007 02:35:04 +0100
Message-ID: <e9e943910709101835t413753d3j3c4b3cf2fa769d72@mail.gmail.com>
References: <46D8D30B.6090703@redhat.com>
	 <20070909131933.GA15229@dastardly.plus.com>
	 <46E55BD0.30500@redhat.com>
	 <e9e943910709101506p555c6c0co8ce4529f90e814e8@mail.gmail.com>
	 <46E5C82C.907@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "linux-kernel Mailing List" <linux-kernel@vger.kernel.org>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	"ext4 development" <linux-ext4@vger.kernel.org>
To: "Eric Sandeen" <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.185]:19727 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757314AbXIKBfG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 10 Sep 2007 21:35:06 -0400
Received: by rv-out-0910.google.com with SMTP id k20so1187500rvb
        for <linux-ext4@vger.kernel.org>; Mon, 10 Sep 2007 18:35:05 -0700 (PDT)
In-Reply-To: <46E5C82C.907@redhat.com>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 10/09/2007, Eric Sandeen <sandeen@redhat.com> wrote:
> I don't know if it's worth differentiating messages for different types
> of corruption (root block vs. others, etc...) - I guess the other error
> cases do.

Might be useful for a developer wanting to know exactly which error
check was triggering. Unlikely to be of much interest or use to the
user, so I wouldn't worry too much about the exact wording.

> Here's a patch rolling up yours with mine + discussed changes, and
> consolidating the fsck suggestion message.
>
> How's it look to you?  Suppose I'd better run this a bit to be sure it's
> not hitting any common cases and issuing new warnings...?

The warnings shouldn't include explicit newlines, aside from that it
looks good to me. I've tested it with the corruption utility and all
combinations (count & limit, root & indirect) seem to work correctly.

> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Acked-by: Duane Griffin <duaneg@dghda.com>

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
