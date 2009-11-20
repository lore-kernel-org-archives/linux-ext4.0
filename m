From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: norecovery option for ext3
Date: Fri, 20 Nov 2009 09:46:18 -0600
Message-ID: <4B06B9CA.1030502@redhat.com>
References: <20091120122403.GD15422@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28943 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752540AbZKTPqU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 20 Nov 2009 10:46:20 -0500
In-Reply-To: <20091120122403.GD15422@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jan Kara wrote:
>   Hi,
> 
>   I've tried to test noload/norecovery option of ext3 and I've found it
> simply does not work. The filesystem does not even mount. There are two
> problems:
>   1) the code checking for NOLOAD in ext3_fill_super is simply wrong
>      and ends up failing the mount whenever NOLOAD is set with a message
>      "ext3: No journal on filesystem on <dev>"
>   2) if one fixes the check, we end up oopsing a few lines below when
>      calling journal_check_available_features() with journal == NULL.
> 
>   Given that nobody used the option (OK, some googling shows that somebody
> tried to use it in *2.4.9* kernel and it didn't work even there - Stephen
> Tweedie comments that it's an obsolete option meant for use during fs
> development) and seeing how badly corrupted the filesystem is when you
> don't replay the journal, I'd just remove the option. Any opinions?
> 
> 								Honza

Oh, sigh.  Sorry, didn't actually, er, test it, since I was just adding
an alias for the option... bleah.

I think we should fix it; there are cases when you may want to mount that
way, I think - for example, otherwise there is no way at all to mount
a block device which is marked readonly...

-Eric
