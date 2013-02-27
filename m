From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] ext4 updates for 3.9
Date: Wed, 27 Feb 2013 09:52:45 -0800
Message-ID: <CA+55aFwWA1jPEEQNx_5oJ6Ze=3yFb6=E9nraBfX-Ve=WjRkQMw@mail.gmail.com>
References: <nsxr4k2kdwv.fsf@closure.thunk.org>
	<20130227124727.GA225@x4>
	<20130227153435.GB5609@thunk.org>
	<20130227154450.GA23402@x4>
	<20130227170157.GA222@x4>
	<98C6DE45-F050-4AAD-82E2-7352F5BB0A5D@gmail.com>
	<20130227172256.GA236@x4>
	<7BFB2135-A1F0-4B6D-9962-16E75E5560F8@gmail.com>
	<20130227174553.GA224@x4>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "gnehzuil.liu" <gnehzuil.liu@gmail.com>,
	"Theodore Ts'o" <tytso@mit.edu>, Zheng Liu <wenqing.lz@taobao.com>,
	Dave Jones <davej@redhat.com>, Borislav Petkov <bp@alien8.de>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ve0-f176.google.com ([209.85.128.176]:61684 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760417Ab3B0Rwq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 27 Feb 2013 12:52:46 -0500
In-Reply-To: <20130227174553.GA224@x4>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 27, 2013 at 9:45 AM, Markus Trippelsdorf
<markus@trippelsdorf.de> wrote:
>
> git revert 06b0c886214a223dde7b21cbfc3008fd20a8ce16..74cd15cd02708c7188581f279f33a98b2ae8d322
> fixes all issues...

Hmm. I'm hoping this will have a quick resolution that doesn't mean
having to revert all that. But it's good to have the option.

Zheng, Ted, I'm holding up further merging (ugh, second time this
merge window) in the hope that we can get this sorted out quickly. I
hate continuing to merge stuff when there are known nasty issues
pending in my tree.

I can't hold for all that long, but it would be really nice if this
got sorted out quickly.

                   Linus
