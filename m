From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 4/8] Add test of quota accounting using fsx
Date: Tue, 27 Jul 2010 08:11:30 -0500
Message-ID: <9EBA299E-8A0B-4610-B8FA-3A97FECFA0A4@sandeen.net>
References: <1274710459-11446-1-git-send-email-jack@suse.cz> <1274710459-11446-5-git-send-email-jack@suse.cz> <4C0FD43D.3040803@sandeen.net> <20100615095505.GB3347@quack.suse.cz> <4C4E0229.5040002@sandeen.net> <20100727081538.GB3358@quack.suse.cz> <20100727084848.GC3358@quack.suse.cz>
Mime-Version: 1.0 (iPhone Mail 8A293)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Jan Kara <jack@suse.cz>, "hch@infradead.org" <hch@infradead.org>,
	"xfs@oss.sgi.com" <xfs@oss.sgi.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 64-131-60-146.usfamily.net ([64.131.60.146]:60954 "EHLO
	mail.sandeen.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809Ab0G0NLP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 27 Jul 2010 09:11:15 -0400
In-Reply-To: <20100727084848.GC3358@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jul 27, 2010, at 3:48 AM, Jan Kara <jack@suse.cz> wrote:

>>> 
>>  Just last week a change went into xfstests which introduces a generic
>> quota checking function and uses sync before getting quota usage. I think
>> xfstests passed for me with ext4 after this change but I've now restarted
>> the tests to recheck it.
>  For me all the quota tests pass just fine with ext4 and the latest
> xfstests... So does the latest version work also for you?
> 
Whoops sorry, they do pass for me in the devel tree; I had missed that recent change and I guess our qa had tested a tree without it.  I wondered why it didn't work for them...  Sorry for the noise....

Eric

>                                    Honza
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
> 
