From: "Duane Griffin" <duaneg@dghda.com>
Subject: Re: [RFC, PATCH 6/6] ext3: do not write to the disk when mounting a dirty read-only filesystem
Date: Thu, 6 Mar 2008 11:19:03 +0000
Message-ID: <e9e943910803060319y1f538a68y59bea3fae4b88bb9@mail.gmail.com>
References: <a047dfbd7855d5f484ae8a3434f6a073302505be.1204685366.git.duaneg@dghda.com>
	 <f4577a0cc4262de0fbff02cae3858d2e2edfaaea.1204685366.git.duaneg@dghda.com>
	 <20080306071734.GN3616@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	"Theodore Tso" <tytso@mit.edu>, sct@redhat.com,
	akpm@linux-foundation.org
To: "Andreas Dilger" <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.174]:8786 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754462AbYCFLTG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Mar 2008 06:19:06 -0500
Received: by wf-out-1314.google.com with SMTP id 28so2476538wff.4
        for <linux-ext4@vger.kernel.org>; Thu, 06 Mar 2008 03:19:04 -0800 (PST)
In-Reply-To: <20080306071734.GN3616@webber.adilger.int>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 06/03/2008, Andreas Dilger <adilger@sun.com> wrote:
> On Mar 06, 2008  01:59 +0000, Duane Griffin wrote:
>  > NOTE: For now I'm simply preventing filesystems requiring recovery from being
>  > remounted read-write. This breaks booting with an uncleanly mounted root
>  > filesystem!
>
> I was going to ask about this - not being able to remount rw is a serious
> problem because many users have only the root filesystem and this
> limitation basically prevents this patch from being landable.

Yep, I agree. I wanted to post this as an RFC now to get feedback on
the overall approach. I'll try and get remount support in there ASAP
and post another version.

>  I'd suggest if the filesystem is going to be remounted read/write that
>  the journal mapping be discarded and the journal replayed.  Depending
>  on how you do the mapping it may be necessary to invalidate all of the
>  pages in the cache so that they don't reference the blocks in the journal.

That was along the lines I was thinking of, too. Thanks for mentioning
invalidating the page cache -- I'll make sure that doesn't get
overlooked.

>  Cheers, Andreas

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
